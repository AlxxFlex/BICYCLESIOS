//
//  NewBicicletaViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 29/03/25.
//

import UIKit

class NewBicicletaViewController: UIViewController {


    @IBOutlet weak var NombreBiciTF: UITextField!
    var nuevaBicicleta: Bicicleta?
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        // MARK: - Acción para agregar bicicleta
        @IBAction func agregarBicicleta(_ sender: UIButton) {
            guard let nombre = NombreBiciTF.text, !nombre.isEmpty else {
                print("⚠️ El nombre de la bicicleta no puede estar vacío.")
                return
            }
            
            let parametros: [String: Any] = ["nombre": nombre]
            
            // Realizar la petición para crear la bicicleta
            ApiService.shared.crearBicicleta(parametros: parametros) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let bicicleta):
                        print("✅ Bicicleta creada: \(bicicleta.nombre)")
                        self?.nuevaBicicleta = bicicleta
                        self?.performSegue(withIdentifier: "unwindToBicycles", sender: self)
                    case .failure(let error):
                        print("❌ Error al crear la bicicleta: \(error.localizedDescription)")
                    }
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
