//
//  RankView.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import SwiftUI
import SwiftData

struct RankView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var didLoad: Bool = false
    
    private var histories: [Int] = [1, 2, 3, 4, 5]
    
    var body: some View {
        NavigationView(content: {
            List {
                ForEach(histories, id: \.self) { history in
                    historyView(row: history)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Rank")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            })
        })
        .onAppear(perform: {
            if didLoad == false {
                didLoad = true
            }
            
            let gameResultHisotry = GameResultHistory(
                rank: 1,
                score: 10,
                endDate: Date(),
                createDate: Date()
            )
            context.insert(gameResultHisotry)
            try? context.save()
        })
        
    }
    
    func historyView(row: Int) -> some View {
        HStack {
            Text("\(row)")
                .frame(maxWidth: .infinity)
            
            Text("\(row)")
                .frame(maxWidth: .infinity)
            
            Text("\(row)")
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
        .sheet(
            isPresented: Binding.constant(true),
            content: {
                RankView()
                    .modelContainer(for: GameResultHistory.self)
            }
        )
}
