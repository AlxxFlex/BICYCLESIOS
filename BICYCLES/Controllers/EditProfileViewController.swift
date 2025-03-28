//
//  EditProfileViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 26/03/25.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var EmailTFE: UITextField!
    @IBOutlet weak var NombreTFE: UITextField!
    @IBOutlet weak var ApellidoTFE: UITextField!
    @IBOutlet weak var PesoTFE: UITextField!
    var user: User?
    @IBOutlet weak var AlturaTFE: UITextField!
    var errorNombreLabel = UILabel()
    var errorApellidoLabel = UILabel()
    var errorEmailLabel = UILabel()
    var errorPesoLabel = UILabel()
    var errorEstaturaLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let u = user {
            NombreTFE.text = u.nombre
            ApellidoTFE.text = u.apellido
            PesoTFE.text = String(u.peso)
            AlturaTFE.text = String(u.estatura)
            EmailTFE.text = u.email
        }

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

        guard let nombre = NombreTFE.text, !nombre.isEmpty else {
            errorNombre = "Este campo es obligatorio"
            mostrarErrores(nombre: errorNombre, apellido: nil, email: nil, peso: nil, estatura: nil)
            return
        }

        guard let apellido = ApellidoTFE.text, !apellido.isEmpty else {
            errorApellido = "Este campo es obligatorio"
            mostrarErrores(nombre: nil, apellido: errorApellido, email: nil, peso: nil, estatura: nil)
            return
        }

        guard let email = EmailTFE.text, !email.isEmpty else {
            errorEmail = "Este campo es obligatorio"
            mostrarErrores(nombre: nil, apellido: nil, email: errorEmail, peso: nil, estatura: nil)
            return
        }

        if !isValidEmail(email) {
            errorEmail = "Correo no válido"
            mostrarErrores(nombre: nil, apellido: nil, email: errorEmail, peso: nil, estatura: nil)
            return
        }

        guard let pesoStr = PesoTFE.text, let peso = Float(pesoStr) else {
            errorPeso = "Este campo debe ser numérico"
            mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: errorPeso, estatura: nil)
            return
        }

        if peso < 20 || peso > 150 {
            errorPeso = "Peso fuera de rango"
            mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: errorPeso, estatura: nil)
            return
        }

        guard let estaturaStr = AlturaTFE.text, let estatura = Float(estaturaStr) else {
            errorEstatura = "Este campo debe ser numérico"
            mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: nil, estatura: errorEstatura)
            return
        }

        if estatura < 1.10 || estatura > 2.20 {
            errorEstatura = "Estatura fuera de rango"
            mostrarErrores(nombre: nil, apellido: nil, email: nil, peso: nil, estatura: errorEstatura)
            return
        }

        // Llamar a la API
        ApiService.shared.actualizarPerfil(nombre: nombre, apellido: apellido, email: email, peso: peso, estatura: estatura) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let mensaje):
                    self.showAlert(mensaje)
                case .failure(let error):
                    self.showAlert(error.localizedDescription)
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
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error del servidor", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
