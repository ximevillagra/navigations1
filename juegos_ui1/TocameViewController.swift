import Foundation
import UIKit
import Alamofire

class TocameViewController: UIViewController {
    
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var etiTimer: UILabel!
    @IBOutlet weak var etiScore: UILabel!
    @IBOutlet weak var viewCaja: UIView!
    @IBOutlet weak var player: UILabel!
    
    var countdownTimer: Timer?
    var restante = 60
    var contador = 0
    var circle: UIView!
    var nombre: String? // userId
    var score = 0
    
    var historial: [EntradaHistorial] = []
    
    var userId: String {
        SessionManager.shared.userId ?? "uuid-usuario"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombre = SessionManager.shared.nombreUser
        player.text = nombre ?? "Jugador"
        
        setup()
        self.navigationController?.navigationBar.tintColor = .purple
    }
    
    func setup() {
        let circleSize: CGFloat = 50
        circle = UIView(frame: CGRect(x: 200, y: 200, width: circleSize, height: circleSize))
        circle.backgroundColor = .systemPurple
        circle.layer.cornerRadius = circleSize / 2
        circle.clipsToBounds = true
        
        viewCaja.addSubview(circle)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toque))
        circle.addGestureRecognizer(tap)
        
        circle.isUserInteractionEnabled = false
        viewCaja.isUserInteractionEnabled = true
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.restante > 0 {
                self.restante -= 1
                self.etiTimer.text = "\(self.restante)"
            } else {
                self.countdownTimer?.invalidate()
                self.circle.isUserInteractionEnabled = false
                self.guardarPuntajeYMostrarAlerta()
            }
        }
    }
    
    @objc func toque() {
        guard restante > 0 else { return }
        
        let circleSize = circle.frame.size
        let maxX = viewCaja.bounds.width - circleSize.width
        let maxY = viewCaja.bounds.height - circleSize.height
        
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        
        UIView.animate(withDuration: 0.3) {
            self.circle.frame.origin = CGPoint(x: randomX, y: randomY)
        }
        
        contador += 1
        etiScore.text = "\(contador)"
        score = contador
    }
    
    func reiniciarJuego() {
        countdownTimer?.invalidate()
        
        contador = 0
        restante = 60
        etiScore.text = "0"
        etiTimer.text = "\(restante)"
        
        circle.isUserInteractionEnabled = true
        
        let circleSize = circle.frame.size
        let maxX = viewCaja.bounds.width - circleSize.width
        let maxY = viewCaja.bounds.height - circleSize.height
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        circle.frame.origin = CGPoint(x: randomX, y: randomY)
        
        startTimer()
    }
    
    func guardarPuntajeYMostrarAlerta() {
        guard let jwtToken = SessionManager.shared.accessToken else {
            print("No hay token disponible")
            self.mostrarAlertaError()
            return
        }

        let userId = SessionManager.shared.userId ?? "uuid-usuario"
        let gameId = 1
        let score = contador
        let date = ISO8601DateFormatter().string(from: Date())

        HTTPClient.shared.guardarPuntaje(
            userId: userId,
            gameId: gameId,
            score: score,
            date: date,
            jwtToken: jwtToken
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.mostrarAlertaGameOver()
                case .failure(let error):
                    print("❌ Error al guardar puntaje: \(error)")
                    self.mostrarAlertaError()
                }
            }
        }
    }



    
    func mostrarAlertaGameOver() {
        guard let jwtToken = SessionManager.shared.accessToken else {
            print("❌ No hay token disponible")
            return
        }

        _ = nombre ?? "Anónimo"
        let userId = SessionManager.shared.userId ?? "uuid-usuario"
        let puntajeActual = contador

        HTTPClient.shared.fetchScores(jwtToken: jwtToken) { [weak self] result in
            DispatchQueue.main.async {
                let usuario = SessionManager.shared.nombreUser ?? "Usuario"
                var mensaje = """
                Jugador: \(usuario)
                Puntaje actual: \(puntajeActual)
                """

                switch result {
                case .success(let historialAPI):
                    let puntajesTocame = historialAPI.filter {
                        $0.gameId == 1 && $0.userId == userId
                    }

                    let ultimosPuntajes = puntajesTocame
                        .suffix(5)
                        .reversed()
                        .map { "\($0.score) pts" }
                        .joined(separator: ", ")

                    if !ultimosPuntajes.isEmpty {
                        mensaje += "\n\nÚltimos 5 puntajes:\n\(ultimosPuntajes)"
                    }

                case .failure(let error):
                    print("Error al obtener historial: \(error)")
                    mensaje += "\n\n(No se pudo cargar el historial)"
                }

                let alert = UIAlertController(title: "GAME OVER", message: mensaje, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Jugar de nuevo", style: .default) { _ in
                    self?.reiniciarJuego()
                })
                alert.addAction(UIAlertAction(title: "Ver mis puntajes", style: .default) { _ in
                    self?.mostrarTabla(self?.view as Any)
                })
                alert.addAction(UIAlertAction(title: "Salir", style: .cancel))

                self?.present(alert, animated: true)
            }
        }
    }

    
    func mostrarAlertaError() {
        let alert = UIAlertController(
            title: "Error",
            message: "No se pudo guardar el puntaje. Verifica conexion.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Reintentar", style: .default) { _ in
            self.guardarPuntajeYMostrarAlerta()
        })
        alert.addAction(UIAlertAction(title: "Continuar", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func mostrarTabla(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tableVC = storyboard.instantiateViewController(withIdentifier: "TableVC") as? TableViewController {
            tableVC.userId = SessionManager.shared.userId
            
            let navController = UINavigationController(rootViewController: tableVC)
            self.present(navController, animated: true)
        }
    }

    
    @IBAction func tocameBtn(_ sender: UIButton) {
        if sender.currentTitle == "Jugar" {
            sender.setTitle("Reiniciar", for: .normal)
            reiniciarJuego()
        } else {
            sender.setTitle("Jugar", for: .normal)
            reiniciarJuego()
        }
    }
    
}
