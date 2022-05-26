//
//  AddView.swift
//  InAccessibility
//
//  Created by Adi on 5/23/22.
//

import SwiftUI

struct AllStockView: View {
        
    @State private var showDetailStock: Stock?
    @State private var all: [Stock] = Stock.all()

    @Binding var showAddStock: Bool
    
    var allStocksSection: some View {
        
        Section {
            
            ForEach( all ) { stock in

                NavigationLink(destination: DetailView(stock: stock)) {

                    // Removed contentShape and onTapGesture to
                    // allow more generous and system-like tap behavior
                    StockCell(stock: stock)
                    
                }
                
            }
            
        }
        
    }

    var body: some View {
        
        NavigationView{
            List {
                allStocksSection
            }
            .navigationTitle("Add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showAddStock.toggle()
                    }
                }
            }
            .accessibilityAction(.escape) {
                showAddStock.toggle()
            }

        }

    }
}


struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AllStockView(showAddStock: .constant(true))
    }
}
