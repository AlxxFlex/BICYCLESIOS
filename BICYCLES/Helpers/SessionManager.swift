//
//  SessionManager.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 10/03/25.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()

    private let tokenKey = "authToken"

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func getToken() -> String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }

    func isLoggedIn() -> Bool {
        getToken() != nil
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
