//
//  SuperTextField.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import Foundation
import SwiftUI

struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var colors = Colors()
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .autocapitalization(.none)
        }
    }
    
}
