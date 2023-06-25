//
//  GroupPresetInfoView.swift
//  murand0
//
//  Created by Andrew Murphy on 6/25/23.
//

import SwiftUI

struct GroupPresetInfoView: View {
    
    // CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation
    @State var userIndividualPresets = [IndividualPreset]()
    @State var groupPreset: GroupPreset
    
    // background color
    let gradient = LinearGradient(colors: [.orange, .cyan],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    @State private var editMode = EditMode.active
    private let listHeight: CGFloat = UIScreen.main.bounds.height*0.55
    

    var body: some View {
        ZStack {
            gradient.opacity(GRADIENT_OPACITY).ignoresSafeArea()
            VStack {
                // Name
                // ===================================================
                VStack (alignment: .leading, spacing: 5) {
                    Text("New Preset Name:").fontWeight(.semibold)
                    TextField(text: $groupPreset.name) { Text("Name") }
                    Divider().padding(.top, 10)
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .padding(.top)
                
                // List of entries
                // ===================================================
                ScrollView {
                    LazyVStack {
                        List(selection: $groupPreset.entries) {
                            Section (
                                header: Text("Included Individual Presets:")
                                    .foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil)
                                    .listRowInsets(SECTION_EDGE_INSETS),
                                footer:
                                    Text("\(userIndividualPresets.count) items, \(groupPreset.entries.count) selected")
                            ){
                                ForEach(userIndividualPresets, id: \.self) { preset in
                                    Text("\(preset.name) (\(myNumberFormatter.string(for: preset.quantity)!) \(preset.units))")
                                }
                            }
                        }
                        .environment(\.editMode, $editMode)
                        .frame(height: listHeight)
                        .scrollContentBackground(.hidden)
                        
                    }
                }
                .frame(height: listHeight)
                
                
                // Delete button
                // ===================================================
                VStack {
                    Divider()
                    
                    Button {
                        deletePreset()
                    } label: { Text("Delete Preset").font(.title3).padding(.horizontal) }
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
                }
                .padding(.horizontal)
                
                
                
                Spacer()
            } // end main VStack
        }
        .onAppear {
            userIndividualPresets = loadIndividualPresets(viewContext: viewContext)
            
        }
        
    } // end of View body
    
    
    // function for deleting preset
    // ===================================================
    private func deletePreset() {
        // delete
        viewContext.delete(groupPreset)
        
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




struct GroupPresetInfoView_Previews: PreviewProvider {
    static var previews: some View {
        @State var previewPreset: GroupPreset = PersistenceController.preview.container.viewContext.registeredObjects.first(where: { $0 is GroupPreset }) as! GroupPreset
        
        GroupPresetInfoView(groupPreset: previewPreset)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
