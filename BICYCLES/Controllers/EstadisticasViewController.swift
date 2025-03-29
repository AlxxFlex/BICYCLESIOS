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
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTextoTotal: UILabel!
    @IBOutlet weak var lblMejor: UILabel!
    @IBOutlet weak var lblPromedio: UILabel!
    @IBOutlet weak var vwContenedorGrafica: UIView!
    
    let graficaBarras: BarChartView = {
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

        vwContenedorGrafica.addSubview(graficaBarras)
        
        graficaBarras.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        configurarDatosGrafica()

        
    }
    
    @IBAction func cambioValorSegmented(_ sender: UISegmentedControl) {
        
        print(sender.selectedSegmentIndex)
        var seccion: String = ""
        switch sender.selectedSegmentIndex {
            case 0:
                seccion = "distancias"
            case 2:
            seccion = "duraciones"
        default:
            seccion = "calorias"
        }
        

    }
    
    func configurarDatosGrafica() {
        // Datos de ejemplo
        let valores: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 92]
        var entradasDeDatos: [BarChartDataEntry] = []
        
        // Crear las entradas de los datos
        for (indice, valor) in valores.enumerated() {
            let entrada = BarChartDataEntry(x: Double(indice), y: valor)
            entradasDeDatos.append(entrada)
        }
        
        let conjuntoDeDatos = BarChartDataSet(entries: entradasDeDatos, label: "Distancias")
        conjuntoDeDatos.colors = ChartColorTemplates.material()
        

        let datos = BarChartData(dataSet: conjuntoDeDatos)
        graficaBarras.data = datos
        

        if let maximoY = valores.max() {
            graficaBarras.leftAxis.axisMaximum = maximoY + 10
            graficaBarras.leftAxis.axisMinimum = 0
        }
        
        //eje x
        graficaBarras.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"])
        
        graficaBarras.xAxis.granularity = 1
        graficaBarras.xAxis.labelPosition = .bottom
        graficaBarras.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        graficaBarras.notifyDataSetChanged()
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
