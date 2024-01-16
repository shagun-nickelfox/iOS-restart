//
//  ContentView.swift
//  Restart
//
//  Created by Nickelfox on 10/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("onBoarding") var isOnboardingViewActive: Bool = true
    
    var body: some View {
        ZStack{
            if isOnboardingViewActive{
                OnboardingView()
            } else {
                HomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}
