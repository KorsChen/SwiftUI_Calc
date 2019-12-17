//
//  ContentView.swift
//  ui
//
//  Created by 陈志鹏 on 2019/11/18.
//  Copyright © 2019 陈志鹏. All rights reserved.
//

import SwiftUI

let scale = UIScreen.main.bounds.width / 414

struct CalculatorButtonRow: View {
    @Binding var brain: CalculatorBrain
    
    let row: [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id:\.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName) {
                        self.brain = self.brain.apply(item: item)
                }
            }
        }
    }
}

struct CalculatorButtonPad: View {
    @Binding var brain: CalculatorBrain
    
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
                CalculatorButtonRow(brain: self.$brain, row: row)
            }
        }
    }
}

struct ContentView: View {
    
    @State private var brain: CalculatorBrain = .left("0")
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24 * scale)
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            Button("Test") {
                self.brain = .left("1.23")
            }
            CalculatorButtonPad(brain: $brain)
                .padding(.bottom)
        }
            .scaleEffect(scale)
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
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width/2)
        }
    }
}
