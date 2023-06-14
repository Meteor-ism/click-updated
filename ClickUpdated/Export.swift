import SwiftUI

struct Export: View {
    @AppStorage("edited") private var edited = 0
    @AppStorage("hacks") private var hacks = 0
    @AppStorage("presses") private var presses = 0
    var body: some View {
        let publicKey = generatePublicKey()
        let symmetricKey = createSymmetricKey(publicKey)
        GroupBox {
            Text("Here is Your Save Data")
            TextEditor(text: .constant(encryptText(String(edited) + "\n" + String(hacks) + "\n" + String(presses), symmetricKey) + "\n" + publicKeyToString(publicKey)))
            Button(action: {
                UIPasteboard.general.string = encryptText(String(edited) + "\n" + String(hacks) + "\n" + String(presses), symmetricKey) + "\n" + publicKeyToString(publicKey)
            }, label: {
                Text("Copy to Clipboard")
            })
        }
    }
}
