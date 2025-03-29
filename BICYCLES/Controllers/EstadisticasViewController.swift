//
//  EstadisticasViewController.swift
//  BICYCLES
//
//  Created by mac on 29/03/25.
//

import UIKit
import DGCharts
import SnapKit

class EstadisticasViewController: UIViewController {
    @IBOutlet weak var lblVelocidadTotal: UILabel!
    @IBOutlet weak var lblVelocidadMejor: UILabel!
    @IBOutlet weak var lblVelocidadPromedio: UILabel!
    @IBOutlet weak var vwVelocidadGraficaContenedor: UIView!
    
    @IBOutlet weak var lblCaloriasTotal: UILabel!
    @IBOutlet weak var lblCaloriasMejor: UILabel!
    @IBOutlet weak var lblCaloriasPromedio: UILabel!
    @IBOutlet weak var vwCaloriaGraficaContenedor: UIView!
    
    @IBOutlet weak var lblDuracionTotal: UILabel!
    @IBOutlet weak var lblDuracionMejor: UILabel!
    @IBOutlet weak var lblDuracionPromedio: UILabel!
    @IBOutlet weak var vwDuracionGraficaContenedor: UIView!
    
    
    
    
    let barChartView: BarChartView = {
        let chart = BarChartView()

        chart.chartDescription.enabled = false
        chart.rightAxis.enabled = false
        chart.leftAxis.axisMaximum = 0
        chart.legend.enabled = true
        
        return chart
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Estadisticas vc charged")
        // Do any additional setup after loading the view.

        view.addSubview(barChartView)
        
        barChartView.snp.makeConstraints { (make) in
            
        }
        
    }
    
    
    @IBAction func actualizarDataGrafica(_ sender: UISegmentedControl) {
        
        print(sender.selectedSegmentIndex)
        
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
