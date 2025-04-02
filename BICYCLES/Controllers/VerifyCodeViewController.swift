//
//  VerifyCodeViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 13/03/25.
//

import UIKit

class VerifyCodeViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var BtnConfirmar: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    var email: String? 
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.delegate = self
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
                        CustomAlertView.showSuccessAlert(message: resendResponse.mensaje)
                        
                    case .failure(let error):
                        CustomAlertView.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
       }
    
    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        // 💡 Desactivar botón antes de enviar
           BtnConfirmar.isEnabled = false
           BtnConfirmar.alpha = 0.5

           guard let code = codeTextField.text, !code.isEmpty else {
               CustomAlertView.showYellowAlert(message: "Por favor, ingresa el código de verificación para activar tu cuenta.")
               BtnConfirmar.isEnabled = true
               BtnConfirmar.alpha = 1.0
               return
           }

           guard let email = email else {
               BtnConfirmar.isEnabled = true
               BtnConfirmar.alpha = 1.0
               return
           }

           ApiService.shared.sendVerification(email: email, codigo: code) { result in
               DispatchQueue.main.async {
                   // 💡 Reactivar botón después de la respuesta
                   self.BtnConfirmar.isEnabled = true
                   self.BtnConfirmar.alpha = 1.0

                   switch result {
                   case .success(let verifyResponse):
                       CustomAlertView.showSuccessAlert(message: "¡Cuenta activada con éxito!"){
                           let storyboard = UIStoryboard(name: "Main", bundle: nil)
                           if let loginVC = storyboard.instantiateViewController(withIdentifier: "Loginview") as? LoginViewController {
                               loginVC.modalPresentationStyle = .fullScreen
                               self.present(loginVC, animated: true)
                           }
                       }

                   case .failure(let error):
                       CustomAlertView.showErrorAlert(message: error.localizedDescription)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true) // Oculta el teclado al tocar fuera
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Oculta el teclado
            return true
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
