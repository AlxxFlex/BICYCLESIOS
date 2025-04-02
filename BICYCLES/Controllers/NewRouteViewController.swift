//
//  NewRouteViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 27/02/25.
//

import UIKit

class NewRouteViewController: UIViewController {

    @IBOutlet weak var BtnOtraVista: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func IrOtraVista(_ sender: Any) {
        guard let selectVC = storyboard?.instantiateViewController(withIdentifier: "SelectBicycleViewController") as? SelectBicycleViewController else {
            return
        }

        // Configurar el callback
        selectVC.onRecorridoCreado = { [weak self] recorridoId in
            print("👉 Recorrido recibido en NewRouteViewController: \(recorridoId)")
            // Aquí puedes guardar el recorridoId o usarlo como quieras
        }

        // Presentarlo modally
        selectVC.modalPresentationStyle = .pageSheet // o .formSheet, .fullScreen, etc.
        present(selectVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgselectbicycle",
           let destino = segue.destination as? SelectBicycleViewController {
            destino.onRecorridoCreado = { [weak self] recorridoId in
                print("👉 Recorrido recibido en NewRouteViewController: \(recorridoId)")
                // Puedes guardarlo o pasarlo a otra vista
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
