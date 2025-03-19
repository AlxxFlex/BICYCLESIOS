//
//  ApiService.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 10/03/25.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    private let baseURL = "http://127.0.0.1:8000/api/v1"

    func login(email: String, password: String, completion: @escaping(Result<AuthResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                let noDataError = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Sin datos en la respuesta"])
                completion(.failure(noDataError))
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    completion(.success(authResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Aquí manejamos el error
                do {
                    // Intenta decodificar el JSON de error
                    let errorObject = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                    
                    // Checamos si el error indica que falta verificar el correo
                    if errorObject.redirect == "verify_code",
                       let unverifiedEmail = errorObject.email {
                        
                        // Construimos un error personalizado
                        let verificationError = VerificationNeededError(
                            email: unverifiedEmail,
                            message: errorObject.mensaje ?? "Tu correo no está verificado"
                        )
                        
                        // Devolvemos ese error
                        completion(.failure(verificationError))
                        
                    } else {
                        // Manejo normal de error
                        let errMessage = errorObject.errores?.values
                            .flatMap { $0 }
                            .joined(separator: "\n")
                            ?? errorObject.mensaje
                            ?? "Error desconocido"
                        
                        let apiError = NSError(domain: "", code: httpResponse.statusCode,
                                               userInfo: [NSLocalizedDescriptionKey: errMessage])
                        completion(.failure(apiError))
                    }
                } catch {
                    // Si no pudo decodificar el JSON de error
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    func register(nombre: String,
                      apellido: String,
                      peso: Float,
                      estatura: Float,
                      email: String,
                      password: String,
                      completion: @escaping(Result<RegisterResponse, Error>) -> Void) {

            guard let url = URL(string: "\(baseURL)/register") else {
                let error = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
                completion(.failure(error))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "nombre": nombre,
                "apellido": apellido,
                "peso": peso,
                "estatura": estatura,
                "email": email,
                "password": password
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      let data = data else {
                    let noDataError = NSError(domain: "", code: -2,
                                              userInfo: [NSLocalizedDescriptionKey: "Respuesta o datos nulos"])
                    completion(.failure(noDataError))
                    return
                }

                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    do {
                        let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                        completion(.success(registerResponse))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    do {
                        let errorResponse = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                        let errorMessage = errorResponse.errores?.values
                            .flatMap { $0 }
                            .joined(separator: "\n")
                            ?? errorResponse.mensaje
                            ?? "Error desconocido"

                        let apiError = NSError(domain: "",
                                               code: httpResponse.statusCode,
                                               userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(apiError))
                    } catch {
                        let genericError = NSError(domain: "",
                                                   code: httpResponse.statusCode,
                                                   userInfo: [NSLocalizedDescriptionKey: "Error desconocido del servidor"])
                        completion(.failure(genericError))
                    }
                }
            }.resume()
        }
    func sendVerification(email: String,
                              codigo: String,
                              completion: @escaping(Result<VerifyResponse, Error>) -> Void) {

            // Asegúrate de poner la URL real de tu endpoint
            guard let url = URL(string: "\(baseURL)/send") else {
                let error = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
                completion(.failure(error))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Cuerpo del request con email y código
            let body: [String: Any] = [
                "email": email,
                "codigo": codigo
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                // 1) Error de conexión
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // 2) Verificar data y response
                guard let httpResponse = response as? HTTPURLResponse,
                      let data = data else {
                    let noDataError = NSError(domain: "", code: -2,
                                              userInfo: [NSLocalizedDescriptionKey: "Sin datos en la respuesta"])
                    completion(.failure(noDataError))
                    return
                }

                // 3) Manejo de status code
                if httpResponse.statusCode == 200 {
                    do {
                        let verifyResponse = try JSONDecoder().decode(VerifyResponse.self, from: data)
                        completion(.success(verifyResponse))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    // Error (400, 422, 500, etc.)
                    do {
                        let errorResponse = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                        let errorMessage = errorResponse.errores?.values
                            .flatMap { $0 }
                            .joined(separator: "\n")
                            ?? errorResponse.mensaje
                            ?? "Error desconocido"

                        let apiError = NSError(domain: "", code: httpResponse.statusCode,
                                               userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(apiError))
                    } catch {
                        let genericError = NSError(domain: "", code: httpResponse.statusCode,
                                                   userInfo: [NSLocalizedDescriptionKey: "Error desconocido del servidor"])
                        completion(.failure(genericError))
                    }
                }
            }.resume()
        }
    func resendVerification(email: String, completion: @escaping (Result<ResendResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/reenviar") else {
            let error = NSError(domain: "", code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Cuerpo del request con el email
        let body: [String: Any] = [
            "email": email
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Error de conexión
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
                let noDataError = NSError(domain: "", code: -2,
                                          userInfo: [NSLocalizedDescriptionKey: "Sin datos en la respuesta"])
                completion(.failure(noDataError))
                return
            }
            
            // Si el status es 200, parseamos
            if httpResponse.statusCode == 200 {
                do {
                    let resendResponse = try JSONDecoder().decode(ResendResponse.self, from: data)
                    completion(.success(resendResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Manejo de error
                do {
                    let errorResponse = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                    let errorMessage = errorResponse.errores?.values
                        .flatMap { $0 }
                        .joined(separator: "\n")
                        ?? errorResponse.mensaje
                        ?? "Error desconocido"
                    
                    let apiError = NSError(domain: "", code: httpResponse.statusCode,
                                           userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(apiError))
                } catch {
                    let genericError = NSError(domain: "", code: httpResponse.statusCode,
                                               userInfo: [NSLocalizedDescriptionKey: "Error desconocido del servidor"])
                    completion(.failure(genericError))
                }
            }
        }.resume()
    }
    
}
