//
//  UserModle.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 1/10/21.
//
import AuthenticationServices

class UserModel: ObservableObject {
    @Published var identity: IdentityModel? = IdentityModel.fromData(
        data: UserDefaults.standard.data(forKey: IdentityModel.USER_DEFAULTS_KEY))
    
    @Published var isAuthorised: Bool = false
    
    private var provider: ASAuthorizationAppleIDProvider
    private static let authScopes: [ASAuthorization.Scope] = [.fullName, .email]
    
    init() {
        self.provider = ASAuthorizationAppleIDProvider()
        
        if let identity = self.identity {
            self.provider.getCredentialState(forUserID: identity.userId, completion: { (credentialState, error) in
                DispatchQueue.main.async {
                    self.isAuthorised = credentialState == .authorized
                }
            })
        }
    }
    
    public func request(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = UserModel.authScopes
    }
    
    public func handle(_ authResult: Result<ASAuthorization, Error>) {
        switch authResult {
        case .success(let auth):
            switch auth.credential {
            case let credential as ASAuthorizationAppleIDCredential:
                if let identity = IdentityModel.fromCredential(credential: credential),
                   let serializedUser = try? JSONEncoder().encode(identity) {
                    
                    UserDefaults.standard.setValue(serializedUser, forKey: IdentityModel.USER_DEFAULTS_KEY)
                    self.identity = identity
                    self.isAuthorised = true
                }
            default:
                print("Auth Success")
            }
        case .failure(let error):
            print(error)
            self.isAuthorised = false
            UserDefaults.standard.removeObject(forKey: IdentityModel.USER_DEFAULTS_KEY)
        }
    }
}
