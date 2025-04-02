//
//  CurrentRouteViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 02/04/25.
//

import UIKit

class CurrentRouteViewController: UIViewController {

    
    var mostrarAlertaInicio: Bool = false
    var recorridoId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mostrarAlertaInicio {
          mostrarAlarma(texto: "Recorrido iniciado")
      }
        if let id = recorridoId {
            print("📦 ID del recorrido recibido: \(id)")
        }
    }
    func mostrarAlarma(texto: String) {
        let alerta = UILabel()
        alerta.text = "  \(texto)  "
        alerta.textAlignment = .center
        alerta.font = UIFont(name: "Chalkboard SE", size: 16)
        alerta.textColor = .white
        alerta.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.4, alpha: 1.0)
        alerta.layer.cornerRadius = 15
        alerta.clipsToBounds = true
        alerta.alpha = 0
        alerta.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(alerta)

        NSLayoutConstraint.activate([
            alerta.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            alerta.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            alerta.heightAnchor.constraint(equalToConstant: 40)
        ])

        UIView.animate(withDuration: 0.3) {
            alerta.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.3, animations: {
                alerta.alpha = 0
            }, completion: { _ in
                alerta.removeFromSuperview()
            })
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
