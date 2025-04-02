//
//  RegisterStep3ViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 16/03/25.
//

import UIKit

class RegisterStep3ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var confirmpassTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var registerData = RegisterData()
    
    var emailErrorLabel: UILabel!
    var passwordErrorLabel: UILabel!
    var confirmPasswordErrorLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupPasswordField()
        setupErrorLabels()
       setupConfirmPasswordField()
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmpassTF.delegate = self
       
       let backButton = UIButton(type: .system)
       let image = UIImage(systemName: "arrowshape.left.fill")
       backButton.setImage(image, for: .normal)
       let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
       backButton.setImage(UIImage(systemName: "arrowshape.left.fill", withConfiguration: config), for: .normal)
       backButton.tintColor = .white
       backButton.backgroundColor = .lightGray
       backButton.frame = CGRect(x: 0, y: 0, width: 45, height: 50)
       backButton.layer.cornerRadius = 22
       backButton.clipsToBounds = true
       backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
       navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
   }
    func setupErrorLabels() {
           
           emailErrorLabel = createErrorLabel(withText: "El correo es obligatorio.")
           view.addSubview(emailErrorLabel)
           
           passwordErrorLabel = createErrorLabel(withText: "La contraseña es obligatoria.")
           view.addSubview(passwordErrorLabel)
           
           
           confirmPasswordErrorLabel = createErrorLabel(withText: "Debes confirmar tu contraseña.")
           view.addSubview(confirmPasswordErrorLabel)

           
           NSLayoutConstraint.activate([
               emailErrorLabel.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 6),
               emailErrorLabel.leadingAnchor.constraint(equalTo: emailTF.leadingAnchor),
               emailErrorLabel.trailingAnchor.constraint(equalTo: emailTF.trailingAnchor),

               passwordErrorLabel.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 6),
               passwordErrorLabel.leadingAnchor.constraint(equalTo: passwordTF.leadingAnchor),
               passwordErrorLabel.trailingAnchor.constraint(equalTo: passwordTF.trailingAnchor),

               confirmPasswordErrorLabel.topAnchor.constraint(equalTo: confirmpassTF.bottomAnchor, constant: 6),
               confirmPasswordErrorLabel.leadingAnchor.constraint(equalTo: confirmpassTF.leadingAnchor),
               confirmPasswordErrorLabel.trailingAnchor.constraint(equalTo: confirmpassTF.trailingAnchor)
           ])
       }

       func createErrorLabel(withText text: String) -> UILabel {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .red
           label.font = UIFont.systemFont(ofSize: 12)
           label.text = text
           label.isHidden = true
           return label
       }
    
   @objc func customBackAction() {
       navigationController?.popViewController(animated: true)
   }
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        
        // Desactivar botón mientras se procesa
            finishButton.isEnabled = false
            finishButton.alpha = 0.5

            emailErrorLabel.isHidden = true
            passwordErrorLabel.isHidden = true
            confirmPasswordErrorLabel.isHidden = true

            var isValid = true

            // Validar campos
            guard let email = emailTF.text, !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                emailErrorLabel.isHidden = false
                emailErrorLabel.text = "El correo es obligatorio."
                isValid = false
                finishButton.isEnabled = true
                finishButton.alpha = 1.0
                return
            }

            guard isValidEmail(email) else {
                emailErrorLabel.isHidden = false
                emailErrorLabel.text = "Formato de correo inválido."
                isValid = false
                finishButton.isEnabled = true
                finishButton.alpha = 1.0
                return
            }

            guard let pass = passwordTF.text, !pass.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                passwordErrorLabel.isHidden = false
                passwordErrorLabel.text = "La contraseña es obligatoria."
                isValid = false
                finishButton.isEnabled = true
                finishButton.alpha = 1.0
                return
            }

            guard pass.count >= 6 else {
                passwordErrorLabel.isHidden = false
                passwordErrorLabel.text = "La contraseña debe tener al menos 6 caracteres."
                isValid = false
                finishButton.isEnabled = true
                finishButton.alpha = 1.0
                return
            }

            guard let confirmPass = confirmpassTF.text, !confirmPass.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                confirmPasswordErrorLabel.isHidden = false
                confirmPasswordErrorLabel.text = "Debes confirmar tu contraseña."
                isValid = false
                finishButton.isEnabled = true
                finishButton.alpha = 1.0
                return
            }

            guard pass == confirmPass else {
                confirmPasswordErrorLabel.isHidden = false
                confirmPasswordErrorLabel.text = "Las contraseñas no coinciden."
                isValid = false
                finishButton.isEnabled = true
                finishButton.alpha = 1.0
                return
            }

            guard let nombre = registerData.nombre,
                  let apellido = registerData.apellido,
                  let peso = registerData.peso,
                  let estatura = registerData.estatura else {
                showAlert("Faltan datos de los pasos anteriores. Por favor, completa todos los campos.")
                finishButton.isEnabled = true
                finishButton.alpha = 1.0
                return
            }

            if isValid {
                ApiService.shared.register(
                    nombre: nombre,
                    apellido: apellido,
                    peso: peso,
                    estatura: estatura,
                    email: email,
                    password: pass,
                    confirm_password: confirmPass
                ) { result in
                    DispatchQueue.main.async {
                        self.finishButton.isEnabled = true
                        self.finishButton.alpha = 1.0

                        switch result {
                        case .success(let response):
                            self.showAlert("Registro exitoso: \(response.usuario.email)") {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let verifyVC = storyboard.instantiateViewController(withIdentifier: "VerifyView") as? VerifyCodeViewController {
                                    verifyVC.email = email
                                    verifyVC.modalPresentationStyle = .fullScreen
                                    self.present(verifyVC, animated: true, completion: nil)
                                }
                            }

                        case .failure(let error):
                            self.showAlert(error.localizedDescription)
                        }
                    }
                }
            } else {
                finishButton.isEnabled = true
                finishButton.alpha = 1.0
            }
          }

          func isValidEmail(_ email: String) -> Bool {
              let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
              let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
              return emailPredicate.evaluate(with: email)
          }

          func setupPasswordField() {
              passwordTF.isSecureTextEntry = true
              let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
              let eyeButton = UIButton(type: .custom)
              eyeButton.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
              eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
              eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
              containerView.addSubview(eyeButton)
              passwordTF.rightView = containerView
              passwordTF.rightViewMode = .always
          }

          @objc func togglePasswordVisibility() {
              passwordTF.isSecureTextEntry.toggle()
              let newImage = passwordTF.isSecureTextEntry ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
              (passwordTF.rightView as? UIView)?.subviews.compactMap { $0 as? UIButton }.first?.setImage(newImage, for: .normal)
          }

          func setupConfirmPasswordField() {
              confirmpassTF.isSecureTextEntry = true
              let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
              let eyeButton = UIButton(type: .custom)
              eyeButton.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
              eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
              eyeButton.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
              containerView.addSubview(eyeButton)
              confirmpassTF.rightView = containerView
              confirmpassTF.rightViewMode = .always
          }

          @objc func toggleConfirmPasswordVisibility() {
              confirmpassTF.isSecureTextEntry.toggle()
              let newImage = confirmpassTF.isSecureTextEntry ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
              (confirmpassTF.rightView as? UIView)?.subviews.compactMap { $0 as? UIButton }.first?.setImage(newImage, for: .normal)
          }
    func showAlert(_ message: String, completion: (() -> Void)? = nil) {
           let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default) { _ in
               completion?()  // Ejecuta la closure si existe
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
       
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


