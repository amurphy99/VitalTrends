//
//  presetFormHelper.swift
//  murand0
//
//  Created by Andrew Murphy on 7/2/23.
//

import Foundation
import SwiftUI




// Main Info Section
func presetMainInfoSection(_ formData: (Binding<String>, Binding<Float>, Binding<String>), header: some View, hasName: Bool = false, name: Binding<String> = .constant("")) -> some View {
    
    let infoLabelWidth: CGFloat = 70
    
    return Section ( header: header ) {
        
        // Name (optional)
        if hasName {
            HStack {
                Text("Name").newPresetTextField(infoLabelWidth)
                TextField(text: name) { Text("Name") }
            }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        }
        
        // Type
        HStack {
            Text("Type").newPresetTextField(infoLabelWidth)
            TextField(text: formData.0) { Text("Type") }
        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // Quantity
        HStack {
            Text("Quantity").newPresetTextField(infoLabelWidth)
            TextField(value: formData.1, format: .number) { Text("Quantity") }
        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // Units
        HStack {
            Text("Units").newPresetTextField(infoLabelWidth)
            TextField(text: formData.2) { Text("Units") }
        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
    }
    
    
    
    
}




// Stock Section
func presetStockSection(_ formData: (Binding<Int16>, Binding<Float>, Binding<Bool>, Binding<Int>), header: some View, hasFooter: Bool = false) -> some View {
    
    let stockLabelWidth: CGFloat = 125
    var footerText: String = ""
    if hasFooter {
        footerText = "When enabled, every time you use this preset it will deduct one unit of 'stock' from your total. If notifications are on, you will be shown an alert once your stock goes below a set number."
    }
    
    return Section (header: header, footer: Text("\(footerText)")) {
        // Current Stock
        HStack {
            Text("Current Stock").newPresetTextField(stockLabelWidth)
            TextField(value: formData.0, format: .number) { Text("Current Stock") }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // Taken Per Week
        HStack {
            Text("Taken Per Week").newPresetTextField(stockLabelWidth)
            TextField(value: formData.1, format: .number) { Text("Taken Per Week") }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // Days Left (calculated value)
        HStack {
            Text("Days Left:").newPresetTextField(stockLabelWidth)
            if formData.1.wrappedValue > 0  {
                Text("\( Int((Float(formData.0.wrappedValue) / formData.1.wrappedValue)*7) )")
            }
            else { Text("--") }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // Notify When Low (on/off)
        HStack { Toggle("Notify When Low?", isOn: formData.2) }
            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // Notify Below (threshold)
        HStack {
            Text("Notify Below").newPresetTextField(stockLabelWidth)
            TextField(value: formData.3, format: .number) { Text("Notify Below Days Left") }
                .disabled(!formData.2.wrappedValue)
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
    }
}


// Triggered Notification Section
func presetTriggerNotificationSection(_ formData: (Binding<Bool>, Binding<String>, Binding<Int>, Binding<Int>), header: some View, hasFooter: Bool = false) -> some View {
    
    var footerText: String = ""
    if hasFooter {
        footerText = "When enabled, every time you use this preset, after the set time period your phone will trigger a notification to send you."
    }
    
    return Section (header: header, footer: Text("\(footerText)")) {
        
        // toggle on/off
        HStack { Toggle("Trigger Notifications?", isOn: formData.0) }
            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // message
        VStack(spacing: 5) {
            HStack {
                Text("Notification Message")
                Spacer()
            }
            TextField(text: formData.1, axis: .vertical) { Text("Notification Text") }
                .disabled(!formData.0.wrappedValue)
                .lineLimit(2, reservesSpace: true)
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // time delay
        VStack(spacing: 0) {
            HStack { Text("Time Delay"); Spacer() }
            HStack(spacing: 0) {
                Spacer()
                
                Picker("Hours", selection: formData.2) {ForEach(0...24, id: \.self) { Text("\($0)") }}
                .pickerStyle(.wheel).frame(width: 60, height: 100)
                Text("Hours")
                
                Spacer().frame(width: 10)
                
                Picker("Minutes", selection: formData.3) {ForEach(0...59, id: \.self) { Text("\($0)") }}
                .pickerStyle(.wheel).frame(width: 60, height: 100)
                Text("Minutes")
                
                Spacer()
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
    }
}

