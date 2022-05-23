//
//  ContentView.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct MainView: View {
    
    @State var showDetailStock: Stock?
    
    var body: some View {
        NavigationView {
            List {
                favoriteStocksSection
                allStocksSection
            }
            .navigationTitle("Stocks")
            .toolbar(content: {
                toolbarItems
            })
            .sheet(item: $showDetailStock) { stock in
                DetailView(stock: stock)
            }
        }
    }
    
    var favoriteStocksSection: some View {
        Section {
            
            ForEach(Stock.favorites()) { stock in
                
                StockCell(stock: stock)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showDetailStock = stock
                    }
                
            }
        } header: {
            HStack {
               
                // Since the header says Stocks,
                // we can remove the redundant "stocks" here
                Text("Favorites")
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Tap for more")
                }
                
            }
        } footer: {
            Text("Favorite stocks are updated every 1 minute.")
        }
        
    }
    
    var allStocksSection: some View {
        Section {
            
            ForEach( Stock.all() ) { stock in
                
                StockCell(stock: stock)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showDetailStock = stock
                    }
                
            }
            
        } header: {
            Text("All")
        }
    }
    
    var toolbarItems: some ToolbarContent {
        Group {
            // Move the Settings button to trailing
            // (The leading is typically where a back button goes)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "gearshape.fill")
                            .accessibilityHidden(true)
                        Text("Customize")
                    }
                    .accessibilityElement(children: .combine)
                    
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
