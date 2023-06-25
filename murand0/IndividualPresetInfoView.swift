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
    
    // background color
    let gradient = LinearGradient(colors: [.orange, .cyan],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    // styling variables
    private let StockLabelWidth: CGFloat = 130
    private let InfoLabelWidth: CGFloat = 70
    
    
    @State private var canDelete: Bool = false
    
    @State var numberOfUnits: Int = 30
    @State var takenPerWeek: Float = 7
    
    
    var body: some View {
        ZStack {
            gradient.opacity(GRADIENT_OPACITY).ignoresSafeArea()
            VStack {
                List {
                    // add or update a total amount in stock
                    // ===================================================
                    Section (header:
                                Text("Track Stock")
                        .foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil)
                        .listRowInsets(SECTION_EDGE_INSETS)
                        .padding(.top)
                    ) {
                        HStack {
                            Text("Current Stock").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                            TextField(value: $numberOfUnits, format: .number) { Text("Current Stock") }
                        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                        HStack {
                            Text("Taken Per Week").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                            TextField(value: $takenPerWeek, format: .number) { Text("Taken Per Week") }
                        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                        
                        HStack {
                            Text("Days Left").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                            if takenPerWeek > 0 { Text("\( Int((Float(numberOfUnits) / takenPerWeek)*7) )") }
                            else                { Text("--")                                                }
                        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                    }
                    // modify the Info on the preset, or delete
                    // ===================================================
                    Section (header:
                                Text("Edit Preset Info")
                        .foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil)
                        .listRowInsets(SECTION_EDGE_INSETS)
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
                    // ===================================================
                    Section (header:
                                Text("Included In (\(Array(individualPreset.parent_preset ?? []).count)) Groups")
                        .foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil)
                        .listRowInsets(SECTION_EDGE_INSETS)
                    ) {
                        ForEach(Array(individualPreset.parent_preset ?? []), id: \.self) { group in
                            Text("\(group.name)")
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height*0.65) // 185 + 240
                .textFieldStyle(.roundedBorder)
                .scrollContentBackground(.hidden)
                
                
                // Delete button
                // ===================================================
                VStack {
                    Divider()
                    
                    if !canDelete { Text("remove from all groups to delete").fontWeight(.light).foregroundColor(.gray) }
                
                    Button {
                        deletePreset()
                    } label: { Text("Delete Preset").font(.title3).padding(.horizontal) }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canDelete)
                }
                .padding(.horizontal)
                
                
                Spacer()
                
            } // end of VStack
            .onAppear {
                canDelete = (Array(individualPreset.parent_preset ?? []).count == 0)
            }
            
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
        
        IndividualPresetInfoView(individualPreset: previewPreset)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
