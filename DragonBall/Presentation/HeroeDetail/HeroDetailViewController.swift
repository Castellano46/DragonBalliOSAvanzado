//
//  HeroDetailViewController.swift
//  DragonBalliOSAvanzado
//
//  Created by Pedro on 21/10/23.
//

import UIKit
import MapKit
import Kingfisher

protocol HeroDetailViewControllerDelegate {
    var viewState: ((HeroDetailViewState) -> Void)? { get set }
    
    func onViewAppear()
}

enum HeroDetailViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero?, locations: HeroLocations)
}

class HeroDetailViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var heroDescription: UITextView!
    
    var viewModel: HeroDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initViews()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    //private func initViews() {
      //  mapView.delegate = self
        
  //  }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    break
                    
                case .update(let hero,
                             let locations):
                    self?.updateViews(hero: hero,
                                      heroLocations: locations)
                    
                }
            }
        }
    }
    
    private func updateViews(hero: Hero?, heroLocations: HeroLocations) {
        photo.kf.setImage(with: URL(string: hero?.photo ?? ""))
        makeRounded(image: photo)
        
        name.text = hero?.name
        heroDescription.text = hero?.description
        
        heroLocations.forEach {
            mapView.addAnnotation(
                HeroAnnotation(title: hero?.name,
                               info: hero?.id,
                               coordinate: .init(
                                latitude: Double($0.latitude ?? "") ?? 0.0,
                                longitude: Double($0.longitude ?? "") ?? 0.0)
                )
            )
        }
        
    }
    
    //Para hacer la imagen circular
    private func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
}

//extension HeroDetailViewController: MKMapViewDelegate {
    
//Funcion para cambiar la imagen de la chincheta del mapa
  //  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //    return nil
    //}
//}
