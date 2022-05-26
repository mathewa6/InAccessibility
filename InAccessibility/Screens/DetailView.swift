//
//  DetailView.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

enum AlertItem: String, Identifiable {
    case share
    case favorite
    
    var id: String { self.rawValue }
}
struct DetailView: View {

    // This is useful to dismiss via accessibilityAction if in a modal
    @Environment(\.presentationMode) var presentationMode
    // This allows us to change the layout based on orientation
    // to keep the buttons (hopefully) within reach
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    @State var selectedAlertItem: AlertItem?

    let stock: Stock
    
    var body: some View {

        VStack(alignment: .leading) {
            companyInfo
            description
            buttons
        }
        .padding(.horizontal)
        .alert(item: $selectedAlertItem, content: { item in
            if item == .share {
                return Alert(title: Text("Thanks for sharing!"))
            } else {
                return Alert(title: Text("Thanks for favoriting (but not really)!"))
            }
        })
        .accessibilityAction(.escape) {
            presentationMode.wrappedValue.dismiss()
        }
        .accessibilityAction(.magicTap) {
            // Since we only have one primary action on this page
            // it wouldn't hurt to allow a VO user familiar with the
            // UI to just magic tap
            selectedAlertItem = .favorite
        }
        .toolbar {
            // Presenting a share button and a favorite at the bottom
            // isn't platform convention and hence puts the user in a
            // position of choice each time they view the page
            // Moving the share button to a toolbar where it is more
            // likely to occur in other apps and keeping one primary
            // button aids clarity esp. for those with cognitive/focus impairment
            ToolbarItem(placement: .primaryAction) {
                Button {
                    selectedAlertItem = .share
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }

            }
        }

    }
    
    var companyInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.name)
                    .font(.title2)
                    .bold()
                Text(stock.shortName)
                    .font(.subheadline)

                Spacer()

                StockGraph(showDetails: true, stock: stock)
                
                Spacer()


            }
            
//            0, 136, 15
//            221, 51, 34
        }
    }
    
    var description: some View {
        VStack(alignment: .leading) {
            Text(stock.description)
                .font(.body)
        }
    }
    
    var buttons: some View {
        VStack {
            Button {
                selectedAlertItem = .favorite
            } label: {
                Label("Favorite", systemImage: "star")
                    .font(.title2)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .padding(.all)

        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(stock: .example())
    }
}
