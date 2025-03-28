//
//  ProfileViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 27/02/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var CorreoTF: UITextField!
    @IBOutlet weak var AlturaTF: UITextField!
    @IBOutlet weak var PesoTF: UITextField!

    @IBOutlet weak var ApellidoTF: UITextField!
    @IBOutlet weak var NombreTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = SessionManager.shared.getUser() {
            NombreTF.text = user.nombre
            ApellidoTF.text = user.apellido
            // Formatear peso y estatura como string con 2 decimales
            PesoTF.text = String(format: "%.2f", user.peso)
            AlturaTF.text = String(format: "%.2f", user.estatura)
            CorreoTF.text = user.email
        }
    }
    @IBAction func LogoutBTN(_ sender: UIButton) {
        logoutFromAPI()
    }
    func logoutFromAPI() {
            guard let token = SessionManager.shared.getToken() else {
                self.goToLogin()
                return
            }
            ApiService.shared.logout(token: token) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let mensaje):
                        print(mensaje)
                        SessionManager.shared.clearSession()
                        self.goToLogin()
                    case .failure(let error):
                        self.showAlert(error.localizedDescription) {
                            SessionManager.shared.clearSession()
                            self.goToLogin()
                        }
                    }
                }
            }
        }
        
        func showAlert(_ message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            })
            present(alert, animated: true)
        }
        
        func goToLogin() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "Loginview") as? LoginViewController {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }
      
        @IBAction func BtnEditarPerfil(_ sender: Any) {
            performSegue(withIdentifier: "sgeditarperfil", sender: nil)
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "sgeditarperfil" {
                if let editarVC = segue.destination as? EditProfileViewController,
                   let user = SessionManager.shared.getUser() {
                    editarVC.user = user
                    editarVC.delegate = self
                }
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
extension ProfileViewController: EditProfileDelegate {
    func perfilActualizado(_ user: User) {
        NombreTF.text = user.nombre
        ApellidoTF.text = user.apellido
        PesoTF.text = String(format: "%.2f", user.peso)
        AlturaTF.text = String(format: "%.2f", user.estatura)
        CorreoTF.text = user.email
        
        SessionManager.shared.saveUser(user)
    }
}
