//
//  GameQuizeView.swift
//  BrainBurst
//
//  Created by todoc on 2023/06/10.
//

import SwiftUI
import Combine

struct QuizGameView: View {
    
    @State var quizText: String = "Quiz"
    @State var userAnswer: String = ""
    @State var showResult: Bool = false
    @ObservedObject var grader: MentalArithmeticGrader
    
    @State private var isShowAnswer: Bool = false
        
    
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
                    showAnswerNotification(isShowAnswer)
                    
                    userAnswer = ""
                }
                Spacer()
            }.onAppear {
                grader.viewLoaded()
            }
            .background()
            .alert(grader.isMyWin ? "님 이김" : "님 짐ㅅㄱ", isPresented: $grader.showResult) {
                
            } message: {
                //            Text("score: \(grader.gameResult?.score ?? 0)")
            }
            .task {
                for await session in GameGroupActivity.sessions() {
                    grader.configureGroupSession(session)
                }
            }
            
            AnswerNotificationToast(isShow: $isShowAnswer, result: .correct)
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

struct QuizGameView_Previews: PreviewProvider {
    static var previews: some View {
        let maker = MentalArithmeticQuizMaker()
        let gameManager = GameManager(maker: maker)
        let grader = MentalArithmeticGrader(gameManager: gameManager)
        return QuizGameView(grader: grader)
    }
}
