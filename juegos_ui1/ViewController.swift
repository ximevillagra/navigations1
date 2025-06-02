//
//  SecondViewController.swift
//  poker_ios
//
//  Created by Bootcamp on 2025-05-26.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var txtfldPick: UITextField!
    
    @IBOutlet weak var selectJuego: UIButton!
    
    
    let juegos = ["Poker", "Tocame", "Otro"]
    var juegoSeleccionado: String?
    
    var pickerView = UIPickerView()
    
    var nomUser: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtfldPick.inputView = pickerView
        txtfldPick.textAlignment = .center
        txtfldPick.clearButtonMode = .whileEditing
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Listo", style: .plain, target: self, action: #selector(pickerListo))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        txtfldPick.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    func navegar() {
        guard let juego = juegoSeleccionado else { return }
        
        if let nombre = nomUser {
            UserDefaults.standard.set(nombre, forKey: "usuarioActual")
        }

        switch juego {
        case "Poker":
            let pokerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! PokerViewController
            pokerVC.nombre1 = nomUser
            pokerVC.juegoSeleccionado = juego
            self.show(pokerVC, sender: nil)

        case "Tocame":
            let tocameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController") as! TocameViewController
            tocameVC.nombre = nomUser
            self.show(tocameVC, sender: nil)
            
        default:
            break
        }
    }
    
    @objc func pickerListo() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedJuego = juegos[selectedRow]
        txtfldPick.text = selectedJuego
        juegoSeleccionado = selectedJuego
        txtfldPick.resignFirstResponder()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        navegar()
        print("Intentando navegar a: \(txtfldPick.text ?? "ninguno")")
        
    }
    
    func verTopCinco() {
        //func para tabla con el top 5 del userrrrrr
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let UserTopVC = storyboard.instantiateViewController(withIdentifier: "UserTopVC") as? UserTopViewController {
            self.present(UserTopVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnTopUser(_ sender: Any) {
        verTopCinco()
    }
    
    func showHelp(message: String) {
        let alert = UIAlertController(title: juegoSeleccionado ?? "Juego", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func btnHelp(_ sender: Any) {
        if juegoSeleccionado == "Poker"{
            showHelp(message: "Te enfrentarás a la computadora. Se les serán repartidas 5 cartas a cada uno una vez le des click a 'Jugar', observa con qué jugadas ganas.")
        } else if juegoSeleccionado == "Tocame" {
            showHelp(message: "Verás en la pantalla un círculo de color morado. Tendrás 20 segundos, persigue al círculo clickeándolo y suma puntos.")
        } else {
            showHelp(message: "Utiliza la barra de opciones para elegir un juego.")
        }
    }
    
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return juegos.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return juegos[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtfldPick.text = juegos[row]
        juegoSeleccionado = juegos[row]
    }
}
