////
////  GameQuizeView.swift
////  BrainBurst
////
////  Created by todoc on 2023/06/10.
////

import SwiftUI
import Combine

struct QuizGameView: View {
    
    @State var quizText: String = "Quiz"
    @State var userAnswer: String = ""
    @State var showResult: Bool = false
    @ObservedObject var grader: MentalArithmeticGrader
    
    @State private var isShowAnswer: Bool = false
    @State private var answerResult: AnswerNotificationToast.Result = .wrong
        
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(grader: MentalArithmeticGrader) {
        self.grader = grader
    }
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    grader.startSharing {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.grader.sendQuiz()
                        }
                    }
                } label: {
                    Text("게임 시작")
                }
                .padding()
                
                Text(grader.timerText)
                    .fontWidth(Font.Width(30))
                    .padding()
                Spacer()
                Text(grader.quiz)
                    .font(.title)
                Spacer()
                TextField("Enter Answer", text: $userAnswer)
                    .multilineTextAlignment(.center)
                Text("확인용 답: \(grader.answer)")
                Spacer()
                Button("Next") {
                    isShowAnswer = grader.gradeProcess(userAnswer)
                    answerResult = isShowAnswer
                    ? .correct
                    : .wrong
                    showAnswerNotification(isShowAnswer)
                    
                    userAnswer = ""
                }
                Spacer()
            }
            .background()
            .alert("게임종료", isPresented: $grader.showResult) {
                
            } message: {
                Text("ranking: \(grader.myRanking)")
            }
            .task {
                for await session in GameGroupActivity.sessions() {
                    grader.configureGroupSession(session)
                }
            }
            
            AnswerNotificationToast(isShow: $isShowAnswer, result: $answerResult)
        }
    }
    
    private func showAnswerNotification(_ isShow: Bool) {
        isShowAnswer = isShow
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut) {
                isShowAnswer = false
            }
        }
    }
}

