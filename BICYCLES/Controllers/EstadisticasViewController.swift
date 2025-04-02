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
        chart.leftAxis.enabled = false
        chart.legend.enabled = true

        chart.drawValueAboveBarEnabled = true
        
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Estadisticas vc charged")

        vwContenedorGrafica.addSubview(graficaBarras)
        
        graficaBarras.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
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
        let valores: [Double] = [50, 104, 81, 93, 52, 100, 500]
        var entradasDeDatos: [BarChartDataEntry] = []
        

        for (indice, valor) in valores.enumerated() {
            let entrada = BarChartDataEntry(x: Double(indice), y: valor)
            entradasDeDatos.append(entrada)
        }
        
        let conjuntoDeDatos = BarChartDataSet(entries: entradasDeDatos, label: "Distancias")
        
        conjuntoDeDatos.colors = [UIColor.blue]
        
        conjuntoDeDatos.valueFont = UIFont.systemFont(ofSize: 16)
        conjuntoDeDatos.valueTextColor = .black
        
        let datos = BarChartData(dataSet: conjuntoDeDatos)
        graficaBarras.data = datos
        
        if let maximoY = valores.max() {
            graficaBarras.leftAxis.axisMaximum = maximoY + 10
            graficaBarras.leftAxis.axisMinimum = 0
        }
        
        graficaBarras.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"])
        graficaBarras.xAxis.granularity = 1
        graficaBarras.xAxis.labelPosition = .bottom
        graficaBarras.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        graficaBarras.leftAxis.enabled = false
        graficaBarras.leftAxis.drawAxisLineEnabled = false
        graficaBarras.leftAxis.drawGridLinesEnabled = false
        
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
