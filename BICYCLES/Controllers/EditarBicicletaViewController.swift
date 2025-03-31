//
//  EditarBicicletaViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 31/03/25.
//

import UIKit

protocol EditarBicicletaDelegate: AnyObject {
    func didEditBicicleta()
}

class EditarBicicletaViewController: UIViewController {

    @IBOutlet weak var EditBiciTF: UITextField!
    
    var bicicleta: Bicicleta?
    weak var delegate: EditarBicicletaDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
           if let bicicleta = bicicleta {
               EditBiciTF.text = bicicleta.nombre
           }

    }
    @IBAction func GuardarBtnBici(_ sender: Any) {
        guard let nombre = EditBiciTF.text, !nombre.isEmpty, let id = bicicleta?.id else {
            mostrarAlerta(titulo: "⚠️", mensaje: "El nombre no puede estar vacío.")
            return
        }
        
        
        let parametros: [String: Any] = ["nombre": nombre]
        
        
        ApiService.shared.editarBicicleta(id: id, parametros: parametros) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Bicicleta editada correctamente.")
                    self?.mostrarAlerta(titulo: "✅", mensaje: "Bicicleta actualizada correctamente.") {
                        self?.delegate?.didEditBicicleta()
                        self?.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print("❌ Error al editar la bicicleta: \(error.localizedDescription)")
                    self?.mostrarAlerta(titulo: "❌", mensaje: "No se pudo actualizar la bicicleta.")
                }
            }
        }
    }
    func mostrarAlerta(titulo: String, mensaje: String, accion: (() -> Void)? = nil) {
            let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                accion?()
            })
            present(alerta, animated: true, completion: nil)
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
