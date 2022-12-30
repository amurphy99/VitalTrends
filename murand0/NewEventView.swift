//
//  NewEventView.swift
//  murand0
//
//  Created by Andrew Murphy on 12/29/22.
//

import SwiftUI

struct NewEventView: View {
    
    // for single event
    @Binding var new_type:      String
    @Binding var new_name:      String
    @Binding var new_quantity:  Float
    @Binding var new_units:     String
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(spacing: 10) {
                Text("Single Entry Form:").frame(width: geo.size.width * 0.8, alignment: .leading)
                Divider().frame(width: geo.size.width * 0.8)
                
                VStack(alignment: .center) {
                    // Type
                    // -----
                    HStack(spacing: 0) {
                        Text("Type:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Type", text: $new_type)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                    }
                    .frame(width: geo.size.width * 0.9)
                    
                    // Name
                    // -----
                    HStack(spacing: 0) {
                        Text("Name:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Name", text: $new_name)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                    }
                    .frame(width: geo.size.width * 0.9)
                    
                    // Quantity
                    // ---------
                    HStack(spacing: 0) {
                        Text("Quantity:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Quantity", value: $new_quantity, format: .number)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                    }
                    .frame(width: geo.size.width * 0.9)
                    
                    // Units
                    // ------
                    HStack(spacing: 0) {
                        Text("Units:").frame(width: geo.size.width * 0.20, alignment: .leading)
                        TextField("Units", text: $new_units)
                            .frame(width: geo.size.width * 0.6, alignment: .leading).padding(2).border(Color.gray, width: 1)
                    }
                    .frame(width: geo.size.width * 0.9)
                }
            }
        }
        
        
        
        
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(new_type: .constant(""), new_name: .constant(""), new_quantity: .constant(0), new_units: .constant(""))
    }
}
