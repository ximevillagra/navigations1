import Foundation
import UIKit
import Alamofire

class TopTenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var mejoresPuntajes: [EntradaHistorial] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top 10 Usuarios"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cargarMejoresPuntajes()
    }
    
    @objc func cerrarModal() {
        dismiss(animated: true)
    }
    
    func cargarMejoresPuntajes() {
        guard let jwtToken = SessionManager.shared.accessToken else {
            print("No hay token disponible")
            let alert = UIAlertController(
                title: "Error",
                message: "No hay token disponible. Debes iniciar sesión.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        HTTPClient.shared.fetchScores(jwtToken: jwtToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let scores):
                    var mejorPorUsuario: [String: EntradaHistorial] = [:]
                    
                    for score in scores {
                        let userId = score.userId
                        guard !userId.isEmpty else { continue }
                        
                        if mejorPorUsuario[userId] == nil || score.score > mejorPorUsuario[userId]!.score {
                            mejorPorUsuario[userId] = score
                        }
                    }
                    
                    self?.mejoresPuntajes = Array(mejorPorUsuario.values)
                        .sorted(by: { $0.score > $1.score })
                        .prefix(10)
                        .map({ $0 })
                    
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print("Error al cargar mejores puntajes: \(error)")
                    
                    let alert = UIAlertController(
                        title: "Error",
                        message: "No se pudieron cargar los puntajes. Intenta de nuevo.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }


    // MARK: - Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mejoresPuntajes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TopTenCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
                   UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)

        let entrada = mejoresPuntajes[indexPath.row]
        let puntaje = entrada.score
        let posicion = indexPath.row + 1

        cell.textLabel?.text = "\(posicion)"
        cell.detailTextLabel?.text = "\(puntaje) pts"

    
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top 10 mejores puntajes"
    }
}
