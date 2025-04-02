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
    var generales:[String: [String: Double]] = [:]
    var datos:[String: [Double]] = [:]
    let graficaBarras: BarChartView = {
        let chart = BarChartView()

        chart.viewPortHandler.setMaximumScaleX(2.0) // Ajusta la escala X
        chart.viewPortHandler.setMaximumScaleY(2.0) // Ajusta la escala Y
        chart.chartDescription.enabled = false
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = false
        chart.legend.enabled = true

        chart.drawValueAboveBarEnabled = true
        chart.autoScaleMinMaxEnabled = true
        
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
            make.height.equalTo(300)
        }
        peticionApi()

        
    }
        
    @IBAction func cambioValorSegmented(_ sender: UISegmentedControl) {
        
        var seccion: String = ""
        switch sender.selectedSegmentIndex {
            case 0:
                seccion = "distancias"
            case 2:
            seccion = "duraciones"
        default:
            seccion = "calorias"
        }
        
        configurarDataGrafica(seccion)

    }
    
    func peticionApi() {

        if let url = URL(string: "http://192.168.252.212:8000/api/v1/semana/estadisticas") {
            guard let token = SessionManager.shared.getToken() else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                print("se mando la request")
                
                if let error = error {
                    print("Error en la solicitud: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No se recibieron datos.")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Datos recibidos: \(jsonResponse)")
                            self.generales = jsonResponse["generales"] as! [String: [String: Double]]
                            self.datos = jsonResponse["data"] as! [String: [Double]]
                            
                            self.configurarDataGrafica()
                            
                        } else {
                            print("Formato de respuesta no válido.")
                        }
                    } catch {
                        print("Error al procesar los datos: \(error.localizedDescription)")
                    }
                } else {
                    print("La respuesta no fue exitosa. Código de estado: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                }
            }.resume()
        } else {
            print("La URL no es válida")
        }

        
        
    }
    
    func configurarDataGrafica(_ seccion: String = "calorias"){
        
        DispatchQueue.main.async {
            self.lblMejor.text = String(self.generales[seccion]!["maxima"]!)
            self.lblTotal.text = String(self.generales[seccion]!["total"]!)
            self.lblPromedio.text = String(self.generales[seccion]!["promedio"]!)
        }
        
        
        let valores: [Double] = datos[seccion]!
        var entradasDeDatos: [BarChartDataEntry] = []
        

        for (indice, valor) in valores.enumerated() {
            let entrada = BarChartDataEntry(x: Double(indice), y: valor)
            entradasDeDatos.append(entrada)
        }
        
        let conjuntoDeDatos = BarChartDataSet(entries: entradasDeDatos, label: seccion)
        
        conjuntoDeDatos.colors = [UIColor.blue]
        
        conjuntoDeDatos.valueFont = UIFont.systemFont(ofSize: 16)
        conjuntoDeDatos.valueTextColor = .black
        
        let datos = BarChartData(dataSet: conjuntoDeDatos)
        graficaBarras.data = datos
        
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
