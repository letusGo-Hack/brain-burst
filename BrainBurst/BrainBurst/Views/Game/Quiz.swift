//
//  Quiz.swift
//  BrainBurst
//
//  Created by J_Min on 2023/06/10.
//

import Foundation

protocol Quiz {
    var question: String { get }
    var answer: Int { get }
}

protocol QuizMaker {
    func makeQuiz() -> Quiz
}
