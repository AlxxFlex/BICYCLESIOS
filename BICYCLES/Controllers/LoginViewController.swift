//
//  LoginViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 27/02/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPasswordField()
    }
    @IBAction func loginTapped(_ sender: UIButton) {
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
                          // 1) Detecta si es nuestro error de verificación
                          if let verificationError = error as? VerificationNeededError {
                              // Opción A: Mostrar un Alert con el mensaje y luego ir a la vista de verificación
                              /*
                              self.showAlert(verificationError.message) {
                                  self.goToVerify(email: verificationError.email)
                              }
                              */
                              
                              // Opción B: Ir directo sin alert
                              self.goToVerify(email: verificationError.email)
                          
                          } else {
                              // 2) Si no es error de verificación, muestra el alert normal
                              let message = error.localizedDescription
                              self.showAlert(message)
                          }
                      }
                  }
              }
    }
    func goToVerify(email: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let verifyVC = storyboard.instantiateViewController(withIdentifier: "VerifyView") as? VerifyCodeViewController {
            verifyVC.email = email
            verifyVC.modalPresentationStyle = .fullScreen
            self.present(verifyVC, animated: true)
        }
    }
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
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "ERROR",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
   
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
