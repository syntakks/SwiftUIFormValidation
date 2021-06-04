//
//  ContentView.swift
//  SwiftUIFormValidation
//
//  Created by Stephen Wall on 6/4/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = ContentViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section(header: Text("USERNAME")) {
            TextField("Username", text: $viewModel.username)
              .autocapitalization(.none)
          }
          Section(header: HeaderView(),
                  footer: FooterView(errorText: $viewModel.inlineErrorForPassword)) {
            SecureField("Password", text: $viewModel.password)
            SecureField("Password again...", text: $viewModel.passwordAgain)
          }
        }
        Button(action: login) {
          RoundedRectangle(cornerRadius: 10)
            .frame(height: 60)
            .overlay(
              Text("Login")
                .foregroundColor(.white)
            )
        }
        .padding([.bottom, .leading, .trailing])
        .disabled(!viewModel.isValid)
      }
      .navigationTitle("Login")
    }
    .sheet(isPresented: $viewModel.isLoggedIn, content: {
      LoginSuccessView()
    })
  }
  
  func login() {
    viewModel.isLoggedIn.toggle()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
    LoginSuccessView()
  }
}

struct HeaderView: View {
  var body: some View {
    Text("PASSWORD")
  }
}

struct FooterView: View {
  @Binding var errorText: String
  var body: some View {
    Text(errorText).foregroundColor(.red)
  }
}
