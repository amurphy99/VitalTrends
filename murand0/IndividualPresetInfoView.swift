//
//  IndividualPresetInfoView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/24/23.
//

import SwiftUI

struct IndividualPresetInfoView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentation
    @State var individualPreset: IndividualPreset
    @Binding var dataConfig: modifyDataConfig
    

    // styling variables
    private let InfoLabelWidth: CGFloat = 70
    
    
    @State private var canDelete: Bool = false
    @State private var isConfirming = false
    @State private var dialogDetail: String?
    
    // Notifications
    // Stock
    @State var numberOfUnits: Int = 30
    @State var perWeek: Float = 7
    @State var notifyWhenLow: Bool = false
    @State var notifyBelow: Int = 0
    // Triggered Reminder
    @State var triggerNotification: Bool = false
    @State var triggerMessage: String = ""
    @State var triggerHours: Int = 0
    @State var triggerMinutes: Int = 0
    
    
    
    var body: some View {
        ZStack {
            PRESETS_GRADIENT.opacity(GRADIENT_OPACITY).ignoresSafeArea()
            VStack {
                List {
                    // modify the Info on the preset, or delete
                    // ------------------------------------------------------
                    Section (header:
                                Text("Edit Preset Info").listSectionHeader()
                        .listRowInsets(SECTION_EDGE_INSETS)
                        .padding(.top)
                    ) {
                        HStack {
                            Text("Name").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                            TextField(text: $individualPreset.name) { Text("Name") }
                        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                        HStack {
                            Text("Type").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                            TextField(text: $individualPreset.type) { Text("Type") }
                        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                        HStack {
                            Text("Quantity").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                            TextField(value: $individualPreset.quantity, format: .number) { Text("Quantity") }
                        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                        HStack {
                            Text("Units").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                            TextField(text: $individualPreset.units) { Text("Units") }
                        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                    }
                    
                    // Member of groups
                    // ------------------------------------------------------
                    Section (header:
                                Text("Included In (\(Array(individualPreset.parent_preset ?? []).count)) Groups").listSectionHeader()
                                    .listRowInsets(SECTION_EDGE_INSETS)
                    ) { ForEach(Array(individualPreset.parent_preset ?? []), id: \.self) { group in Text("\(group.name)") } }
                    
                    // add or update a total amount in stock
                    // ------------------------------------------------------
                    presetStockSection(
                        ($individualPreset.numberOfUnits, $individualPreset.perWeek, $notifyWhenLow, $notifyBelow),
                        header:
                            HStack {
                                Text("Edit Stock Info").listSectionHeader()
                                Text("(optional)").textCase(nil)
                            }.listRowInsets(SECTION_EDGE_INSETS),
                        hasFooter: true
                    )
                    
                    // Trigger Notification Info
                    // ------------------------------------------------------
                    presetTriggerNotificationSection(
                        ($triggerNotification, $triggerMessage, $triggerHours, $triggerMinutes),
                        header:
                            HStack {
                                Text("Notification Info").listSectionHeader()
                                Text("(optional)").textCase(nil)
                            }.listRowInsets(SECTION_EDGE_INSETS),
                        hasFooter: true
                    )
                    

                    

                }
                .frame(height: UIScreen.main.bounds.height*0.65) // 185 + 240
                .textFieldStyle(.roundedBorder).disableAutocorrection(true).autocapitalization(.none)
                .scrollContentBackground(.hidden)
                
                
                // Delete button
                // ===================================================
                VStack {
                    Divider()
                    
                    if !canDelete { Text("remove from all groups to delete").fontWeight(.light).foregroundColor(.gray) }
                
                    Button {
                        isConfirming = true
                        dialogDetail = "Delete \(individualPreset.name) (\(myNumberFormatter.string(for: individualPreset.quantity)!) \(individualPreset.units))?"
                    } label: { Text("Delete Preset").font(.title3).padding(.horizontal) }
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
                    .disabled(!canDelete)
                    .confirmationDialog(
                        "Are you sure you want to delete this preset?",
                        isPresented: $isConfirming, presenting: dialogDetail
                    ) { detail in
                        Button{ deletePreset() } label: { Text("\(detail)") }
                        Button("Cancel", role: .cancel) { dialogDetail = nil }
                    }
                }
                .padding(.horizontal)
                
                
                Spacer()
            } // end of VStack
            .onAppear { canDelete = (Array(individualPreset.parent_preset ?? []).count == 0) }
            .onDisappear { dataConfig.notifyChanges() }
            
        } // end of ZStack
    } // end of View body
    
    
    
    // function for deleting preset
    // ===================================================
    private func deletePreset() {
        // double check it isn't in anymore groups
        if !(Array(individualPreset.parent_preset ?? []).count == 0) { return }
        
        // delete
        viewContext.delete(individualPreset)
        
        // save
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        // close View
        self.presentation.wrappedValue.dismiss()
    }
    
    
    
    
}




struct IndividualPresetInfoView_Previews: PreviewProvider {
    static var previews: some View {
        @State var previewPreset: IndividualPreset = PersistenceController.preview.container.viewContext.registeredObjects.first(where: { $0 is IndividualPreset }) as! IndividualPreset
        
        @State var dataConfig: modifyDataConfig = modifyDataConfig()
        
        IndividualPresetInfoView(individualPreset: previewPreset, dataConfig: $dataConfig)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
