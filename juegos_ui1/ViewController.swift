//
//  SecondViewController.swift
//  poker_ios
//
//  Created by Bootcamp on 2025-05-26.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var txtfldPick: UITextField!
    @IBOutlet weak var user2: UITextField!
    
    
    @IBOutlet weak var selectJuego: UIButton!
    
    
    let juegos = ["Poker", "Tocame", "Generala"]
    var juegoSeleccionado: String?
    
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtfldPick.inputView = pickerView
        txtfldPick.textAlignment = .center
        txtfldPick.clearButtonMode = .whileEditing
        
        user2.clearButtonMode = .whileEditing
        user2.isHidden = true
        
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
        guard let juego = txtfldPick.text, !juego.isEmpty else { return }
        
        if txtfldPick.text == "Poker" {
            guard let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? PokerViewController else {
                return
            }
            user2.isHidden = false
            secondVC.nombre2 = user2.text
            secondVC.juegoSeleccionado = juego
            present(secondVC, animated: true, completion: nil)
        } else if txtfldPick.text == "Tocame" {
            guard let thirdVC = storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as? TocameViewController else {
                return
            }
            user2.isHidden = true
            thirdVC.juegoSeleccionado = juego
            present(thirdVC, animated: true, completion: nil)
        }
    }
    
    @objc func pickerListo() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedJuego = juegos[selectedRow]
        txtfldPick.text = selectedJuego
        juegoSeleccionado = selectedJuego
        txtfldPick.resignFirstResponder()
        
        if selectedJuego == "Tocame" {
            user2.isHidden = true
            UIView.animate(withDuration: 0.3) {
//                self.selectJuego.frame.origin.y -= 100
            }
        } else {
            user2.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.selectJuego.frame.origin.y += 100
            }
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
//           txtfldPick.resignFirstResponder()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        navegar()
        print("Intentando navegar a: \(txtfldPick.text ?? "ninguno")")

    }
    
}
