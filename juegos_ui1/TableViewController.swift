//
//  TableViewController.swift
//  poker_ios
//
//  Created by Bootcamp on 2025-05-29.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var mejoresPuntajes: [EntradaHistorial] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        cargarMejoresPuntajes()
    }
    
    struct EntradaHistorial: Codable {
        let nombre: String
        let puntaje: Int
    }
    
    
    func cargarMejoresPuntajes() {
        if let data = UserDefaults.standard.data(forKey: "historial"),
           let historial = try? JSONDecoder().decode([EntradaHistorial].self, from: data) {
            let mejores = historial.sorted(by: { $0.puntaje > $1.puntaje }).prefix(5)
            mejoresPuntajes = Array(mejores)
        }
    }
}
    
    
    // El extension sirve para agregar mas metodos a nuestras clases
    extension TableViewController {
        // Cantidad de puntajes guardados
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mejoresPuntajes.count
        }
        // Se llama cada vez que el tableView necesita una Celda para cada jugador, nombre y puntaje.
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Se define un identificador de celda.
            let cellIdentifier = "celdaConDetalle"
            // Actualiza la celda con el mejor puntaje
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            // Se crea una celda nueva si no hay ninguna disponible
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
            }
            // Se obtiene el mejor jugador
            let jugador = mejoresPuntajes[indexPath.row]
            // Se asignan los textos a los labels
            cell?.textLabel?.text = jugador.nombre
            cell?.detailTextLabel?.text = "\(jugador.puntaje) pts"
            return cell!
        }
        // Titulo de la tabla
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Mejores puntajes"
        }
    }
    

