import SwiftUI

struct ContentView: View {
    @AppStorage("hadHacks") private var hadHacks = false
    @State private var noExport = false
    @AppStorage("hiddenHackA") private var hiddenHackA = false
    @AppStorage("edited") private var edited = 0
    @AppStorage("hacks") private var hacks = 0
    @AppStorage("presses") private var presses = 0
    @State private var reset = false
    @AppStorage("hackMenuMessage") private var hackMenuMessage = true
    @State private var hackMenu = false
    @State private var hideHSDWarning = false
    @State private var edit = false
    var body: some View {
        if (hacks == 1) {
            var _ = Task {
                hadHacks = true
            }
        } else if (hadHacks && edited == 0) {
            var _ = Task {
                noExport = true
            }
        } else {
            var _ = Task {
                noExport = false
            }
        }
        NavigationSplitView {
            Text("").frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .center).background(alignment: .center, content: {
                VStack {
                    NavigationLink(destination: Game()) {
                        Text("Play")
                    }.navigationTitle("Click")
                    Text("\n")
                    NavigationLink(destination: Editor()) {
                        Text("Edit some save data")
                    }
                    Text("\n")
                    GroupBox {
                        NavigationLink(destination: Export()) {
                            Text("Export save data")
                        }.disabled(noExport)
                        Text("")
                        NavigationLink(destination: Import()) {
                            Text("Import save data")
                        }
                    }
                }
            })
            if (hacks == 1){
                Button(action: {
                    hackMenu = true
                }, label: {
                    Text(" ")
                }).confirmationDialog("Hack Menu", isPresented: $hackMenu, titleVisibility: .visible, actions: {
                    Button(role: .none, action: {
                        if (hideHSDWarning) {
                            hideHSDWarning = false
                        } else {
                            hideHSDWarning = true
                        }
                    }, label: {
                        if (hideHSDWarning) {
                            Text("Show the \"Hacked Save File\" Warning")
                        } else {
                            Text("Hide the \"Hacked Save File\" Warning")
                        }
                    })
                    Button(role: .none, action: {
                        edit = true
                    }, label: {
                        Text("Edit the Active Save")
                    })
                    Button(role: .cancel, action: { }, label: {
                        Text("Close")
                    }).keyboardShortcut(.defaultAction)
                }).sheet(isPresented: $edit) { 
                    Edit(display: $edit)
                }.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            }
            Button(action: {
                reset = true
            }, label: {
                Text("Reset")
            }).confirmationDialog("Are you sure you want to reset?", isPresented: $reset, titleVisibility: .visible) {
                Button(role: .destructive, action: {
                    hiddenHackA = false
                    if (noExport) {
                        hiddenHackA = true
                    }
                    presses = 0
                    hacks = 0
                    edited = 0
                    hackMenuMessage = true
                    hadHacks = false
                }, label: {
                    Text("Yes")
                })
                Button(role: .cancel, action: { }, label: {
                    Text("No")
                }).keyboardShortcut(.defaultAction)
            }
            if (edited == 1 && hacks == 0) {
                Text("Edited Save Data")
            }
            if (hacks == 1 && !hideHSDWarning) {
                Text("Hacked Save Data").confirmationDialog("Tap above the reset button to access the hack menu.", isPresented: $hackMenuMessage, titleVisibility: .visible) { }
            }
        } detail: {
            
        }.toolbar(content: {
            ToolbarTitleMenu()
        })
    }
}
