//
//  IndividualEventLogView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/24/23.
//

import SwiftUI

struct IndividualEventLogView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation
    @State var individualEvent: UserEvent
    
    @Binding var dataConfig: modifyDataConfig

    
    private let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)

    private let InfoLabelWidth: CGFloat = 70
    private let disabled: Bool = true
    
    @State private var isConfirming = false
    @State private var dialogDetail: String?
    
    @State var tempType: String = ""
    @State var tempUnits: String = ""
    @State var new_date = Date()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                gradient.opacity(GRADIENT_OPACITY).ignoresSafeArea()
                if individualEvent.isFault { EmptyView() }
                else {
                    VStack {
                        // Form
                        // ===================================================
                        Form {
                            Section { // (header: Text("Edit Entry Details"))
                                HStack {
                                    Text("Date").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                    DatePicker("", selection: $individualEvent.timestamp, displayedComponents: [.date, .hourAndMinute])
                                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                HStack {
                                    Text("Name").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                    TextField(text: $individualEvent.name) { Text("Name") }
                                        .foregroundColor(.gray).disabled(disabled)
                                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                HStack {
                                    Text("Type").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                    TextField(text: $tempType) { Text("Type") }
                                        .foregroundColor(.gray)
                                        .disabled(disabled)
                                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                HStack {
                                    Text("Quantity").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                    TextField(value: $individualEvent.quantity, format: .number) { Text("Quantity") }
                                }
                                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                                HStack {
                                    Text("Units").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                    TextField(text: $tempUnits) { Text("Units") }
                                        .foregroundColor(.gray).disabled(disabled)
                                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height*0.33)
                        .textFieldStyle(.roundedBorder)
                        .scrollContentBackground(.hidden)
                        
                        
                        // Delete Button
                        // ===================================================
                        Button {
                            isConfirming = true
                            dialogDetail = "Delete entry for \(individualEvent.name) (\(myNumberFormatter.string(for: individualEvent.quantity)!) \(tempUnits))?"
                        } label: {
                            Text("Delete Entry").font(.title3).padding(.horizontal)
                        }
                        .buttonStyle(.borderedProminent).tint(.pink)
                        .confirmationDialog(
                            "Are you sure you want to delete this preset?",
                            isPresented: $isConfirming, presenting: dialogDetail
                        ) { detail in
                            Button{ deleteEntry() } label: { Text("\(detail)") }
                            Button("Cancel", role: .cancel) { dialogDetail = nil }
                        }
                        
                        
                        Spacer()
                    } // end VStack
                }
                
            }
        } // end NavigationView
        .onAppear{
            tempType = individualEvent.type ?? ""
            tempUnits = individualEvent.units ?? ""
        }
        .onDisappear{
            dataConfig.notifyChanges()
        }
    } // end View body
    
    
    
    // function for deleting entry
    // ===================================================
    private func deleteEntry() {
        // close View
        self.presentation.wrappedValue.dismiss()
        
        // delete and save changes        
        viewContext.delete(individualEvent)
        do { try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    
    
    
    
    
}

struct IndividualEventLogView_Previews: PreviewProvider {
    static var previews: some View {
        @State var previewEvent: IndividualPreset = PersistenceController.preview.container.viewContext.registeredObjects.first(where: { $0 is IndividualPreset }) as! IndividualPreset
        
        let context = PersistenceController.preview.container.viewContext
        let preview = UserEvent.init(context: context)
        preview.timestamp = Date()
        preview.type      = "Supplement"
        preview.name      = "Caffiene"
        preview.quantity  = 200
        preview.units     = "mg"
        
        @State var dataConfig: modifyDataConfig = modifyDataConfig()
        
        return IndividualEventLogView(individualEvent: preview, dataConfig: $dataConfig)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
