//
//  StockGraph.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

/// A very barebones imitation of a line graph
struct StockGraphPath: Shape {
    let points: [Double]

    func path(in rect: CGRect) -> Path {
        guard
            !points.isEmpty,
            let max = points.max() else { return .init() }

        let normalizedPoints = points.map { $0/(max + 5) }

        let xIncrement = (rect.width / (CGFloat(points.count) - 1))
        var path = Path()
        path.move(to: CGPoint(x: 0.0,
                              y: (1.0 - normalizedPoints[0]) * Double(rect.height)))
        for i in 1..<points.count {
            let pt = CGPoint(x: (Double(i) * Double(xIncrement)),
                             y: (1.0 - normalizedPoints[i]) * Double(rect.height))
            path.addLine(to: pt)
            path.move(to: pt)

        }
        return path
    }
}


/// A shape to replicate the point-like design of the original project
/// Intended to be used in combination with the ```StockGraphPath``` shape
struct StockGraphPoints: Shape {
    let points: [Double]

    func path(in rect: CGRect) -> Path {
        guard
            !points.isEmpty,
            let max = points.max() else { return .init() }

        let normalizedPoints = points.map { $0/(max + 5) }
        let size = CGSize(width: rect.width/15, height: rect.width/15)

        let xIncrement = (rect.width / (CGFloat(points.count) - 1))
        var path = Path()
        path.move(to: CGPoint(x: 0.0,
                              y: (1.0 - normalizedPoints[0]) * Double(rect.height)))
        for i in 0..<points.count {
            let pt = CGPoint(x: (Double(i) * Double(xIncrement)),
                             y: (1.0 - normalizedPoints[i]) * Double(rect.height))
            path.move(to: pt)
            path.addEllipse(in: CGRect(origin: .init(x: pt.x - size.width/2,
                                                     y: pt.y - size.height/2),
                                       size: size))

        }
        return path
    }
}

struct StockGraph: View {


    /// A variable to decide when to show more graphical detail
    /// either in accessibilityTextSizes or in DetailView
    @State var showDetails: Bool

    let stock: Stock
    
    let points: [Int] = [10, 20, 30, 40, 30, 25, 44]

    /// Converts point to Doubles and generates a negative trend
    /// set of points if necessary
    var graphData: [Double] {
        points.map { Double(stock.goingUp ? $0 : (points.max() ?? 0) - $0) }
    }

    var body: some View {
        ZStack(alignment: .leading) {
            
            Group {
                StockGraphPath(points: graphData)
                    .stroke(stock.goingUp ? .green : .red, lineWidth: 3)

                if showDetails {
                    StockGraphPoints(points: graphData)
                        .foregroundColor(stock.goingUp ? .green : .red)
                }
            }
            .padding(.all)

        }
        // This helps keep the graph proportional, even when rotated/scaled
        .aspectRatio((16/9.0), contentMode: .fit)
        .accessibilityElement()
        .accessibilityLabel("Stock price for \(stock.name)")
        .accessibilityChartDescriptor(self)
    }
}

struct StockGraph_Previews: PreviewProvider {
    static var previews: some View {
        StockGraph(showDetails: true, stock: .example())
    }
}


// A rough outline of audio graph usage
// TODO: (unfortunately I'm out of time to make the graph work fully)
extension StockGraph: AXChartDescriptorRepresentable {

    func makeChartDescriptor() -> AXChartDescriptor {
        let min = graphData.min() ?? 0.0
        let max = graphData.max() ?? 0.0

        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Time",
            categoryOrder: points.map { "\($0)" }
        )

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Price",
            range: min...max,
            gridlinePositions: []
        ) { value in "\(value) points" }

        let series = AXDataSeriesDescriptor(
            name: "Stock Price",
            isContinuous: false,
            dataPoints: graphData.enumerated().map {
                .init(x: Double($0), y: $1)
            }
        )

        return AXChartDescriptor(
            title: "Stock price for \(stock.name)",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }

}
