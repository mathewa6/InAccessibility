//
//  CustomizeView.swift
//  InAccessibility
//
//  Created by Adi on 5/23/22.
//

import SwiftUI

struct CustomizeView: View {
    
    @Binding var showCustomize: Bool
    
    var body: some View {
        
        NavigationView{
            Text("Customizer")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showCustomize.toggle()
                    }
                }
            }
        }
        .accessibilityAction(.escape) {
            showCustomize.toggle()
        }
        
    }
}

struct CustomizeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeView(showCustomize: .constant(true))
    }
}
