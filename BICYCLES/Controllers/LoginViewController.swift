//
//  LoginViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 27/02/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    
    
    var emailErrorLabel: UILabel!
    var passwordErrorLabel: UILabel!
    var apiErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPasswordField()
        setupErrorLabels()
        setupApiErrorLabel()
    }
    @IBAction func loginTapped(_ sender: UIButton) {
        if validateFields() {
            guard let email = EmailTF.text, let password = PasswordTF.text else { return }
            
            ApiService.shared.login(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let authResponse):
                        SessionManager.shared.saveToken(authResponse.token)
                        print(authResponse.token)
                        SessionManager.shared.saveUser(authResponse.user)
                        self.goToHome()
                        
                    case .failure(let error):
                        if let verificationError = error as? VerificationNeededError {
                            self.goToVerify(email: verificationError.email)
                        } else {
                            let message = error.localizedDescription
                            self.showApiError(message)
                        }
                    }
                }
            }
        }
    }
    // Configuración de etiquetas de error para email y contraseña
        func setupErrorLabels() {
            // Configuración de error para Email
            emailErrorLabel = UILabel()
            emailErrorLabel.textColor = .red
            emailErrorLabel.font = UIFont.systemFont(ofSize: 12)
            emailErrorLabel.text = ""
            emailErrorLabel.translatesAutoresizingMaskIntoConstraints = false
            EmailTF.superview?.addSubview(emailErrorLabel)
            
            NSLayoutConstraint.activate([
                emailErrorLabel.topAnchor.constraint(equalTo: EmailTF.bottomAnchor, constant: 5),
                emailErrorLabel.leadingAnchor.constraint(equalTo: EmailTF.leadingAnchor),
                emailErrorLabel.trailingAnchor.constraint(equalTo: EmailTF.trailingAnchor)
            ])
            
            // Configuración de error para Password
            passwordErrorLabel = UILabel()
            passwordErrorLabel.textColor = .red
            passwordErrorLabel.font = UIFont.systemFont(ofSize: 12)
            passwordErrorLabel.text = ""
            passwordErrorLabel.translatesAutoresizingMaskIntoConstraints = false
            PasswordTF.superview?.addSubview(passwordErrorLabel)
            
            NSLayoutConstraint.activate([
                passwordErrorLabel.topAnchor.constraint(equalTo: PasswordTF.bottomAnchor, constant: 5),
                passwordErrorLabel.leadingAnchor.constraint(equalTo: PasswordTF.leadingAnchor),
                passwordErrorLabel.trailingAnchor.constraint(equalTo: PasswordTF.trailingAnchor)
            ])
        }

        // Configuración del error de la API arriba del botón de login
        func setupApiErrorLabel() {
            apiErrorLabel = UILabel()
            apiErrorLabel.textColor = .red
            apiErrorLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            apiErrorLabel.textAlignment = .center
            apiErrorLabel.text = ""
            apiErrorLabel.translatesAutoresizingMaskIntoConstraints = false
            loginButton.superview?.addSubview(apiErrorLabel)
            
            NSLayoutConstraint.activate([
                apiErrorLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -8),
                apiErrorLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
                apiErrorLabel.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor)
            ])
        }
        
        // Validación de campos
        func validateFields() -> Bool {
            var isValid = true
            
            // Validar email
            if let email = EmailTF.text, email.isEmpty {
                emailErrorLabel.text = "El correo es obligatorio."
                isValid = false
            } else if let email = EmailTF.text, !isValidEmail(email) {
                emailErrorLabel.text = "El formato del correo no es válido."
                isValid = false
            } else {
                emailErrorLabel.text = ""
            }
            
            // Validar contraseña
            if let password = PasswordTF.text, password.isEmpty {
                passwordErrorLabel.text = "La contraseña es obligatoria."
                isValid = false
            } else {
                passwordErrorLabel.text = ""
            }
            
            return isValid
        }
        
        // Validar formato de correo
        func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
        // Mostrar error de la API encima del botón de login
        func showApiError(_ message: String) {
            apiErrorLabel.text = message
            apiErrorLabel.isHidden = false
        }
        
        // Navegar a la verificación de correo si es necesario
        func goToVerify(email: String) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let verifyVC = storyboard.instantiateViewController(withIdentifier: "VerifyView") as? VerifyCodeViewController {
                verifyVC.email = email
                verifyVC.modalPresentationStyle = .fullScreen
                self.present(verifyVC, animated: true)
            }
        }
        
        // Navegar al Home después del login exitoso
        func goToHome() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                if #available(iOS 13.0, *) {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = scene.windows.first {
                        window.rootViewController = homeVC
                        window.makeKeyAndVisible()
                    }
                } else {
                    let window = UIApplication.shared.keyWindow
                    window?.rootViewController = homeVC
                    window?.makeKeyAndVisible()
                }
            }
        }
        
        // Mostrar alertas generales si es necesario
        func showAlert(_ message: String) {
            let alert = UIAlertController(title: "ERROR",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
        
        // Configurar campo de contraseña con botón para mostrar/ocultar contraseña
        func setupPasswordField() {
            PasswordTF.isSecureTextEntry = true
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
            let eyeButton = UIButton(type: .custom)
            let eyeImage = UIImage(systemName: "eye.fill")
            eyeButton.setImage(eyeImage, for: .normal)
            eyeButton.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
            eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            containerView.addSubview(eyeButton)
            PasswordTF.rightView = containerView
            PasswordTF.rightViewMode = .always
        }
        
        @objc func togglePasswordVisibility() {
            PasswordTF.isSecureTextEntry.toggle()
            if PasswordTF.isSecureTextEntry {
                (PasswordTF.rightView)?.subviews
                    .compactMap { $0 as? UIButton }
                    .first?
                    .setImage(UIImage(systemName: "eye.fill"), for: .normal)
            } else {
                (PasswordTF.rightView)?.subviews
                    .compactMap { $0 as? UIButton }
                    .first?
                    .setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            }
        }
    }
