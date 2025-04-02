//
//  RegisterStep2ViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 16/03/25.
//

import UIKit

class RegisterStep2ViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var pesoTF: UITextField!
    @IBOutlet weak var estaturaTF: UITextField!
    
    var registerData = RegisterData()
    
    var pesoErrorLabel: UILabel!
    var estaturaErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorLabels()
        pesoTF.delegate = self
        estaturaTF.delegate = self
        
        
           
           
           let backButton = UIButton(type: .system)
           
           
           let image = UIImage(systemName: "arrowshape.left.fill")
           backButton.setImage(image, for: .normal)
           let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
           backButton.setImage(UIImage(systemName: "arrowshape.left.fill", withConfiguration: config), for: .normal)
           backButton.tintColor = .white
           backButton.backgroundColor = .lightGray
           backButton.frame = CGRect(x: 0, y: 0, width: 45, height: 50)
           backButton.layer.cornerRadius = 22
           backButton.clipsToBounds = true
           backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
           
           navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
       }

       @objc func customBackAction() {
           navigationController?.popViewController(animated: true)
       }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
       pesoErrorLabel.isHidden = true
       estaturaErrorLabel.isHidden = true
       var isValid = true
       guard let pesoText = pesoTF.text, !pesoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let peso = Float(pesoText) else {
           pesoErrorLabel.text = "El campo peso es obligatorio."
           pesoErrorLabel.isHidden = false
           isValid = false
           return
       }
       
       if peso < 20 {
           pesoErrorLabel.text = "El peso debe ser mayor a 20 kg"
           pesoErrorLabel.isHidden = false
           isValid = false
       } else if peso > 150 {
           pesoErrorLabel.text = "No puedes superar los 160 kg"
           pesoErrorLabel.isHidden = false
           isValid = false
       }
       guard let estaturaText = estaturaTF.text, !estaturaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let estatura = Float(estaturaText) else {
           estaturaErrorLabel.text = "El campo estatura es obligatorio."
           estaturaErrorLabel.isHidden = false
           isValid = false
           return
       }
        if estatura < 1.10 {
           estaturaErrorLabel.text = "La estatura debe ser mayor a 1 metro."
           estaturaErrorLabel.isHidden = false
           isValid = false
       } else if estatura > 2.20 {
           estaturaErrorLabel.text = "La estatura no puede superar los 3 metros."
           estaturaErrorLabel.isHidden = false
           isValid = false
       }
       if isValid {
           registerData.peso = peso
           registerData.estatura = estatura
           performSegue(withIdentifier: "toRegisterStep3", sender: self)
       }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toRegisterStep3" {
           if let step3VC = segue.destination as? RegisterStep3ViewController {
               step3VC.registerData = self.registerData
           }
       }
   }
    func setupErrorLabels() {
            pesoErrorLabel = UILabel()
            pesoErrorLabel.translatesAutoresizingMaskIntoConstraints = false
            pesoErrorLabel.textColor = .red
            pesoErrorLabel.font = UIFont.systemFont(ofSize: 12)
            pesoErrorLabel.text = "El campo peso es obligatorio." // Texto inicial; se actualizará según validación.
            pesoErrorLabel.isHidden = true
            
            estaturaErrorLabel = UILabel()
            estaturaErrorLabel.translatesAutoresizingMaskIntoConstraints = false
            estaturaErrorLabel.textColor = .red
            estaturaErrorLabel.font = UIFont.systemFont(ofSize: 12)
            estaturaErrorLabel.text = "El campo estatura es obligatorio."
            estaturaErrorLabel.isHidden = true
            
            view.addSubview(pesoErrorLabel)
            view.addSubview(estaturaErrorLabel)
            
            NSLayoutConstraint.activate([
                pesoErrorLabel.topAnchor.constraint(equalTo: pesoTF.bottomAnchor, constant: 4),
                pesoErrorLabel.leadingAnchor.constraint(equalTo: pesoTF.leadingAnchor),
                pesoErrorLabel.trailingAnchor.constraint(equalTo: pesoTF.trailingAnchor)
            ])
            
            NSLayoutConstraint.activate([
                estaturaErrorLabel.topAnchor.constraint(equalTo: estaturaTF.bottomAnchor, constant: 4),
                estaturaErrorLabel.leadingAnchor.constraint(equalTo: estaturaTF.leadingAnchor),
                estaturaErrorLabel.trailingAnchor.constraint(equalTo: estaturaTF.trailingAnchor)
            ])
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // Oculta el teclado al tocar fuera
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Oculta el teclado
        return true
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
