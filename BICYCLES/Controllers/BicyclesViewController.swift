//
//  BicyclesViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 27/02/25.
//

import UIKit


class BicyclesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewBicicletaDelegate , EditarBicicletaDelegate,EliminarBicicletaDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var bicicletasFiltradas: [Bicicleta] = []
    var buscando = false
    var datosCargados = false
    var bicicletas: [Bicicleta] = []
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BicicletaCell.self, forCellReuseIdentifier: "CellIdentifier")
        searchBar.delegate = self
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        obtenerBicicletas()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        obtenerBicicletas()
    }
    
    // MARK: - Obtener Bicicletas desde API
    func obtenerBicicletas() {
        datosCargados = false
        tableView.backgroundView = nil
        activityIndicator.startAnimating()
        
        ApiService.shared.obtenerBicicletas { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.datosCargados = true
                
                switch result {
                case .success(let data):
                    self.bicicletas = data
                    self.tableView.reloadData()
                    
                    if data.isEmpty {
                        self.mostrarMensajeVacio("No tienes bicicletas registradas")
                    } else {
                        self.tableView.backgroundView = nil
                    }

                case .failure(let error):
                    print("❌ \(error)")
                    self.mostrarAlarma(texto: "Error al obtener bicicletas")
                }
            }
        }
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
        
        // Usamos un contenedor dentro de un wrapper para asegurar el centrado real
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
           mostrarAlarma(texto: "Bicicleta agregada ✅")
           obtenerBicicletas()
       }
       
       // MARK: - Métodos UITableView
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if activityIndicator.isAnimating || !datosCargados {
                return 0
            }
            return buscando ? bicicletasFiltradas.count : bicicletas.count
        }
           
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as? BicicletaCell else {
               return UITableViewCell()
           }
           
           let bicicleta = buscando ? bicicletasFiltradas[indexPath.row] : bicicletas[indexPath.row]
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
            performSegue(withIdentifier: "sgeditbici", sender: bicicleta)
        }

        // MARK: - Preparar para el segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "sgeditbici" {
                if let editVC = segue.destination as? EditarBicicletaViewController,
                   let bicicleta = sender as? Bicicleta {
                    editVC.bicicleta = bicicleta
                    editVC.delegate = self
                }
            }
        }

        
        func didEditBicicleta() {
            mostrarAlarma(texto: "Bicicleta actualizada ✅")
            obtenerBicicletas()
        }
    // MARK: - Método para eliminar bicicleta
    @objc func eliminarBicicleta(_ sender: UIButton) {
        let bicicleta = bicicletas[sender.tag]
           print("🗑️ Eliminar bicicleta: \(bicicleta.nombre) con ID \(bicicleta.id)")
           
           
           let eliminarVC = EliminarBicicletaViewController()
           eliminarVC.bicicleta = bicicleta
           eliminarVC.delegate = self
           
           
           if #available(iOS 15.0, *) {
               if let sheet = eliminarVC.sheetPresentationController {
                   sheet.detents = [.medium()]
                   sheet.prefersGrabberVisible = true
               }
           } else {
               eliminarVC.modalPresentationStyle = .pageSheet
           }
           
           present(eliminarVC, animated: true, completion: nil)
    }

    // MARK: - Recargar tabla después de eliminar bicicleta
    func didDeleteBicicleta() {
        mostrarAlarma(texto: "Bicicleta eliminada 🗑️")
        obtenerBicicletas()
    }
   }
// MARK: - Extensión UISearchBarDelegate
extension BicyclesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            buscando = false
        } else {
            bicicletasFiltradas = bicicletas.filter { bicicleta in
                return bicicleta.nombre.lowercased().contains(searchText.lowercased())
            }
            buscando = true
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        buscando = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
