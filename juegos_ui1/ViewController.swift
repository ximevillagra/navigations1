//
//  HomeViewController.swift
//  poker_ios
//
//  Created by Bootcamp on 2025-05-26.
//

import Foundation
import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var selectJuego: UIButton!
    @IBOutlet weak var scrollViewSlider: UIScrollView!
    @IBOutlet weak var pageControlSlider: UIPageControl!
        
    let juegos = ["Poker", "Tocame"]
    var juegoSeleccionado: String?
    var nomUser: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewSlider.delegate = self
        scrollViewSlider.isPagingEnabled = true
        scrollViewSlider.isScrollEnabled = true
        self.navigationController?.navigationBar.tintColor = .purple

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSlider()
    }

    func setupSlider() {
        let images = ["pokir", "ball"]
        print("ScrollView width:", scrollViewSlider.frame.width)

        scrollViewSlider.subviews.forEach { $0.removeFromSuperview() }

        let scrollWidth = scrollViewSlider.frame.width
        let scrollHeight = scrollViewSlider.frame.height

        for (index, imageName) in images.enumerated() {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true

            imageView.frame = CGRect(x: CGFloat(index) * scrollWidth,
                                     y: 0,
                                     width: scrollWidth,
                                     height: scrollHeight)
            scrollViewSlider.addSubview(imageView)
        }

        scrollViewSlider.contentSize = CGSize(width: scrollWidth * CGFloat(images.count), height: scrollHeight)
        pageControlSlider.numberOfPages = images.count
    }

    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let offset = CGFloat(page) * scrollViewSlider.frame.size.width
        scrollViewSlider.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }

    @IBAction func buttonAction(_ sender: Any) {
        navegar()
        print("Intentando navegar a: \(juegoSeleccionado ?? "ninguno")")
    }

    func navegar() {
        guard let juego = juegoSeleccionado else { return }
            
        if nomUser == nil {
            nomUser = SessionManager.shared.nombreUser
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

    @IBAction func btnTopUser(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let UserTopVC = storyboard.instantiateViewController(withIdentifier: "UserTopVC") as? UserTopViewController {
            self.present(UserTopVC, animated: true, completion: nil)
        }
    }

    @IBAction func btnHelp(_ sender: Any) {
        if juegoSeleccionado == "Poker" {
            showHelp(message: "Te enfrentarás a la computadora. Se les serán repartidas 5 cartas a cada uno una vez le des click a 'Jugar', observa con qué jugadas ganas.")
        } else if juegoSeleccionado == "Tocame" {
            showHelp(message: "Verás en la pantalla un círculo de color morado. Tendrás 20 segundos, persigue al círculo clickeándolo y suma puntos.")
        } else {
            showHelp(message: "Utiliza la barra de opciones para elegir un juego.")
        }
    }

    func showHelp(message: String) {
        let alert = UIAlertController(title: juegoSeleccionado ?? "Juego", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @IBAction func btnAtras(_ sender: Any) {
        if pageControlSlider.currentPage > 0 {
               pageControlSlider.currentPage -= 1
               let offset = CGFloat(pageControlSlider.currentPage) * scrollViewSlider.frame.size.width
               scrollViewSlider.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
           }
    }
    
    @IBAction func btnAdelant(_ sender: Any) {
        if pageControlSlider.currentPage < pageControlSlider.numberOfPages - 1 {
                pageControlSlider.currentPage += 1
                let offset = CGFloat(pageControlSlider.currentPage) * scrollViewSlider.frame.size.width
                scrollViewSlider.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControlSlider.currentPage = pageIndex
        if pageIndex < juegos.count {
            juegoSeleccionado = juegos[pageIndex]
            print("Juego seleccionado: \(juegoSeleccionado ?? "ninguno")")
        }
    }
    
    
}
