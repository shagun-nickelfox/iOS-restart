//
//  OnboardingView.swift
//  Restart
//
//  Created by Nickelfox on 10/12/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("onBoarding") var isOnboardingViewActive: Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var textTitle: String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack{
            Color("ColorBlue")
                .ignoresSafeArea(.all,edges: .all)
            VStack(spacing: 20){
                //HEADER
                
                Spacer()
                
                VStack(spacing: 0){
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle)
                    
                    Text("""
                         It's not how much we give but how much we put into giving.
                         """)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,10)
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1),value: isAnimating)
                
                //CENTER
                
                ZStack{
                    CircleGroupView(shapeColor: .white,shapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                        
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    if abs(imageOffset.width) <= 150{
                                        imageOffset = gesture.translation
                                    }
                                    
                                    withAnimation(.linear(duration: 0.25)){
                                        textTitle = "Give."
                                    }
                                }
                                .onEnded{ _ in
                                    imageOffset = .zero
                                    
                                    withAnimation(.linear(duration: 0.25)){
                                        textTitle = "Share."
                                    }
                                }
                        )
                        .animation(.easeInOut(duration: 1), value: imageOffset)
                }
                
                Spacer()
                
                //FOOTER
                ZStack{
                    Capsule().fill(.white.opacity(0.2))
                    
                    Capsule().fill(.white.opacity(0.2))
                        .padding(8)
                    
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .offset(x: 20)
                    
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        
                        Spacer()
                    }
                    
                    HStack{
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 80,height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80{
                                        buttonOffset = gesture.translation.width
                                    
                                    }
                                }
                                .onEnded{_ in
                                    withAnimation(Animation.easeOut(duration: 0.4)){
                                        if buttonOffset > buttonWidth/2{
                                            hapticFeedback.notificationOccurred(.success)
                                            playSound(sound: "chimeup", type: "mp3")
                                            buttonOffset = buttonWidth - 80
                                            isOnboardingViewActive = false
                                        }else{
                                            hapticFeedback.notificationOccurred(.warning)
                                            buttonOffset = 0
                                        }
                                    }
                                }
                        )
                    
                        
                        Spacer()
                    }
                }
                .frame(width: buttonWidth,height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1),value: isAnimating)
            }
        }.onAppear(perform:{
            isAnimating = true
        })
        .preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider{
    static  var previews: some View{
        OnboardingView()
    }
}
