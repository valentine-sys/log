//
//  FeedView.swift
//  log
//
//  Created by Valome on 11/3/24.
//

import SwiftUI

struct FeedView: View {
    // Access the environment's presentation mode to control the view's navigation
    @Environment(\.presentationMode) var presentationMode
    @State private var showIntroView = false
    @State private var isFadingOut = false
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack {
            Image(systemName: "app")
                .padding()
            Text("Hello, World!")
            
            Button("Back to Intro View") {
                feedbackGenerator.impactOccurred()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFadingOut = true // Fade out when navigating to IntroView
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        showIntroView = true
                    }
                }
            }
            .foregroundStyle(.white)
            .padding(.vertical, 15)
            .frame(maxWidth: 220)
            .background(.black, in: Capsule())
            .fontWeight(.medium)
            .padding()
            .contentShape(Capsule())
        }
        .navigationTitle("Feed")
        .fullScreenCover(isPresented: $showIntroView) {
            IntroView()
        }
    }
}

#Preview {
    FeedView()
}
