//
//  BicyclesViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 27/02/25.
//

import UIKit


class BicyclesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewBicicletaDelegate {

    @IBOutlet weak var tableView: UITableView!
    var bicicletas: [Bicicleta] = []
       
    override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(BicicletaCell.self, forCellReuseIdentifier: "CellIdentifier")
    obtenerBicicletas()
}

// MARK: - Obtener Bicicletas desde API
func obtenerBicicletas() {
    ApiService.shared.obtenerBicicletas { [weak self] result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                print("🚲 Datos obtenidos: \(data.count) bicicletas")
                self?.bicicletas = Array(
                    Dictionary(uniqueKeysWithValues: data.map { ($0.id, $0) })
                    .values
                ).sorted { $0.id < $1.id }
                
                self?.tableView.reloadData()
            case .failure(let error):
                print("❌ Error al obtener bicicletas: \(error.localizedDescription)")
            }
        }
    }
}
        
   
   // MARK: - Abrir pantalla para agregar bicicleta (programáticamente)
    @IBAction func agregarBicicletaTapped(_ sender: UIButton) {
        if let newBiciVC = storyboard?.instantiateViewController(withIdentifier: "NewBicicletaViewController") as? NewBicicletaViewController {
            if #available(iOS 15.0, *) {
                if let sheet = newBiciVC.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.prefersGrabberVisible = true
                    sheet.prefersEdgeAttachedInCompactHeight = true
                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                }
            } else {
                newBiciVC.modalPresentationStyle = .pageSheet
            }
            
            newBiciVC.delegate = self
            present(newBiciVC, animated: true, completion: nil)
        }
    }
       
       // MARK: - Actualizar tabla después de agregar bicicleta
       func didAddBicicleta() {
           obtenerBicicletas()
       }
       
       // MARK: - Métodos UITableView
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return bicicletas.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as? BicicletaCell else {
               return UITableViewCell()
           }
           
           let bicicleta = bicicletas[indexPath.row]
           cell.configure(with: bicicleta, target: self, editAction: #selector(editarBicicleta(_:)), deleteAction: #selector(eliminarBicicleta(_:)), index: indexPath.row)
           
           return cell
       }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 150
       }
       
       // MARK: - Método para editar bicicleta
       @objc func editarBicicleta(_ sender: UIButton) {
           let bicicleta = bicicletas[sender.tag]
           print("📝 Editar bicicleta: \(bicicleta.nombre) con ID \(bicicleta.id)")
       }
       // MARK: - Método para eliminar bicicleta
       @objc func eliminarBicicleta(_ sender: UIButton) {
           bicicletas.remove(at: sender.tag)
           tableView.reloadData()
       }
   }
