//
//  Identity.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 9/10/21.
//

import AuthenticationServices

struct IdentityModel: Codable {
    static let USER_DEFAULTS_KEY = "IDENTITY_KEY"
    
    var userId: String
    var givenName: String?
    var familyName: String?
    var email: String?
    var token: Data?
    
    static func fromCredential(credential: ASAuthorizationAppleIDCredential) -> IdentityModel? {
        return IdentityModel(
            userId: credential.user,
            givenName: credential.fullName?.givenName,
            familyName: credential.fullName?.familyName,
            email: credential.email,
            token: credential.identityToken)
    }
    
    static func fromData(data: Data?) -> IdentityModel? {
        guard
            let d = data,
            let identity = try? JSONDecoder().decode(IdentityModel.self, from: d)
        else { return nil }
        
        return identity;
    }
}
