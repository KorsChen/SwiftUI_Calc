//
//  ContentView.swift
//  ui
//
//  Created by 陈志鹏 on 2019/11/18.
//  Copyright © 2019 陈志鹏. All rights reserved.
//

import SwiftUI
import Combine

let scale = UIScreen.main.bounds.width / 414

struct CalculatorButtonRow: View {
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel
    @EnvironmentObject var model: CalculatorModel
    
    let row: [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id:\.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName) {
//                        self.brain = self.brain.apply(item: item)
                        self.model.apply(item: item)
                }
            }
        }
    }
}

struct CalculatorButtonPad: View {
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel
    
    let pad: [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id:\.self) { row in
                CalculatorButtonRow(row: row)
            }
        }
    }
}

struct ContentView: View {
    @State private var editingHistory = false
    
//    @State private var brain: CalculatorBrain = .left("0")
//    @ObservedObject var model = CalculatorModel()
//    “在 SwiftUI 中，View 提供了 environmentObject(_:) 方法，来把某个 ObservableObject 的值注入到当前 View 层级及其子层级中去。在这个 View 的子层级中，可以使用 @EnvironmentObject 来直接获取这个绑定的环境值。”
    @EnvironmentObject var model: CalculatorModel
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button("操作记录:\(model.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: self.$editingHistory) {
                HistoryView(model: self.model)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24 * scale)
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment:.trailing)
            
            CalculatorButtonPad().padding(.bottom)
        }
            .scaleEffect(scale)
    }
}

struct HistoryView: View {
    @ObservedObject var model: CalculatorModel
    var body: some View {
        VStack {
            if model.totalCount == 0 {
                Text("NO Record")
            } else {
                HStack {
                    Text("Record").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("Display").font(.headline)
                    Text("\(model.brain.output)")
                }
                Slider(value: $model.slidingIndex,
                       in: 0...Float(model.totalCount),
                       step: 1)
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
//            ContentView().previewDevice("iPhone SE")
//            ContentView().previewDevice("iPad Air 2")
        }
    }
}

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let action: ()->Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize * scale))
                .foregroundColor(.white)
                .frame(width: size.width * scale, height: size.height * scale)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width/2 * scale)
        }
    }
}
