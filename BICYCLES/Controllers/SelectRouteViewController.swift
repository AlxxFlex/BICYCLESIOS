//
//  SelectRouteViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 02/04/25.
//

import UIKit

class SelectRouteViewController: UIViewController {
    
    var recorrido: Recorrido?
    @IBOutlet weak var VelocidadPromedio: UILabel!
    @IBOutlet weak var VelocidadMaxima: UILabel!
    @IBOutlet weak var TemperaturaLabel: UILabel!
    @IBOutlet weak var CaloriasLabel: UILabel!
    @IBOutlet weak var DistanciaLabel: UILabel!
    @IBOutlet weak var TiempoLabel: UILabel!
    @IBOutlet weak var FechaLabel: UILabel!
    @IBOutlet weak var BicicletaNombreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let r = recorrido {
                BicicletaNombreLabel.text = r.bicicletaNombre
                CaloriasLabel.text = "Calorias: \(r.calorias) cal"
                TiempoLabel.text = "Duracion del Recorrido: \(r.tiempo)"
                TemperaturaLabel.text="Temperatura: \(r.temperatura)°C"
                VelocidadPromedio.text = "Velocidad Promedio: \(r.velocidadPromedio) m/s"
                VelocidadMaxima.text = "Velocidad Maxima: \(r.velocidadMaxima) m/s"
                DistanciaLabel.text = "Distancia Recorrida: \(r.distanciaRecorrida) m"
                FechaLabel.text = r.createdAt
            }

        // Do any additional setup after loading the view.
    }
    func convertirSegundosATiempo(_ segundos: Int) -> String {
        let horas = segundos / 3600
        let minutos = (segundos % 3600) / 60
        let segundosRestantes = segundos % 60
        return String(format: "%02d:%02d:%02d", horas, minutos, segundosRestantes)
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
