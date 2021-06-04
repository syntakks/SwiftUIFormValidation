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
            Section(header: Text("PASSWORD"), footer: Text(viewModel.inlineErrorForPassword).foregroundColor(.red)) {
              SecureField("Password", text: $viewModel.password)
              SecureField("Password again...", text: $viewModel.passwordAgain)
            }
          }
          Button(action: {}) {
            RoundedRectangle(cornerRadius: 10)
              .frame(height: 60)
              .overlay(
                Text("Continue")
                  .foregroundColor(.white)
              )
          }
          .padding([.bottom, .leading, .trailing])
          .disabled(!viewModel.isValid)
        }
        .navigationTitle("Login")
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
