//
//  presetFormHelper.swift
//  murand0
//
//  Created by Andrew Murphy on 7/2/23.
//

import Foundation
import SwiftUI






/*
 Section (header:
     HStack {
         Text("Stock Info").foregroundColor(.black).font(.title3).fontWeight(.semibold).textCase(nil)
         Text("(optional)").textCase(nil)
     }.listRowInsets(SECTION_EDGE_INSETS)
 ) {
     HStack {
         Text("Current Stock").newPresetTextField(StockLabelWidth)
         TextField(value: $numberOfUnits, format: .number) { Text("Current Stock") }
     }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
     
     HStack {
         Text("Taken Per Week").newPresetTextField(StockLabelWidth)
         TextField(value: $perWeek, format: .number) { Text("Taken Per Week") }
     }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
     
     HStack {
         Text("Days Left:").newPresetTextField(StockLabelWidth)
         if perWeek > 0 { Text("\( Int((Float(numberOfUnits) / perWeek)*7) )") }
         else           { Text("--")                                           }
     }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
     
     HStack { Spacer()
         Toggle("Notify When Low?", isOn: $notifyWhenLow).frame(width: 250, alignment: .center)
         Spacer()
     }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
     
     HStack {
         Text("Notify Below").newPresetTextField(StockLabelWidth)
         TextField(value: $notifyBelow, format: .number) { Text("Notify Below Days Left") }
             .disabled(!notifyWhenLow)
     }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
 }
 private let StockLabelWidth:    CGFloat = 125
 
 */
func presetStockSection(_ formData: (Binding<Int>, Binding<Float>, Binding<Bool>, Binding<Int>), header: some View) -> some View {
    
    let stockLabelWidth: CGFloat = 125
    
    return Section (header: header) {
                HStack {
                    Text("Current Stock").newPresetTextField(stockLabelWidth)
                    TextField(value: formData.0, format: .number) { Text("Current Stock") }
                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                
                HStack {
                    Text("Taken Per Week").newPresetTextField(stockLabelWidth)
                    TextField(value: formData.1, format: .number) { Text("Taken Per Week") }
                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                
                HStack {
                    Text("Days Left:").newPresetTextField(stockLabelWidth)
                    if formData.1.wrappedValue > 0  {
                        Text("\( Int((Float(formData.0.wrappedValue) / formData.1.wrappedValue)*7) )")
                    }
                    else { Text("--") }
                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                
                HStack { Spacer()
                    Toggle("Notify When Low?", isOn: formData.2).frame(width: 250, alignment: .center)
                    Spacer()
                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
                
                HStack {
                    Text("Notify Below").newPresetTextField(stockLabelWidth)
                    TextField(value: formData.3, format: .number) { Text("Notify Below Days Left") }
                        .disabled(!formData.2.wrappedValue)
                }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        }
}



func presetTriggerNotificationSection(_ formData: (Binding<Bool>, Binding<String>, Binding<Int>, Binding<Int>), header: some View) -> some View {
    
    let InfoLabelWidth: CGFloat = 70
    
    return Section (header: header) {
        
        // toggle on/off
        HStack {
            Spacer()
            Toggle("Trigger Notification?", isOn: formData.0).frame(width: 250, alignment: .center)
            Spacer()
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        // message
        VStack(spacing: 5) {
            HStack {
                Text("Message").newPresetTextField(InfoLabelWidth)
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

