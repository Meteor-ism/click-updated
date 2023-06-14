import SwiftUI
import Combine

struct Editor: View {
    @State private var step = 0
    @State private var hacks = 0
    @State private var hacksBool = false
    @State private var presses = ""
    @State private var save = ""
    var body: some View {
        var _ = Task {
            save = UIPasteboard.general.string ?? ""
        }
        if (step == 0) {
            GroupBox {
                Text("Paste Save Data Here")
                TextEditor(text: $save)
                Button(action: {
                    let sk = save.split(separator: "\n")
                    let publicKey = stringToPublicKey(String(sk[1]))
                    let symmetricKey = createSymmetricKey(publicKey)
                    let saveData = decryptText(String(sk[0]), symmetricKey).split(separator: "\n")
                    hacks = Int(saveData[1])!
                    if (hacks == 1) {
                        hacksBool = true
                    }
                    presses = String(saveData[2])
                    step = 1
                }, label: {
                    Text("Edit this Save")
                })
            }
        } else if (step == 1) {
            VStack(alignment: .leading) {
                Toggle(isOn: $hacksBool) {
                    Text("Hacks: ")
                }
                HStack {
                    Text("Clicks: ")
                    TextField("", text: $presses).keyboardType(.numberPad).onReceive(Just(presses)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.presses = filtered
                        }
                    }
                }
            }
            Button(action: {
                step = 2
            }, label: {
                Text("Finish Editing")
            })
        } else {
            var _ = Task {
                if (hacksBool) {
                    hacks = 1
                } else {
                    hacks = 0
                }
            }
            let publicKey = generatePublicKey()
            let symmetricKey = createSymmetricKey(publicKey)
            GroupBox {
                Text("Here is Your Save Data")
                TextEditor(text: .constant(encryptText("1\n" + String(hacks) + "\n" + presses, symmetricKey) + "\n" + publicKeyToString(publicKey)))
                Button(action: {
                    UIPasteboard.general.string = encryptText("1\n" + String(hacks) + "\n" + presses, symmetricKey) + "\n" + publicKeyToString(publicKey)
                }, label: {
                    Text("Copy to Clipboard")
                })
            }
        }
    }
}
