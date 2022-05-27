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

    /// Formerly ContentSizeCategory
    @Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize

    @State var selectedAlertItem: AlertItem?

    let stock: Stock
    
    var body: some View {

        Group {
            if verticalSizeClass == .compact {
                HStack {
                    companyInfo
                    VStack {
                        ScrollView {
                            description
                        }
                        buttons
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    ScrollView {
                        companyInfo
                        description
                    }
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
            }
        }
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
            // Presenting a share button and a favorite (together) at the bottom
            // isn't platform convention and hence puts the user in a
            // position of choice each time they view the page
            // Moving the share button to a toolbar where it is more
            // likely to occur in other apps and keeping one primary
            // button aids clarity esp. for those with cognitive/focus impairment
            ToolbarItem(placement: .primaryAction) {

                // Using buttons here automatically adapts to
                // the .accessibilityShowButtonShapes setting
                Button {
                    selectedAlertItem = .share
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                // VoiceOver uses this too, even though it's for largeContentViewer
                .accessibilityShowsLargeContentViewer {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .labelStyle(.titleAndIcon)
                }
            }
        }

    }
    
    var companyInfo: some View {

        VStack(alignment: .leading) {

            Group {
                
                if dynamicTypeSize.isAccessibilitySize {

                    VStack(alignment: .leading) {
                        Text(stock.name)
                            .font(.title2)
                            .bold()
                            .accessibilitySortPriority(3)
                        // This ensures the title is first focused
                        // when the view first appears

                        Text(stock.shortName)
                            .font(.subheadline)
                            .modifier(TickerSymbol(name: stock.shortName))
                            .accessibilitySortPriority(2)

                        Spacer()

                        StockPrice(stock: stock)
                            .accessibilitySortPriority(1)
                    }

                } else {
                    HStack {

                        VStack(alignment: .leading) {
                            Text(stock.name)
                                .font(.title2)
                                .bold()
                                .accessibilitySortPriority(3)
                            // This ensures the title is first focused
                            // when the view first appears

                            Text(stock.shortName)
                                .font(.subheadline)
                                .modifier(TickerSymbol(name: stock.shortName))
                                .accessibilitySortPriority(2)
                        }

                        Spacer()

                        StockPrice(stock: stock)
                            .accessibilitySortPriority(1)
                    }
                }
            }
            .accessibilityElement(children: .combine)

            Spacer()

            StockGraph(showDetails: true, stock: stock)
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer()


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
            Button(role: stock.favorite ? .destructive : nil) {
                if stock.favorite {
                    // TODO:
                    // IRL we would probably want to remove it from the model
                } else {
                    selectedAlertItem = .favorite
                }
            } label: {
                Group {
                    if stock.favorite {
                        Label("Unfavorite",
                              systemImage: "star.slash")

                    } else {
                        Label("Favorite", systemImage: "star")
                    }
                }
                .lineLimit(1)
                .font(.headline)
                .scaledToFit()
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
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
