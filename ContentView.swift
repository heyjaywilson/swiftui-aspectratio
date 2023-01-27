import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var numGridColumns: Float = 2.0
    @Published var width: Float = 1.0
    @Published var height: Float = 1.0

    var aspectRatio: CGSize {
        CGSize(width: Double(width), height: Double(height))
    }

    var colors: [Color] = [Color.blue, Color.green]

    var rectangles: [ColumnView] {
        var temp: [ColumnView] = []
        for i in 0..<100 {
            temp.append(ColumnView(color: colors[i%2]))
        }
        return temp
    }

    var gridColumns: [GridItem] {
        var temp: [GridItem] = []

        for _ in 0..<Int(numGridColumns) {
            temp.append(GridItem(.flexible(), spacing: 0))
        }

        return temp
    }
}

struct ContentView: View {
    @StateObject private var model = ContentViewModel()

    var body: some View {
        VStack {
            Group {
                VStack(alignment: .leading) {
                    Text("Columns: \(model.gridColumns.count)")
                    Slider(value: $model.numGridColumns, in: 0...10, step: 1.0)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Width: \(Int(model.width))")
                        Slider(value: $model.width, in: 1...10, step: 1.0)
                    }
                    VStack(alignment: .leading) {
                        Text("Height \(Int(model.height))")
                        Slider(value: $model.height, in: 1...10, step: 1.0)
                    }
                }
            }.padding()
            Spacer()
            ScrollView {
                LazyVGrid(columns: model.gridColumns, spacing: 0) {
                    ForEach(model.rectangles, id: \.self) { rect in
                        rect
                            .aspectRatio(model.aspectRatio, contentMode: .fit)
                    }
                }.background { Color.black }
            }
                .background {
                    Color.red
                }
        }.frame(maxWidth: .infinity)
    }
}

struct ColumnView: View, Hashable {
    var id = UUID()
    var color: Color

    var body: some View {
        Rectangle().fill(color)
    }
}
