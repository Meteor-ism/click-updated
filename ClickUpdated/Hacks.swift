import SwiftUI

struct Hacks: View {
    @State var display: Binding<Bool>
    @AppStorage("hiddenHacks") private var hiddenHacks = false
    var body: some View {
        HStack {
            Text("").frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            Button(action: {
                display.wrappedValue = false
            }, label: {
                Image(systemName: "multiply").resizable().frame(width: 20, height: 20, alignment: .center)
            }).frame(width: 50, height: 50, alignment: .center)
        }
        Text("").frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .center).background(alignment: .center, content: {
            VStack {
                NavigationStack {
                    NavigationLink(destination: Export()) {
                        Text("Export")
                    }
                    Text("\n")
                    Button(action: {
                        hiddenHacks = false
                        display.wrappedValue = false
                    }, label: {
                        Text("Turn off hacks")
                    })
                }
            }
        })
    }
}
