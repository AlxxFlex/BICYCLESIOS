//
//  RoutesViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 27/02/25.
//

import UIKit

class RoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var recorridos: [Recorrido] = []
    var recorridosFiltrados: [Recorrido] = []
    var buscando = false

    let activityIndicator = UIActivityIndicatorView(style: .large)
    var datosCargados = false
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecorridoCell.self, forCellReuseIdentifier: "RecorridoCell")

        
        
        searchBar.delegate = self
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        
        
        obtenerRecorridos()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        obtenerRecorridos()
    }

    // MARK: - Obtener Recorridos desde API
    func obtenerRecorridos() {
        datosCargados = false
        tableView.backgroundView = nil
        activityIndicator.startAnimating()

        ApiService.shared.obtenerRecorridos { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.datosCargados = true

                switch result {
                case .success(let data):
                    print("🚲 Recorridos obtenidos: \(data.count)")
                    self.recorridos = data
                    self.tableView.reloadData()

                    if data.isEmpty {
                        self.mostrarMensajeVacio("No tienes recorridos registrados.")
                    } else {
                        self.tableView.backgroundView = nil
                    }

                case .failure(let error):
                    print("❌ Error al obtener recorridos: \(error.localizedDescription)")
                    self.mostrarAlarma(texto: "Error al obtener recorridos.")
                }
            }
        }
    }

    // MARK: - Métodos UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityIndicator.isAnimating || !datosCargados {
            return 0
        }
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
        let recorrido = buscando ? recorridosFiltrados[sender.tag] : recorridos[sender.tag]
        print("🗑️ Eliminar recorrido: \(recorrido.createdAt)")

        // Crear instancia de EliminarRecorridoViewController
        let eliminarVC = EliminarRecorridoViewController()
        eliminarVC.recorrido = recorrido
        eliminarVC.delegate = self
        
        // Presentar como modal estilo sheet
        if #available(iOS 15.0, *) {
            if let sheet = eliminarVC.sheetPresentationController {
                sheet.detents = [.medium()] // ✅ Media pantalla
                sheet.prefersGrabberVisible = true // Mostrar barra para deslizar
            }
        } else {
            eliminarVC.modalPresentationStyle = .pageSheet
        }
        
        present(eliminarVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func mostrarMensajeVacio(_ mensaje: String) {
        let contenedor = UIView()
        contenedor.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = mensaje
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Chalkboard SE", size: 24)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false

        contenedor.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contenedor.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contenedor.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: contenedor.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contenedor.trailingAnchor, constant: -20)
        ])

        let wrapper = UIView(frame: tableView.bounds)
        wrapper.addSubview(contenedor)

        NSLayoutConstraint.activate([
            contenedor.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
            contenedor.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor)
        ])

        tableView.backgroundView = wrapper
        tableView.separatorStyle = .none
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true) // Oculta el teclado al tocar fuera
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Oculta el teclado
            return true
        }
}
extension RoutesViewController: EliminarRecorridoDelegate {
    func didDeleteRecorrido() {
        obtenerRecorridos()
    }
}
