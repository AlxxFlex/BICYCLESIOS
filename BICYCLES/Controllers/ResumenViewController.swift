//
//  ResumenViewController.swift
//  BICYCLES
//
//  Created by mac on 02/04/25.
//

import UIKit

class ResumenViewController: UIViewController {

    @IBOutlet weak var lblTotalRecorridos: UILabel!
    @IBOutlet weak var lblDuracion: UILabel!
    @IBOutlet weak var lblCalorias: UILabel!
    @IBOutlet weak var lblDistancia: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        if let url = URL(string: "http://192.168.252.212:8000/api/v1/resumen/usuario") {
            guard let token = SessionManager.shared.getToken() else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
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

                            DispatchQueue.main.async {
                                self.lblCalorias.text = "\(jsonResponse["calorias"] ?? "0")"
                                self.lblTotalRecorridos.text = "\(jsonResponse["recorridos"] ?? "0")"
                                self.lblDistancia.text = "\(jsonResponse["distancia"] ?? "0")"
                                self.lblDuracion.text = "\(jsonResponse["duracion"] ?? "0")"
                            }
                            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
