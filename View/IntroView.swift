//
//  IntroView.swift
//  log
//
//  Created by MAC on 11/3/24.
//

import SwiftUI
import UIKit

struct IntroView: View {
    @AppStorage("hasSeenIntro") private var hasSeenIntro: Bool = false
    @State private var activePage: Page = .page1
    @State private var isFadingOut = false
    @State private var showFeedView = false
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        ZStack {
            if showFeedView {
                NavigationStack {
                    FeedView()
                        .transition(.opacity)
                        .zIndex(1)
                }
                .transition(.opacity)
            }
 else {
                GeometryReader { geometry in
                    let size = geometry.size
                    
                    VStack {
                        Spacer(minLength: 0)
                        
                        MorphingSymbolView(
                            symbol: activePage.rawValue,
                            config: .init(
                                font: .system(size: 150, weight: .bold),
                                frame: .init(width: 250, height: 200),
                                radius: 30,
                                foregroundColor: .white
                            )
                        )
                        .onTapGesture {
                            feedbackGenerator.impactOccurred()
                            withAnimation {
                                activePage = activePage.nextPage
                            }
                        }
                        
                        TextContent(size: size)
                        
                        Spacer(minLength: 0)
                                        
                        indicatorView()
                        
                        ContinueButton()
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .top) {
                        HeaderView()
                    }
                    .background {
                        Rectangle()
                            .fill(.black.gradient)
                            .ignoresSafeArea()
                    }
                    .opacity(isFadingOut ? 0 : 1) // Controls the fade effect for IntroView
                    .onAppear {
                        isFadingOut = false // Initial state is fully visible
                    }
                    .onChange(of: activePage) {
                        if activePage == .page4 {
                            hasSeenIntro = true

                            withAnimation(.easeInOut(duration: 0.5)) {
                                isFadingOut = true // Fade out when navigating to FeedView
                            }

                            // Trigger navigation after a short delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                withAnimation {
                                    showFeedView = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func TextContent(size: CGSize) -> some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(Page.allCases, id: \.rawValue) { page in
                    Text(page.title)
                        .lineLimit(1)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .kerning(1.1)
                        .foregroundColor(.white)
                        .frame(width: size.width)
                }
            }
            .offset(x: -activePage.index * size.width)
            .animation(.easeInOut(duration: 0.7), value: activePage)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(Page.allCases, id: \.rawValue) { page in
                    Text(page.subTitle)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .frame(width: size.width)
                }
            }
            .offset(x: -activePage.index * size.width)
            .animation(.easeInOut(duration: 0.9), value: activePage)
        }
        .padding(.top, 15)
        .frame(width: size.width, alignment: .leading)
    }

    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                feedbackGenerator.impactOccurred()
                withAnimation {
                    activePage = activePage.previousPage
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .contentShape(Rectangle())
            }
            .opacity(activePage != .page1 ? 1 : 0)
            
            Spacer(minLength: 0)
            
            Button("Skip") {
                feedbackGenerator.impactOccurred()
                withAnimation {
                    activePage = .page4
                }
            }
            .fontWeight(.semibold)
            .opacity(activePage != .page4 ? 1 : 0)
        }
        .foregroundStyle(.white)
        .animation(.easeInOut(duration: 0.35), value: activePage)
        .padding(15)
    }
    
    @ViewBuilder
    func indicatorView() -> some View {
        HStack(spacing: 6) {
            ForEach(Page.allCases, id: \.rawValue) { page in
                Capsule()
                    .fill(.white.opacity(activePage == page ? 1 : 0.4))
                    .frame(width: activePage == page ? 25 : 8, height: 8)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: activePage)
        .padding(.bottom, 12)
    }
    
    @ViewBuilder
    func ContinueButton() -> some View {
        if activePage == .page4 {
            Button("Vlog") {
                feedbackGenerator.impactOccurred()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFadingOut = true // Fade out when navigating to FeedView
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        showFeedView = true
                    }
                }
            }
            .foregroundStyle(.black)
            .padding(.vertical, 15)
            .frame(maxWidth: 220)
            .background(.white, in: Capsule())
            .fontWeight(.medium)
            .padding()
            .contentShape(Capsule())
        } else {
            Button("Continue") {
                feedbackGenerator.impactOccurred()
                withAnimation {
                    activePage = activePage.nextPage
                }
            }
            .foregroundStyle(.black)
            .padding(.vertical, 15)
            .frame(maxWidth: 180)
            .background(.white, in: Capsule())
            .fontWeight(.medium)
            .padding()
            .contentShape(Capsule())
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    IntroView()
}
