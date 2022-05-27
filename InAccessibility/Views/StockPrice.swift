//
//  StockPrice.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct StockPrice: View {

    @Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize

    @Environment(\.accessibilityDifferentiateWithoutColor) var diffWithoutColor: Bool

    let stock: Stock
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .autoupdatingCurrent

        return formatter
    }()

    var value: String {
        currencyFormatter
            .string(from: NSNumber(value: stock.stockPrice)) ??
        "\(String(format: "%.2f",stock.stockPrice))"
    }

    var change: String {
        let formatted: String =  currencyFormatter
            .string(from: NSNumber(value: stock.change)) ??
        "\(String(format: "%.2f",stock.change))"

        return formatted
    }

    var body: some View {

        VStack(alignment: dynamicTypeSize.isAccessibilitySize ? .leading : .trailing,
               spacing: 4) {
            Text(value)

            // Add a + or - here to indicate the direction of change
            HStack(spacing: 0) {

                // Use arrows to indicate price movement direction
                // if the differentiate without color is required
                if diffWithoutColor {
                    Image(systemName: stock.goingUp ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        .foregroundColor(stock.goingUp ? .green : .red)
                        .accessibilityHidden(true)
                }

                Text("\(stock.goingUp ? "+" : "-") \(change)")
                    .bold()
                    .font(.caption)
                    .padding(.all, 4)
                    .background(stock.goingUp ? Color.green : Color.red)
                    .cornerRadius(6)
                    .foregroundColor(.white)
            }
                .accessibilityLabel("Change: \(stock.goingUp ? "Up" : "Down") \(change)")
        }

    }
}


struct StockPrice_Previews: PreviewProvider {
    static var previews: some View {
        StockPrice(stock: .example())
    }
}
