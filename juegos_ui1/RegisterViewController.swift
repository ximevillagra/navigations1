//
//  registerViewController.swift
//  juegos_ui1
//
//  Created by Bootcamp on 2025-05-29.
//

import UIKit
import Alamofire
//para guardar registros
struct Usuario: Codable {
    let nombre: String
    let email: String
    let password: String
}


class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var regUsername: UITextField!
    @IBOutlet weak var regEmail: UITextField!
    @IBOutlet weak var regPass: UITextField!
    @IBOutlet weak var confPass: UITextField!
    
    var contrasenas: [ingresaPass] = []
    
    struct ingresaPass: Codable {
        let password: String
    }
    
    private func registrarUsuarioSupabase(email: String, password: String, nombre: String) {
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"
        let url = "https://lvmybcyhrbisfjouhbrx.supabase.co/auth/v1/signup"
        
        let headers: HTTPHeaders = [
            "apikey": apiKey,
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let params: [String: Any] = [
            "email": email,
            "password": password,
            "data": [
                "username": nombre
            ]
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any], json["error"] == nil {
                        DispatchQueue.main.async {
                            self.alertaLogin(titulo: "¡Registro exitoso!", mensaje: "Te registraste correctamente.")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.mostrarAlerta(titulo: "Error en el registro", mensaje: "\(value)")
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.mostrarAlerta(titulo: "Error", mensaje: error.localizedDescription)
                    }
                }
            }
    }

    
    func insertaNombre(id: String, nombre: String, email: String, apiKey: String) {
        let url = URL(string: "https://lvmybcyhrbisfjouhbrx.supabase.co/rest/v1/usuarios")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let body: [String: Any] = [
            "id": id,
            "nombre": nombre,
            "email": email
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al guardar nombre en Supabase: \(error.localizedDescription)")
            } else {
                print("Nombre guardado correctamente en Supabase.")
            }
        }.resume()
    }
    
    func registrar() {
        guard let nombre = regUsername.text, !nombre.isEmpty,
              let email = regEmail.text, !email.isEmpty,
              let pass = regPass.text, !pass.isEmpty,
              let confirmPass = confPass.text, !confirmPass.isEmpty else {
            mostrarAlerta(titulo: "Campos vacíos", mensaje: "Completa todos los campos.")
            return
        }

        guard pass == confirmPass else {
            mostrarAlerta(titulo: "Contraseñas no coinciden", mensaje: "Verifica que ambas contraseñas sean iguales.")
            return
        }
        registrarUsuarioSupabase(email: email, password: pass, nombre: nombre)
    }

    
    func mostrarAlerta(titulo: String, mensaje: String) {
         let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
         alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alerta, animated: true, completion: nil)
     }

    func alertaLogin(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ir a Inicio", style: .default) { _ in
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
                loginVC.modalPresentationStyle = .fullScreen
                self.show(loginVC, sender: nil)
            }
        }
        
        alerta.addAction(okAction)
        present(alerta, animated: true, completion: nil)
    }

    
    @IBAction func btnRegistrar(_ sender: Any) {
        registrar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regUsername.clearButtonMode = .whileEditing
        regEmail.clearButtonMode = .whileEditing
        regPass.clearButtonMode = .whileEditing
        confPass.clearButtonMode = .whileEditing
        self.navigationController?.navigationBar.tintColor = .purple
    }
}

