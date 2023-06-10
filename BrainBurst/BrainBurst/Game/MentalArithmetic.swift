//
//  MentalArithmetic.swift
//  BrainBurst
//
//  Created by J_Min on 2023/06/10.
//

import Foundation

struct MentalArithmetic: Quiz {
    var question: String
    var answer: Int
}

struct MentalArithmeticQuizMaker: QuizMaker {
    let numRange: Range<Int> = 1..<100
    
    enum Operation: CaseIterable {
        case Plus, Minus, Mul
        
        var symbol: String {
            switch self {
            case .Plus:
                return "+"
            case .Minus:
                return "-"
            case .Mul:
                return "*"
            }
        }
    }
    
    func makeQuiz() -> Quiz {
        let randomOperation = Operation.allCases.randomElement() ?? .Plus
        let firstNum = numRange.randomElement() ?? 0
        let secondNum = numRange.randomElement() ?? 0
        
        switch randomOperation {
        case .Plus:
            return MentalArithmetic(question: "\(firstNum) \(randomOperation.symbol) \(secondNum)", answer: firstNum + secondNum)
        case .Minus:
            return MentalArithmetic(question: "\(firstNum) \(randomOperation.symbol) \(secondNum)", answer: firstNum - secondNum)
        case .Mul:
            return MentalArithmetic(question: "\(firstNum) \(randomOperation.symbol) \(secondNum)", answer: firstNum * secondNum)
        }
    }
}
