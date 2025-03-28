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
       private let userKey  = "authUser" // Para guardar el User en JSON
       
       // MARK: - Token
       
       func saveToken(_ token: String) {
           UserDefaults.standard.set(token, forKey: tokenKey)
       }
       
       func getToken() -> String? {
           UserDefaults.standard.string(forKey: tokenKey)
       }
       
       func isLoggedIn() -> Bool {
           getToken() != nil
       }
       
       // MARK: - User
       
       /// Guarda el `User` como JSON en `UserDefaults`.
       func saveUser(_ user: User) {
           if let encoded = try? JSONEncoder().encode(user) {
               UserDefaults.standard.set(encoded, forKey: userKey)
           }
       }
       
       /// Recupera el `User` guardado (si existe).
       func getUser() -> User? {
           guard let userData = UserDefaults.standard.data(forKey: userKey),
                 let decodedUser = try? JSONDecoder().decode(User.self, from: userData)
           else {
               return nil
           }
           return decodedUser
       }
       
       // MARK: - Cerrar sesión
       
       /// Elimina tanto el token como el User guardado.
       func clearSession() {
           UserDefaults.standard.removeObject(forKey: tokenKey)
           UserDefaults.standard.removeObject(forKey: userKey)
       }
       
       // También podrías dejar tu método `logout()` si prefieres ese nombre
       func logout() {
           clearSession()
       }
}
