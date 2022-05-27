//
//  StockCell.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI


/// A simple modifier to be used anywhere a Ticker symbol is presented
/// It slows down, and spells out Text content
struct TickerSymbol: ViewModifier {

    let name: String

    func body(content: Content) -> some View {
        return content
            .accessibilityRepresentation(representation: {
                // Lower cases the name so VO doesn't read "Cap A" instead of "A"
                Text(name.lowercased())
                    // We always want ticker symbol spelt out
                    .speechSpellsOutCharacters(true)
                    // Some traded assets can include ^% in the name IRL
                    .speechAlwaysIncludesPunctuation(true)
                    // Drop the pitch so the listener is aware that this is a symbol
                    .speechAdjustedPitch(-0.25)
            })

    }

}

struct StockCell: View {
    
    let stock: Stock
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading) {

                    Text(stock.shortName)
                        .font(.title3)
                        .bold()
                        .modifier(TickerSymbol(name: stock.shortName))


                    Text(stock.name)
                        .foregroundStyle(.secondary)
                        .font(.system(.caption))
                }

                Spacer()
                Divider()
            }
            // This keeps all names aligned even with extra long titles
            .frame(alignment: .leading)
            .alignmentGuide(.leading) { $0[.leading] }

            Spacer()

            StockGraph(showDetails: false, stock: stock)

            StockPrice(stock: stock)

            
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
        
    }
    
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        StockCell(stock: .example())
    }
}
