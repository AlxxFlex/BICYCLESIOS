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

class EditProfileViewController: UIViewController {

    weak var delegate: EditProfileDelegate?
    
    @IBOutlet weak var EmailTFE: UITextField!
    @IBOutlet weak var NombreTFE: UITextField!
    @IBOutlet weak var ApellidoTFE: UITextField!
    @IBOutlet weak var PesoTFE: UITextField!
   
    @IBOutlet weak var AlturaTFE: UITextField!
    var user: User?  // Recibes el usuario de la otra pantalla

    // Labels para mostrar errores
    var errorNombreLabel = UILabel()
    var errorApellidoLabel = UILabel()
    var errorEmailLabel = UILabel()
    var errorPesoLabel = UILabel()
    var errorEstaturaLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Mostrar datos recibidos del usuario
        if let u = user {
            NombreTFE.text = u.nombre
            ApellidoTFE.text = u.apellido
            EmailTFE.text = u.email
            
            // Convertir peso y estatura de Float a String con 2 decimales
            PesoTFE.text = String(format: "%.2f", u.peso)
            AlturaTFE.text = String(format: "%.2f", u.estatura)
        }

        // Configurar teclado numérico para peso y altura
        PesoTFE.keyboardType = .decimalPad
        AlturaTFE.keyboardType = .decimalPad

        // Configurar etiquetas de error
        setupErrorLabels()
    }
    @IBAction func BtnEditarPerfil(_ sender: Any) {
        editarPerfil()
    }
    func editarPerfil() {
        // Limpiar errores anteriores
        mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: nil, estatura: nil)

        var errorNombre: String?
        var errorApellido: String?
        var errorEmail: String?
        var errorPeso: String?
        var errorEstatura: String?

        // Validar nombre
        guard let nombre = NombreTFE.text, !nombre.isEmpty else {
            errorNombre = "Este campo es obligatorio"
            mostrarErrores(nombre: errorNombre, apellido: nil, email: nil, peso: nil, estatura: nil)
            return
        }

        // Validar apellido
        guard let apellido = ApellidoTFE.text, !apellido.isEmpty else {
            errorApellido = "Este campo es obligatorio"
            mostrarErrores(nombre: nil, apellido: errorApellido, email: nil, peso: nil, estatura: nil)
            return
        }

        // Validar email
        guard let email = EmailTFE.text, !email.isEmpty else {
            errorEmail = "Este campo es obligatorio"
            mostrarErrores(nombre: nil, apellido: nil, email: errorEmail, peso: nil, estatura: nil)
            return
        }

        // Validar formato de email
        if !isValidEmail(email) {
            errorEmail = "Correo no válido"
            mostrarErrores(nombre: nil, apellido: nil, email: errorEmail, peso: nil, estatura: nil)
            return
        }

        // Validar peso
        guard let pesoStr = PesoTFE.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !pesoStr.isEmpty,
              let peso = Float(pesoStr.replacingOccurrences(of: ",", with: ".")) else {
            errorPeso = "Este campo debe ser numérico"
            mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: errorPeso, estatura: nil)
            return
        }

        // Validar rango de peso
        if peso < 20 || peso > 150 {
            errorPeso = "Peso fuera de rango"
            mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: errorPeso, estatura: nil)
            return
        }

        // Validar estatura
        guard let estaturaStr = AlturaTFE.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !estaturaStr.isEmpty,
              let estatura = Float(estaturaStr.replacingOccurrences(of: ",", with: ".")) else {
            errorEstatura = "Este campo debe ser numérico"
            mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: nil, estatura: errorEstatura)
            return
        }

        // Validar rango de estatura
        if estatura < 1.10 || estatura > 2.20 {
            errorEstatura = "Estatura fuera de rango"
            mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: nil, estatura: errorEstatura)
            return
        }

        // ✅ Actualizar perfil si todas las validaciones son correctas
        // ✅ Actualizar perfil si todas las validaciones son correctas
        ApiService.shared.actualizarPerfil(
            nombre: nombre,
            apellido: apellido,
            email: email,
            peso: peso,
            estatura: estatura
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let mensaje):
                    // Actualizar el usuario con la nueva información
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
                    self.showAlert("Perfil actualizado correctamente.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self.showAlert(error.localizedDescription)
                }
            }
        }
    }

// Mostrar errores si ocurren
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

   // Configurar las etiquetas de error
   func setupErrorLabels() {
       let labels = [errorNombreLabel, errorApellidoLabel, errorEmailLabel, errorPesoLabel, errorEstaturaLabel]
       
       for label in labels {
           label.textColor = .systemRed
           label.font = UIFont.systemFont(ofSize: 12)
           label.numberOfLines = 0
           label.isHidden = true
           view.addSubview(label)
       }

       // Posicionar las etiquetas de error debajo de cada campo
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

   // Validar formato de correo
   func isValidEmail(_ email: String) -> Bool {
       let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
       return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
   }

   // Mostrar alertas
    func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Información", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?() // Ejecuta la acción después de cerrar la alerta si existe
        })
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
