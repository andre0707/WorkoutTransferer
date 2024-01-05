//
//  MultiPicker.swift
//  Workout Transferer
//
//  Created by Andre Albach on 05.01.24.
//

import SwiftUI

/// A picker which allows the selection of multiple items
struct MultiPicker<LabelView: View, SelectionLabelView: View, SelectionValue: Hashable & CustomStringConvertible>: View {
    /// The label of the picker itself
    let label: () -> LabelView
    /// The label for the selectable items which are presented in the picker
    let selectionLabel: (SelectionValue) -> SelectionLabelView
    
    /// All the availalbe options from which the user can pick
    let availableOptions: [SelectionValue]
    /// The options the user selected
    var selected: Binding<Set<SelectionValue>>
    
    /// The navigation title which will be displayed
    let navigationTitle: Text
    
    
    /// The body
    var body: some View {
        NavigationLink(destination: {
            MultiPickerView(selectionLabel: selectionLabel,
                            availableOptions: availableOptions,
                            selected: selected,
                            navigationTitle: navigationTitle)
        }, label: {
            label()
        })
    }
}


/// The multi picker view which lists all the options
struct MultiPickerView<LabelView: View, SelectionValue: Hashable & CustomStringConvertible>: View {
    
    /// The label for each option
    let selectionLabel: (SelectionValue) -> LabelView
    
    /// All the availalbe options from which the user can pick
    let availableOptions: [SelectionValue]
    /// The options the user selected
    @Binding var selected: Set<SelectionValue>
    
    /// The navigation title which will be displayed
    let navigationTitle: Text
    
    
    // The body
    var body: some View {
        List {
            ForEach(availableOptions, id: \.self) { option in
                Button(action: {
                    if selected.contains(option) {
                        selected.remove(option)
                    } else {
                        selected.insert(option)
                    }
                }, label: {
                    HStack {
                        selectionLabel(option)
                        
                        Spacer()
                        
                        if selected.contains(option) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                })
                .tag(option)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(navigationTitle)
    }
}


// MARK: - Preview

struct MultiPicker_Previews: PreviewProvider {
    static private let options = ["A", "B", "C"]
    @State static private var selection: Set<String> = ["A", "B"]
    
    static var previews: some View {
        NavigationStack {
            Form {
                MultiPicker(label: {
                    HStack {
                        Text("Multiselect")
                        Spacer()
                        Text(selection.sorted().joined(separator: ", "))
                            .foregroundStyle(.secondary)
                    }
                },
                            selectionLabel: { text in
                    Text(text.description)
                },
                            availableOptions: options,
                            selected: $selection,
                            navigationTitle: Text("Selection"))
            }
        }
    }
}
