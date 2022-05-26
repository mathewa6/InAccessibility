//
//  StockCell.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct StockCell: View {
    
    let stock: Stock
    
    @State var showInfo = false

    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading) {


                    Text(stock.shortName)
                        .font(.title3)
                        .bold()

                    Text(stock.name)
                        .foregroundStyle(.secondary)
                        .font(.system(.caption))
                }

                Spacer()
                Divider()
            }
            //  This keeps all names aligned even with extra long titles
            .frame(alignment: .leading)
            .alignmentGuide(.leading) { $0[.leading] }


            HStack {

                StockGraph(stock: stock)

            }
            

            StockPrice(stock: stock)


            Image(systemName: "info.circle")
                .font(.body)
                .foregroundStyle(.secondary)
                .onTapGesture {
                    showInfo = true
                }

        }
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
        .alert(isPresented: $showInfo) {
            Alert(title: Text(stock.name), message: Text("The stock price for \(stock.name) (\(stock.shortName)) is \(stock.stockPrice)."), dismissButton: .cancel())
        }
    }
    
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        StockCell(stock: .example())
    }
}
