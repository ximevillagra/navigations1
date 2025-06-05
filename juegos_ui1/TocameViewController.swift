import UIKit

struct EntradaHistorial: Codable {
    let nombre: String
    let puntaje: Int
}

class TocameViewController: UIViewController {

    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var etiTimer: UILabel!
    @IBOutlet weak var etiScore: UILabel!
    @IBOutlet weak var viewCaja: UIView!
    @IBOutlet weak var player: UILabel!


    
    var countdownTimer: Timer?
    var restante = 30
    var contador = 0
    var circle: UIView!
    var nombre: String?
    var juegoSeleccionado: String?
    var score = 0
    
    var historial: [EntradaHistorial] = []

    
    override func viewDidLoad() {
        cargarDatosPrevios()
        player.text = nombre
        super.viewDidLoad()
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
                let entrada = EntradaHistorial(nombre: self.nombre ?? "Desconocido", puntaje: self.contador)
                self.historial.append(entrada)

                // Guardar historial completo
                if let encoded = try? JSONEncoder().encode(self.historial) {
                    UserDefaults.standard.set(encoded, forKey: "historial")
                }

                self.mostrarAlerta()
            }
        }
    }

    
    

    @objc func toque() {
        circle.isUserInteractionEnabled = true
        viewCaja.isUserInteractionEnabled = true
        guard restante > 0 else { return }

        let circleSize = circle.frame.size
        let maxX = viewCaja.bounds.width - circleSize.width
        let maxY = viewCaja.bounds.height - circleSize.height

        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)

        UIView.animate(withDuration: 0.4) {
            self.circle.frame.origin = CGPoint(x: randomX, y: randomY)
        }

        contador += 1
        etiScore.text = "\(contador)"
        score = score + contador
    }

    
    func reiniciarJuego() {
        countdownTimer?.invalidate()

        contador = 0
        restante = 30
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
    
    //alert con ultimos 5 puntajes
    func mostrarAlerta() {
        let ultimosPuntajes = historial.suffix(5).reversed().map { "\($0.nombre): \($0.puntaje)" }.joined(separator: "\n")

        if let nombreJugador = nombre {
            UserDefaults.standard.set(nombreJugador, forKey: "nombreJugador")
            UserDefaults.standard.set(score, forKey: "puntajeJugador")
        }

        print("Historial completo de puntajes:")
        for entrada in historial {
            print("\(entrada.nombre): \(entrada.puntaje)")
        }

        let mensaje = """
        Jugador: \(nombre ?? "Anonimo")
        Puntaje actual: \(contador)
        Últimos 5 puntajes:
        \(ultimosPuntajes)
        """

        let alert = UIAlertController(title: "Game Over", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alert, animated: true, completion: nil)
    }


    func cargarDatosPrevios() {
        if nombre == nil, let nombreGuardado = UserDefaults.standard.string(forKey: "nombreJugador") {
            nombre = nombreGuardado
        }


        let puntajeGuardado = UserDefaults.standard.integer(forKey: "puntajeJugador")
        score = puntajeGuardado
        if let data = UserDefaults.standard.data(forKey: "historial"),
           let decoded = try? JSONDecoder().decode([EntradaHistorial].self, from: data) {
            historial = decoded
        }

    }
    
    @IBAction func mostrarTabla(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tableVC = storyboard.instantiateViewController(withIdentifier: "TableVC") as? TableViewController {
            tableVC.nombreJugador = nombre
            self.present(tableVC, animated: true, completion: nil)
        }
    }


    

    @IBAction func tocameBtn(_ sender: UIButton) {
        sender.setTitle("Reintentar", for: .normal)
        reiniciarJuego()
    }
    
    func guardarYMostrarHistorial() {
        if let encoded = try? JSONEncoder().encode(historial) {
            UserDefaults.standard.set(encoded, forKey: "historial")
        }

        print("Historial completo de puntajes:")
        for entrada in historial {
            print("\(entrada.nombre): \(entrada.puntaje)")
        }
    }

}
