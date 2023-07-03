//
//  NotificationsView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/25/23.
//

import SwiftUI

struct NotificationsView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @State var userIndividualPresetNotifications = [IndividualPresetNotifications]()
    
    @State var showingCreateNewNotification: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                //NOTIFICATIONS_GRADIENT.opacity(GRADIENT_OPACITY).ignoresSafeArea()
                gradientBackgrounds().notificationsGradient().opacity(GRADIENT_OPACITY).ignoresSafeArea()
                ScrollView {
                    LazyVStack {
                        List {
                            
                            Section (header:
                                        Text("Stock Notifications")
                                .listSectionHeader()
                                .listRowInsets(SECTION_EDGE_INSETS)
                                .padding(.top)
                            ) {
                                ForEach(userIndividualPresetNotifications, id: \.self) { notif in
                                    if notif.notifyWhenLow { Text("\(notif.preset.name)") }
                                }
                            }
                            
                            Section (header: Text("Triggered Notifications").listSectionHeader().listRowInsets(SECTION_EDGE_INSETS)) {
                                ForEach(userIndividualPresetNotifications, id: \.self) { notif in
                                    if notif.triggerNotification { Text("\(notif.preset.name)") }
                                }
                            }

                            
                            
                            
                            
                            
                        }
                        .scrollContentBackground(.hidden)
                        .frame(height: UIScreen.main.bounds.height)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading){
                                Text("Notifications").font(.title).fontWeight(.semibold)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { showingCreateNewNotification = true }) { Label("Add Item", systemImage: "plus") }
                            }
                        }
                    }
                }
            } // end of parent ZStack
        } // end of NavigationView
        .onAppear {
            userIndividualPresetNotifications = loadIndividualPresetNotifications(viewContext: viewContext)
            
            // only need this if previewing
            UINavigationBar.appearance().standardAppearance   = navBarStyle()
            UINavigationBar.appearance().scrollEdgeAppearance = navBarStyle()
        }
    } // end of View body
    
}



struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
