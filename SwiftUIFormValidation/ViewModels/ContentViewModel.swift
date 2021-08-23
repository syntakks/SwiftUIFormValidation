//
//  ContentViewModel.swift
//  SwiftUIFormValidation
//
//  Created by Stephen Wall on 6/4/21.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var passwordAgain: String = ""
  @Published var inlineErrorForPassword: String = ""
  @Published var isValid = false
  @Published var isLoggedIn = false
  
  private var cancelables = Set<AnyCancellable>()
  
  public static let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
  
  init() {
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isValid, on: self)
      .store(in: &cancelables)
    
    isPasswordValidPublisher
      .dropFirst()
      .receive(on: RunLoop.main)
      .map { passwordStatus in
        switch passwordStatus {
        case .empty: return "Password can not be empty"
        case .notStrongEnough: return "Password is too weak"
        case .repeatedPasswordWrong: return "Passwords do not match"
        case .valid: return ""
        }
      }
      .assign(to: \.inlineErrorForPassword, on: self)
      .store(in: &cancelables)
  }
  
  // MARK: - Username Valid
  private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
    $username
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { $0.count >= 3 }
      .eraseToAnyPublisher()
  }
  
  // MARK: - Password Empty
  private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
    $password
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { $0.isEmpty }
      .eraseToAnyPublisher()
  }
  
  // MARK: - Passwords Equal
  private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest($password, $passwordAgain)
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .map { $0 == $1 }
      .eraseToAnyPublisher()
  }
  
  // MARK: - Password Strong
  private var isPasswordStrongPublisher: AnyPublisher<Bool, Never> {
    $password
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .removeDuplicates()
      .map {
        Self.predicate.evaluate(with: $0)
      }
      .eraseToAnyPublisher()
  }
  
  // MARK: - Password Valid
  private var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
    Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongPublisher)
      .map {
        if $0 { return PasswordStatus.empty }
        if !$1 { return PasswordStatus.repeatedPasswordWrong }
        if !$2 { return PasswordStatus.notStrongEnough }
        return PasswordStatus.valid
      }
      .eraseToAnyPublisher()
  }
  
  // MARK: - Form Valid
  private var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
      .map {
        $0 && $1 == .valid
      }
      .eraseToAnyPublisher()
  }
  
}
