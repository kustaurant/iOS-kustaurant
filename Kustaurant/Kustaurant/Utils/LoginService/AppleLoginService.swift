//
//  AppleLoginService.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation
import Combine
import AuthenticationServices

struct SignInWithAppleResponse {
    let id: String
    let authorizationCode: String
    let identityToken: String
}

final class AppleLoginService: NSObject {
    
    private let responsePublisher = PassthroughSubject<SignInWithAppleResponse, Never>()
    
    func attemptLogin() -> AnyPublisher<SignInWithAppleResponse, Never> {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = []
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
        return responsePublisher.eraseToAnyPublisher()
    }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❗Apple Login Error = ASAuthorizationAppleIDCredentials 캐스팅 실패")
            return
        }
        
        print("🟢Apple Login 성공 = \(credentials.user)")
        
        if
            let authorizationCode = credentials.authorizationCode,
            let identityToken = credentials.identityToken,
            let authCodeString = String(data: authorizationCode, encoding: .utf8),
            let identityTokenString = String(data: identityToken, encoding: .utf8) {
            responsePublisher.send(
                SignInWithAppleResponse(
                    id: credentials.user,
                    authorizationCode: authCodeString,
                    identityToken: identityTokenString))
        } else {
            print("❗Apple Login Error = Auth Code, IdToken 타입 캐스팅 실패")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❗Apple Login Error = \(error.localizedDescription)")
    }
}
