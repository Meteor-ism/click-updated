import SwiftUI
import Combine

struct Edit: View {
    @AppStorage("edited") private var edited = 0
    @State private var editedS = false
    @AppStorage("hacks") private var hacks = 0
    @State private var hacksS = false
    @AppStorage("presses") private var presses = 0
    @State private var pressesS = "0"
    @State var display: Binding<Bool>
    @State private var doneInit = false
    var body: some View {
        if (!doneInit) {
            var _ = Task {
                if (edited == 1) {
                    editedS = true
                }
                if (hacks == 1) {
                    hacksS = true
                }
                pressesS = String(presses)
                doneInit = true
            }
        }
        Toggle(isOn: $editedS) {
            Text("Is Edited: ")
        }
        Toggle(isOn: $hacksS) {
            Text("Hacks: ")
        }
        HStack {
            Text("Clicks: ")
            TextField("", text: $pressesS).keyboardType(.numberPad).onReceive(Just(pressesS)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.pressesS = filtered
                }
            }
        }
        Button(action: {
            if (editedS) {
                edited = 1
            } else {
                edited = 0
            }
            if (hacksS) {
                hacks = 1
            } else {
                hacks = 0
            }
            presses = Int(pressesS)!
            display.wrappedValue = false
        }, label: {
            Text("Save")
        })
    }
}
