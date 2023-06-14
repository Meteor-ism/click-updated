import SwiftUI

struct Game: View {
    @AppStorage("presses") private var presses = 0
    @AppStorage("hiddenHackA") private var hiddenHackA = false
    @AppStorage("hiddenHacks") private var hiddenHacks = false
    @State private var hackA = false
    @State private var hackMenu = false
    var body: some View {
        Button(action: {
            presses += 1
        }, label: {
            Text(String(presses)).bold().background(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 12.5).fill(Color(UIColor(
                    red: 128/255.0,
                    green: 128/255.0,
                    blue: 128/255.0,
                    alpha: 128/255.0
                ))).frame(width: 50, height: 50, alignment: .center)
            }).frame(width: 50, height: 50, alignment: .center).contextMenu(menuItems: {
                Text("This is Click, not Hold.")
            })
        }).navigationBarItems(trailing: HStack {
            Button(action: {
                hackA = true
            }, label: {
                Text("")
            }).disabled(!hiddenHackA)
            Button(action: {
                hackMenu = true
            }, label: {
                Text("")
            }).disabled(!hiddenHacks)
        }).confirmationDialog("Turn on hacks?", isPresented: $hackA, titleVisibility: .visible, actions: {
            Button(role: .destructive, action: {
                hiddenHackA = false
                hiddenHacks = true
            }, label: {
                Text("Yes")
            })
            Button(role: .cancel, action: {
                hiddenHackA = false
            }, label: {
                Text("No")
            }).keyboardShortcut(.defaultAction)
        }).sheet(isPresented: $hackMenu) { 
            Hacks(display: $hackMenu)
        }
    }
}
