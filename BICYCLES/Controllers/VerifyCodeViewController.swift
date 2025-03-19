//
//  VerifyCodeViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 13/03/25.
//

import UIKit

class VerifyCodeViewController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    var email: String? 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func RessendBTN(_ sender: UIButton) {
    guard let email = email else {
                // Aquí podrías mostrar un alert o manejar error
                return
            }
            
            ApiService.shared.resendVerification(email: email) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let resendResponse):
                        // Aquí 'resendResponse.mensaje' contendrá el texto de éxito
                        self.showAlert(resendResponse.mensaje)
                        
                    case .failure(let error):
                        self.showAlert(error.localizedDescription)
                    }
                }
            }
       }
    
    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        guard let code = codeTextField.text, !code.isEmpty else {
            showAlert("Por favor, ingresa el código de verificación.")
            return
        }
        guard let email = email else { return }
        
        ApiService.shared.sendVerification(email: email, codigo: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let verifyResponse):
                    self.showAlert("¡Cuenta activada con éxito!") {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let loginVC = storyboard.instantiateViewController(withIdentifier: "Loginview") as? LoginViewController {
                            loginVC.modalPresentationStyle = .fullScreen
                            self.present(loginVC, animated: true)
                        }
                    }
                case .failure(let error):
                    self.showAlert(error.localizedDescription)
                }
            }
        }
    }
    
    func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
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
