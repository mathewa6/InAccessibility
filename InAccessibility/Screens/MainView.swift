//
//  ContentView.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

enum SortOrder: Int {
    case name
    case perc
    case value
    case ticker

    var description: String {
        switch self {
        case .name: return "Name"
        case .value: return "Value"
        case .perc: return "Percentage"
        case .ticker: return "Ticker Symbol"
        }
    }
}

struct MainView: View {
    
    /// Formerly ContentSizeCategory
    @Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize
    
    @State private var showDetailStock: Stock?
    @State private var showCustomize: Bool = false
    @State private var showAddStock: Bool = false


    /// The user chosen sort order for stocks
    @State private var menuSortSelection: Int = 0

    
    // --- Model ---
    // Keep the stock lists as states
    // to prevent sudden flickering on the simulated timer
    // Always sort this by the default sort order above
    @State var favorites: [Stock] = Stock.favorites().sorted { $0.name < $1.name }
    
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
                
                lastUpdatedTimestamp = Date()
            }
        }
        // TODO: Allow sorting in increasing and decreasing orders
        // Picker doesn't allow re-tapping to change a value
        .onChange(of: menuSortSelection) { newValue in
            favorites.sort { sort(order: SortOrder(rawValue: newValue),
                                  stockA: $0,
                                  stockB: $1,
                                  isIncreasing: true) }
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
                    .contextMenu {
                        // The context menu should allow for the same functionality
                        // as swiping. This again mirrors system app functioning
                        // but also allows those with mild tremors to not
                        // need to swipe to unfavorite
                        Button {
                            
                        } label: {
                            Label("Info", systemImage: "info.circle")
                        }
                        
                        Button {
                            
                            withAnimation(.default) {
                                favorites.removeAll { $0.name == stock.name }
                            }
                            
                        } label: {
                            Label("Unfavorite", systemImage: "star.slash")
                        }
                        
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        // If we only wanted to support VoiceOver
                        // This could be accomplished with a
                        // .accesibilityAction. However, using .swipeAction allows for
                        // system convention across all modalities
                        // (and free VO support)
                        Button(role: .destructive) {
                            
                            withAnimation(.default) {
                                favorites.removeAll { $0.name == stock.name }
                            }
                            
                        } label: {
                            // VO uses this for the "free" accessibilityAction
                            Label("Unfavorite", systemImage: "star.slash")
                        }
                        
                    }
                
            }

        } header: {
            // Since the header says Stocks,
            // we can remove the redundant "stocks" here
            Text("Favorites")
            
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
    
    var toolbarItems: some ToolbarContent {
        Group {
            // Move the Settings button and add/more
            // (The leading top position is typically where a back button goes)
            
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker(selection: $menuSortSelection, label: Text("Sort")) {
                        Label(SortOrder.name.description,
                              systemImage: "textformat").tag(0)
                        Label(SortOrder.perc.description,
                              systemImage: "percent").tag(1)
                        Label(SortOrder.value.description,
                              systemImage: "chart.xyaxis.line").tag(2)
                        Label(SortOrder.ticker.description,
                              systemImage: "abc").tag(3)
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
                
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    showCustomize.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "gearshape.fill")
                            .accessibilityHidden(true)
                        Text("Customize")
                    }
                    .accessibilityElement(children: .combine)
                    .sheet(isPresented: $showCustomize) {
                        CustomizeView(showCustomize: $showCustomize)
                    }
                    
                }

                Spacer()
                
                Button {
                    showAddStock.toggle()
                } label: {
                    
                    HStack {
                        Image(systemName: "plus")
                            .accessibilityHidden(true)
                        Text("Add")
                    }
                    .accessibilityElement(children: .combine)
                    
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .sheet(isPresented: $showAddStock) {
                    AllStockView(showAddStock: $showAddStock)
                }
            }
            
        }
    }

    private func sort(order: SortOrder?,
                      stockA: Stock,
                      stockB: Stock,
                      isIncreasing: Bool) -> Bool {

        switch order {

        case .perc:
            let stockAPerc = abs(stockA.change/stockA.stockPrice)
            let stockBPerc = abs(stockB.change/stockB.stockPrice)
            return stockAPerc < stockBPerc

        case .value: return stockA.stockPrice < stockB.stockPrice

        case .name: return stockA.name < stockB.name

        case .ticker: return stockA.shortName < stockB.shortName

        default: return stockA.name < stockB.name
        }

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
