//
//  SelectBicycleViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 01/04/25.
//

import UIKit

class SelectBicycleViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var bicicletas: [Bicicleta] = []
    var bicicletasFiltradas: [Bicicleta] = []
    var recorridoIdActual: String?
    var onRecorridoCreado: ((String) -> Void)? // Callback para enviar el recorrido_id
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        SearchBar.delegate = self
        
        TableView.register(SelectBicycleCell.self, forCellReuseIdentifier: SelectBicycleCell.identifier)
        TableView.rowHeight = 150
        TableView.backgroundColor = .clear
        view.backgroundColor = UIColor(red: 0.80, green: 0.90, blue: 1.0, alpha: 1.0)
        
        obtenerBicicletas()
    }
    
    func obtenerBicicletas() {
        ApiService.shared.obtenerBicicletas { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bicis):
                    self.bicicletas = bicis
                    self.bicicletasFiltradas = bicis
                    self.TableView.reloadData()
                case .failure(let error):
                    print("❌ Error al obtener bicicletas: \(error.localizedDescription)")
                }
            }
        }
    }
    func mostrarAlertaError() {
        let alerta = UILabel()
        alerta.text = "  Error al crear recorrido  "
        alerta.textAlignment = .center
        alerta.font = UIFont(name: "Chalkboard SE", size: 16)
        alerta.textColor = .white
        alerta.backgroundColor = UIColor.systemRed
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
}
extension SelectBicycleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bicicletasFiltradas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectBicycleCell.identifier, for: indexPath) as? SelectBicycleCell else {
            return UITableViewCell()
        }
        let bici = bicicletasFiltradas[indexPath.row]
        cell.configurarCon(bicicleta: bici)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let biciSeleccionada = bicicletasFiltradas[indexPath.row]
        
        ApiService.shared.crearRecorrido(bicicletaId: biciSeleccionada.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recorridoId):
                    print("✅ Recorrido creado con ID: \(recorridoId)")
                    self.recorridoIdActual = recorridoId
                    self.irACurrentRoute()
                case .failure(let error):
                    print("❌ Error al crear recorrido: \(error.localizedDescription)")
                    self.mostrarAlertaError()
                }
            }
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
        
    func irACurrentRoute() {
        guard let currentRouteVC = storyboard?.instantiateViewController(withIdentifier: "CurrentRouteViewController") as? CurrentRouteViewController else {
            return
        }
        currentRouteVC.recorridoId = self.recorridoIdActual
        currentRouteVC.mostrarAlertaInicio = true
        currentRouteVC.modalPresentationStyle = .fullScreen
        self.present(currentRouteVC, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true) // Oculta el teclado al tocar fuera
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Oculta el teclado
        return true
    }
}

extension SelectBicycleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        bicicletasFiltradas = searchText.isEmpty ?
            bicicletas :
            bicicletas.filter { $0.nombre.lowercased().contains(searchText.lowercased()) }
        TableView.reloadData()
    }
}
