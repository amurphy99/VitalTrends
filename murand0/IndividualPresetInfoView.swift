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
    @State var individualPreset: PresetEntry
    
    // background color
    let gradient = LinearGradient(colors: [.orange, .cyan],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    private let StockLabelWidth: CGFloat = 130
    private let InfoLabelWidth: CGFloat = 70
    @State private var StockFormHeight: CGFloat?
    @State private var InfoFormHeight: CGFloat?
    
    @State var numberOfUnits: Int = 30
    @State var takenPerWeek: Float = 7
    // modify the Info on the preset, or delete
    // ===================================================
    
    var body: some View {
        ZStack {
            gradient.opacity(0.25).ignoresSafeArea()
            VStack {
                // add or update a total amount in stock
                // ===================================================
                VStack {
                    
                    // Form
                    Form {
                        Section (header:
                                    Text("Track Stock")
                            .foregroundColor(.black)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .textCase(nil)
                        ) {
                            HStack {
                                Text("Current Stock").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                TextField(value: $numberOfUnits, format: .number) { Text("Current Stock") }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                            HStack {
                                Text("Taken Per Week").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                TextField(value: $takenPerWeek, format: .number) { Text("Taken Per Week") }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                            
                            HStack {
                                Text("Days Left").fontWeight(.semibold).frame(width: StockLabelWidth, alignment: .trailing)
                                if takenPerWeek > 0 { Text("\( Int((Float(numberOfUnits) / takenPerWeek)*7) )") }
                                else                { Text("--")                                                }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                        }

                        Section ( header:
                                    Text("Edit Preset Info")
                            .foregroundColor(.black)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .textCase(nil)
                        ) {
                            HStack {
                                Text("Name").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                TextField(text: $individualPreset.name) { Text("Name") }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                            HStack {
                                Text("Type").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                TextField(text: $individualPreset.type) { Text("Type") }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                            HStack {
                                Text("Quantity").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                TextField(value: $individualPreset.quantity, format: .number) { Text("Quantity") }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                            HStack {
                                Text("Units").fontWeight(.semibold).frame(width: InfoLabelWidth, alignment: .trailing)
                                TextField(text: $individualPreset.units) { Text("Units") }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                        }
                    }
                    //.frame(height: 240) // 185 + 240
                    .textFieldStyle(.roundedBorder)
                    .scrollContentBackground(.hidden)
                    
                    
                }
                
                Spacer()
            } // end of VStack
            .onAppear {
                let tableHeaderView = UIView(frame: .zero)
                tableHeaderView.frame.size.height = 1
                UITableView.appearance().tableHeaderView = tableHeaderView
                
            }
        } // end of ZStack
    } // end of View body
}



struct IndividualPresetInfoView_Previews: PreviewProvider {
    static var previews: some View {
        @State var previewPreset: PresetEntry = PersistenceController.preview.container.viewContext.registeredObjects.first(where: { $0 is PresetEntry }) as! PresetEntry
        
        IndividualPresetInfoView( individualPreset: previewPreset)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
