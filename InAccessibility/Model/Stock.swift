//
//  Stock.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import Foundation

struct Stock: Identifiable {
    let id = UUID()
    let name: String
    let stockPrice: Double
    let shortName: String
    let goingUp: Bool
    let favorite: Bool
    let change: Double
    let description: String
    
    
    init(name: String, shortName: String, favorite: Bool) {
        self.name = name
        self.shortName = shortName
        self.favorite = favorite
        
        let price = Double.random(in: 45.13...759.24)
        self.stockPrice = price
        
        let goingUp = Bool.random()
        self.goingUp = goingUp

        // Change is a "tangible" quantity when it comes to traded assets
        // (so a negative dollar amount is a tad counter-intuitive)
        // We already store the direction of change
        // so this is changed to only generate a random
        // and the presentation views handle negating changes
        self.change = Double.random(in: 3.00...149.34)

        // Moved the assett description here instead of the View
        self.description = "This is a company that was founded at some point in time by some people with some ideas. The company makes products and they do other things as well. Some of these things go well, some don't. The company employs people, somewhere between 10 and 250.000. The exact amount is not currently available."
    }
    
    static func example() -> Stock {
        Stock(name: "Apple", shortName: "AAPL", favorite: false)
    }
    
    static func favorites() -> [Stock] {
        [
            Stock(name: "Apple", shortName: "AAPL", favorite: true),
            Stock(name: "Google", shortName: "GOOG", favorite: true),
            Stock(name: "Nintendo", shortName: "NNTD", favorite: true),
            Stock(name: "Vivid", shortName: "VVID", favorite: true),
            Stock(name: "Oil Co", shortName: "OILC", favorite: true),
        ]
    }
    
    static func all() -> [Stock] {
        [
            Stock(name: "Apple", shortName: "AAPL", favorite: false),
            Stock(name: "Nintendo", shortName: "NNTD", favorite: false),
            Stock(name: "Vivid", shortName: "VVID", favorite: false),
            Stock(name: "Oil Co", shortName: "OILC", favorite: false),
            Stock(name: "Google", shortName: "GOOG", favorite: false),
            Stock(name: "Apple", shortName: "AAPL", favorite: false),
            Stock(name: "Nintendo", shortName: "NNTD", favorite: false),
            Stock(name: "Vivid", shortName: "VVID", favorite: false),
            Stock(name: "Oil Co", shortName: "OILC", favorite: false),
            Stock(name: "Google", shortName: "GOOG", favorite: false),
        ]
    }
}
