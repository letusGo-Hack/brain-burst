//
//  RankView.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import SwiftUI

struct RankView: View {
    @Environment(\.dismiss) var dismiss
    
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
    ContentView()
        .sheet(
            isPresented: Binding.constant(true),
            content: {
                RankView()
            }
        )
}
