import SwiftUI
import CryptoKit

struct Import: View {
    @AppStorage("edited") private var edited = 0
    @AppStorage("hacks") private var hacks = 0
    @AppStorage("presses") private var presses = 0
    @AppStorage("hackMenuMessage") private var hackMenuMessage = true
    @State private var save = ""
    @State private var sk = [Substring()]
    @State private var publicKey: P256.KeyAgreement.PublicKey?
    @State private var symmetricKey: SymmetricKey?
    @State private var saveData = [Substring()]
    @State private var hackWarning = false
    var body: some View {
        var _ = Task {
            save = UIPasteboard.general.string ?? ""
        }
        GroupBox {
            Text("Paste Save Data Here")
            TextEditor(text: $save)
            Button(action: {
                sk = save.split(separator: "\n")
                publicKey = stringToPublicKey(String(sk[1]))
                symmetricKey = createSymmetricKey(publicKey!)
                saveData = decryptText(String(sk[0]), symmetricKey!).split(separator: "\n")
                if (Int(saveData[1]) == 0 || Int(saveData[0]) == 0) {
                    edited = Int(saveData[0])!
                    hacks = Int(saveData[1])!
                    presses = Int(saveData[2])!
                    hackMenuMessage = true
                } else {
                    hackWarning = true
                }
            }, label: {
                Text("Import")
            }).confirmationDialog("This save has hacks enabled. Do you want to proceed?", isPresented: $hackWarning, actions: {
                Button(role: .destructive, action: {
                    edited = Int(saveData[0])!
                    hacks = Int(saveData[1])!
                    presses = Int(saveData[2])!
                    hackMenuMessage = true
                }, label: {
                    Text("Yes")
                })
                Button(action: {
                    edited = Int(saveData[0])!
                    hacks = 0
                    presses = Int(saveData[2])!
                    hackMenuMessage = true
                }, label: {
                    Text("Yes, but turn off hacks")
                })
                Button(role: .cancel, action: { }, label: {
                    Text("No")
                }).keyboardShortcut(.defaultAction)
            })
        }
    }
}
