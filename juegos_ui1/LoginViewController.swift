//
//  LoginViewController.swift
//  juegos_ui1
//
//  Created by Bootcamp on 2025-05-30.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var user1: UITextField!
    @IBOutlet weak var passLogin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func home() {
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as! HomeViewController
                
        self.show(firstVC, sender: nil)
    }
    
    
    func registro() {
        guard let regisVC = storyboard?.instantiateViewController(withIdentifier: "registerVC") as? RegisterViewController else {
            return
        }
        present(regisVC, animated: true, completion: nil)
    }

    
    @IBAction func btnLogin(_ sender: UIButton) {
        guard let username = user1.text, !username.isEmpty,
              let password = passLogin.text, !password.isEmpty else {
            showAlert(message: "Completa todos los campos.")
            return
        }
        // Aquí podrías agregar lógica de autenticación
        home()
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        registro()
    }
}

