//
//  RankView.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import SwiftUI

struct RankView: View {
    var body: some View {
        NavigationView(content: {
            Text("Hi")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Navigation")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                            Button("One") {}
                          }
                })
            
        })
    }
}

#Preview {
    RankView()
}
