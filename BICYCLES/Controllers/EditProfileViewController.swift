//
//  EditProfileViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 26/03/25.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func perfilActualizado(_ user: User)
}

class EditProfileViewController: UIViewController,UITextFieldDelegate {

    weak var delegate: EditProfileDelegate?
    
    @IBOutlet weak var btnguardar: UIButton!
    @IBOutlet weak var EmailTFE: UITextField!
    @IBOutlet weak var NombreTFE: UITextField!
    @IBOutlet weak var ApellidoTFE: UITextField!
    @IBOutlet weak var PesoTFE: UITextField!
   
    @IBOutlet weak var AlturaTFE: UITextField!
    var user: User?

    
    var errorNombreLabel = UILabel()
    var errorApellidoLabel = UILabel()
    var errorEmailLabel = UILabel()
    var errorPesoLabel = UILabel()
    var errorEstaturaLabel = UILabel()
    
    private var nombreOriginal: String = ""
    private var apellidoOriginal: String = ""
    private var emailOriginal: String = ""
    private var pesoOriginal: String = ""
    private var estaturaOriginal: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        EmailTFE.delegate = self
        NombreTFE.delegate = self
        ApellidoTFE.delegate = self
        PesoTFE.delegate = self
        AlturaTFE.delegate = self
        
        if let u = user {
            NombreTFE.text = u.nombre
            ApellidoTFE.text = u.apellido
            EmailTFE.text = u.email
            PesoTFE.text = String(format: "%.2f", u.peso)
            AlturaTFE.text = String(format: "%.2f", u.estatura)
            
            
            nombreOriginal = u.nombre
            apellidoOriginal = u.apellido
            emailOriginal = u.email
            pesoOriginal = String(format: "%.2f", u.peso)
            estaturaOriginal = String(format: "%.2f", u.estatura)
            
            
            btnguardar.isEnabled = false
            btnguardar.alpha = 0.5
        }

        
        PesoTFE.keyboardType = .decimalPad
        AlturaTFE.keyboardType = .decimalPad

        setupErrorLabels()
    }
    @IBAction func BtnEditarPerfil(_ sender: Any) {
        editarPerfil()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        verificarCambios()
    }
    func editarPerfil() {
        
           btnguardar.isEnabled = false
           btnguardar.alpha = 0.5

           mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: nil, estatura: nil)

           var errorNombre: String?
           var errorApellido: String?
           var errorEmail: String?
           var errorPeso: String?
           var errorEstatura: String?

           guard let nombre = NombreTFE.text, !nombre.isEmpty else {
               errorNombre = "Este campo es obligatorio"
               mostrarErrores(nombre: errorNombre, apellido: nil, email: nil, peso: nil, estatura: nil)
               btnguardar.isEnabled = true
               btnguardar.alpha = 1.0
               return
           }

           guard let apellido = ApellidoTFE.text, !apellido.isEmpty else {
               errorApellido = "Este campo es obligatorio"
               mostrarErrores(nombre: nil, apellido: errorApellido, email: nil, peso: nil, estatura: nil)
               btnguardar.isEnabled = true
               btnguardar.alpha = 1.0
               return
           }

           guard let email = EmailTFE.text, !email.isEmpty else {
               errorEmail = "Este campo es obligatorio"
               mostrarErrores(nombre: nil, apellido: nil, email: errorEmail, peso: nil, estatura: nil)
               btnguardar.isEnabled = true
               btnguardar.alpha = 1.0
               return
           }

           if !isValidEmail(email) {
               errorEmail = "Correo no válido"
               mostrarErrores(nombre: nil, apellido: nil, email: errorEmail, peso: nil, estatura: nil)
               btnguardar.isEnabled = true
               btnguardar.alpha = 1.0
               return
           }

           guard let pesoStr = PesoTFE.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                 !pesoStr.isEmpty,
                 let peso = Float(pesoStr.replacingOccurrences(of: ",", with: ".")) else {
               errorPeso = "Este campo debe ser numérico"
               mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: errorPeso, estatura: nil)
               btnguardar.isEnabled = true
               btnguardar.alpha = 1.0
               return
           }

           if peso < 20 || peso > 150 {
               errorPeso = "Peso fuera de rango"
               mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: errorPeso, estatura: nil)
               btnguardar.isEnabled = true
               btnguardar.alpha = 1.0
               return
           }

           guard let estaturaStr = AlturaTFE.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                 !estaturaStr.isEmpty,
                 let estatura = Float(estaturaStr.replacingOccurrences(of: ",", with: ".")) else {
               errorEstatura = "Este campo debe ser numérico"
               mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: nil, estatura: errorEstatura)
               btnguardar.isEnabled = true
               btnguardar.alpha = 1.0
               return
           }

           if estatura < 1.10 || estatura > 2.20 {
               errorEstatura = "Estatura fuera de rango"
               mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: nil, estatura: errorEstatura)
               btnguardar.isEnabled = true
               btnguardar.alpha = 1.0
               return
           }

           ApiService.shared.actualizarPerfil(
               nombre: nombre,
               apellido: apellido,
               email: email,
               peso: peso,
               estatura: estatura
           ) { result in
               DispatchQueue.main.async {
                   self.btnguardar.isEnabled = true
                   self.btnguardar.alpha = 1.0

                   switch result {
                   case .success(_):
                       let updatedUser = User(
                        id: self.user?.id,
                        nombre: nombre,
                        apellido: apellido,
                        peso: peso,
                        estatura: estatura,
                        email: email,
                        rol_id: self.user?.rol_id,
                        email_verified_at: self.user?.email_verified_at,
                        deleted_at: self.user?.deleted_at
                       )
                       self.delegate?.perfilActualizado(updatedUser)
                       CustomAlertView.showSuccessAlert(message: "Perfil actualizado correctamente") {
                           self.dismiss(animated: true, completion: nil)
                       }
                       
                   case .failure(let error):
                       let mensaje = error.localizedDescription.lowercased()
                       CustomAlertView.showErrorAlert(message: error.localizedDescription)
                       
                   }
               }
           }
       }

   func mostrarErrores(nombre: String?, apellido: String?, email: String?, peso: String?, estatura: String?) {
       errorNombreLabel.text = nombre
       errorNombreLabel.isHidden = nombre == nil

       errorApellidoLabel.text = apellido
       errorApellidoLabel.isHidden = apellido == nil

       errorEmailLabel.text = email
       errorEmailLabel.isHidden = email == nil

       errorPesoLabel.text = peso
       errorPesoLabel.isHidden = peso == nil

       errorEstaturaLabel.text = estatura
       errorEstaturaLabel.isHidden = estatura == nil
   }

   
   func setupErrorLabels() {
       let labels = [errorNombreLabel, errorApellidoLabel, errorEmailLabel, errorPesoLabel, errorEstaturaLabel]
       
       for label in labels {
           label.textColor = .systemRed
           label.font = UIFont.systemFont(ofSize: 12)
           label.numberOfLines = 0
           label.isHidden = true
           view.addSubview(label)
       }

       
       errorNombreLabel.translatesAutoresizingMaskIntoConstraints = false
       errorApellidoLabel.translatesAutoresizingMaskIntoConstraints = false
       errorEmailLabel.translatesAutoresizingMaskIntoConstraints = false
       errorPesoLabel.translatesAutoresizingMaskIntoConstraints = false
       errorEstaturaLabel.translatesAutoresizingMaskIntoConstraints = false

       NSLayoutConstraint.activate([
           errorNombreLabel.topAnchor.constraint(equalTo: NombreTFE.bottomAnchor, constant: 4),
           errorNombreLabel.leadingAnchor.constraint(equalTo: NombreTFE.leadingAnchor),

           errorApellidoLabel.topAnchor.constraint(equalTo: ApellidoTFE.bottomAnchor, constant: 4),
           errorApellidoLabel.leadingAnchor.constraint(equalTo: ApellidoTFE.leadingAnchor),

           errorEmailLabel.topAnchor.constraint(equalTo: EmailTFE.bottomAnchor, constant: 4),
           errorEmailLabel.leadingAnchor.constraint(equalTo: EmailTFE.leadingAnchor),

           errorPesoLabel.topAnchor.constraint(equalTo: PesoTFE.bottomAnchor, constant: 4),
           errorPesoLabel.leadingAnchor.constraint(equalTo: PesoTFE.leadingAnchor),

           errorEstaturaLabel.topAnchor.constraint(equalTo: AlturaTFE.bottomAnchor, constant: 4),
           errorEstaturaLabel.leadingAnchor.constraint(equalTo: AlturaTFE.leadingAnchor),
       ])
   }

   
   func isValidEmail(_ email: String) -> Bool {
       let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
       return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
   }

   
    func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Información", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?() 
        })
        present(alert, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func verificarCambios() {
        let nombreCambiado = NombreTFE.text != nombreOriginal
        let apellidoCambiado = ApellidoTFE.text != apellidoOriginal
        let emailCambiado = EmailTFE.text != emailOriginal
        let pesoCambiado = PesoTFE.text != pesoOriginal
        let estaturaCambiada = AlturaTFE.text != estaturaOriginal

        let hayCambios = nombreCambiado || apellidoCambiado || emailCambiado || pesoCambiado || estaturaCambiada

        btnguardar.isEnabled = hayCambios
        btnguardar.alpha = hayCambios ? 1.0 : 0.5
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
