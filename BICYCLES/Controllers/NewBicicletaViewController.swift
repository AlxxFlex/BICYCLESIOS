//
//  NewBicicletaViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 29/03/25.
//

import UIKit


protocol NewBicicletaDelegate: AnyObject {
    func didAddBicicleta() 
}

class NewBicicletaViewController: UIViewController ,UITextFieldDelegate{
    
    
    @IBOutlet weak var Btnguardarbici: UIButton!
    @IBOutlet weak var NombreBiciTF: UITextField!
    weak var delegate: NewBicicletaDelegate?
       
   override func viewDidLoad() {
       super.viewDidLoad()
       NombreBiciTF.delegate = self
   }
       
    // MARK: - Acción para agregar bicicleta
    @IBAction func agregarBicicleta(_ sender: UIButton) {
        // Desactivar botón mientras se procesa
        Btnguardarbici.isEnabled = false
        Btnguardarbici.alpha = 0.5

        guard let nombre = NombreBiciTF.text, !nombre.isEmpty else {
            mostrarAlerta(titulo: "⚠️ ", mensaje: "El nombre de la bicicleta no puede estar vacío.")
            Btnguardarbici.isEnabled = true
            Btnguardarbici.alpha = 1.0
            return
        }

        let parametros: [String: Any] = ["nombre": nombre]

        ApiService.shared.crearBicicleta(parametros: parametros) { [weak self] result in
            DispatchQueue.main.async {
                // Reactivar botón después de la respuesta
                self?.Btnguardarbici.isEnabled = true
                self?.Btnguardarbici.alpha = 1.0

                switch result {
                case .success:
                    self?.delegate?.didAddBicicleta()
                    self?.dismiss(animated: true, completion: nil)

                case .failure(let error):
                    print("❌ Error al crear la bicicleta: \(error.localizedDescription)")
                    self?.mostrarAlerta(titulo: "❌ ", mensaje: "No se pudo agregar la bicicleta. Inténtalo nuevamente.")
                }
            }
        }
    }
    
    // MARK: - Mostrar Alertas
    func mostrarAlerta(titulo: String, mensaje: String, accion: (() -> Void)? = nil) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            accion?()
        })
        present(alerta, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true) // Oculta el teclado al tocar fuera
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Oculta el teclado
            return true
        }
}
