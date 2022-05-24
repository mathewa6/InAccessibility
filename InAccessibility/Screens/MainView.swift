//
//  ContentView.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct MainView: View {
    
    /// Formerly ContentSizeCategory
    @Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize
    
    @State var showDetailStock: Stock?
    
    // --- Model ---
    // Keep the stock lists as states
    // to prevent sudden flickering on the simulated timer
    @State var favorites: [Stock] = Stock.favorites()
    @State var all: [Stock] = Stock.all()
    
    // --- Timer/Auto updating ---
    // Simulate a minute based refresh
    let timer = Timer.publish(every: 60,
                              on: .main,
                              in: .common).autoconnect()
    @State var lastUpdatedTimestamp: Date = .init()
    @State var currentTimestamp: Date = .init()
    
    /// The number of minutes since the last refresh
    /// (by the user or automatic)
    /// Intended to fill in the format
    /// ```"Updated: \(intervalMinutes) ago."```
    private var intervalMinutes: String {
        let minuteCount: Int = Calendar.current
            .dateComponents([.minute],
                            from: lastUpdatedTimestamp,
                            to: currentTimestamp)
            .minute ?? 0
        
        if minuteCount < 1 {
            return "less than a minute"
        } else if minuteCount == 1 {
            return "a minute"
        } else if minuteCount > 1 {
            return "\(minuteCount) minutes"
        } else {
            return "an unknown while"
        }
        
    }
    
    // --- Views ---
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
            .refreshable {
                favorites = Stock.favorites()
                all = Stock.all()
                
                lastUpdatedTimestamp = Date()
            }
        }
        
    }
    
    var favoriteStocksSection: some View {
        Section {
            
            ForEach(favorites) { stock in
                
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
            
            Group {
                // Re-phrasing the footer text
                // to state what *has* happened and defer control to
                // the reader. The original copy stated what
                // *should* happen, but is ambiguous as to
                // the current state
                if dynamicTypeSize >= .accessibility4 {
                    
                    // For larger accessibility sizes, spacers
                    // prevent clipping and overlap of footer
                    VStack {
                        Spacer()
                        Text("Last updated: \(intervalMinutes) ago.")
                        Spacer()
                    }
                } else {
                    Text("Last updated: \(intervalMinutes) ago.")
                }
                
            }
            .onReceive(timer) { date in
                currentTimestamp = date
            }

            
        }
        
    }
    
    var allStocksSection: some View {
        Section {
            
            ForEach( all ) { stock in
                
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
