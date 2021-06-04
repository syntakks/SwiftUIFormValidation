//
//  LoginSuccessView.swift
//  SwiftUIFormValidation
//
//  Created by Stephen Wall on 6/4/21.
//

import SwiftUI

struct LoginSuccessView: View {
  @State var scale: CGFloat = 0.2
  @State var rotation: Angle = Angle(degrees: 0.0)
  
  var body: some View {
    VStack {
      Image(systemName: "checkmark.shield.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .scaledToFit()
        .padding()
        .foregroundColor(.white)
        .scaleEffect(scale)
        .rotationEffect(rotation)
        .onAppear {
          let baseAnimation = Animation.easeInOut(duration: 1)
          //let repeated = baseAnimation.repeatForever(autoreverses: true)
          
          withAnimation(baseAnimation) {
            scale = 1.0
            rotation = Angle(degrees: 360)
          }
        }
      
      Text("Login Success")
        .foregroundColor(.white)
        .font(.title)
    }
    .padding()
    .background(Color.blue)
    .cornerRadius(20)
  }
}

struct LoginSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSuccessView()
    }
}
