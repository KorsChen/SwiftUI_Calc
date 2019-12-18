//
//  CalculatorModel.swift
//  ui
//
//  Created by 陈志鹏 on 2019/12/18.
//  Copyright © 2019 陈志鹏. All rights reserved.
//

import SwiftUI
import Combine

class CalculatorModel: ObservableObject {
    //    let objectWillChange = PassthroughSubject<Void, Never>()
    //    var brain: CalculatorBrain = .left("0") {
    //        willSet { objectWillChange.send() }
    //    }
    
    @Published var brain: CalculatorBrain = .left("0")
    
    @Published var history: [CalculatorButtonItem] = []
    
    var temporaryKept: [CalculatorButtonItem] = []
            
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }

    func apply(item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item);
        
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
}

extension CalculatorModel {
    
    var historyDetail: String {
        history.map{ $0.description }.joined()
    }
    
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        
        let total = history + temporaryKept
        
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        brain = history.reduce(CalculatorBrain.left("0")) {
            result, item in
            result.apply(item: item)
        }
    }
}
