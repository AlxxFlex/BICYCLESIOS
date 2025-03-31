//
//  RoutesViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 27/02/25.
//

import UIKit

class RoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var recorridos: [Recorrido] = []
    var recorridosFiltrados: [Recorrido] = []
    var buscando = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecorridoCell.self, forCellReuseIdentifier: "RecorridoCell")

        
        searchBar.delegate = self
        
        
        obtenerRecorridos()
    }

    // MARK: - Obtener Recorridos desde API
    func obtenerRecorridos() {
        ApiService.shared.obtenerRecorridos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("🚲 Recorridos obtenidos: \(data.count)")
                    self?.recorridos = data
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("❌ Error al obtener recorridos: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Métodos UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buscando ? recorridosFiltrados.count : recorridos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecorridoCell", for: indexPath) as? RecorridoCell else {
            return UITableViewCell()
        }

        let recorrido = buscando ? recorridosFiltrados[indexPath.row] : recorridos[indexPath.row]
        cell.configure(with: recorrido, target: self, deleteAction: #selector(eliminarRecorrido(_:)), index: indexPath.row)

        return cell
    }

    
    @objc func eliminarRecorrido(_ sender: UIButton) {
        let recorrido = recorridos[sender.tag]
        print("🗑️ Eliminando recorrido: \(recorrido.bicicletaNombre)")
        recorridos.remove(at: sender.tag)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

// MARK: - UISearchBarDelegate
extension RoutesViewController: UISearchBarDelegate {

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            buscando = false
        } else {
            recorridosFiltrados = recorridos.filter { recorrido in
                return recorrido.bicicletaNombre.lowercased().contains(searchText.lowercased())
            }
            buscando = true
        }
        tableView.reloadData()
    }


    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
