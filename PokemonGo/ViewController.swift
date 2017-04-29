//
//  ViewController.swift
//  PokemonGo
//
//  Created by alex on 4/24/17.
//  Copyright © 2017 Alexander Cayetano Yaya. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {

    
    @IBOutlet var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    let mapDistance : CLLocationDistance = 300
    
    let captureDistance : CLLocationDistance = 1500
    
    var pokemonSpwanTimer:TimeInterval = 5
    
    var pokemons : [Pokemon] = []
    
    var hasStartedTheMap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        
        //createAllThePokemons()
        
        pokemons = getAllThePokemons()
        
        //createAndCaughtPokemon(name: "Weedle", with: "weedle")
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setupMap()
        }else {
            self.manager.requestWhenInUseAuthorization() //Pide solo cuando la app esta en uso
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Core Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 4 {
            
            if let coordinate = self.manager.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, mapDistance, mapDistance)
                self.mapView.setRegion(region, animated: true)
                 updateCount += 1
            }
           
        } else {
            self.manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
           setupMap()
        }
    }
    
    
    func setupMap(){
        
        if !self.hasStartedTheMap {
            
            self.hasStartedTheMap = true
        
            print("Estamos listos para salir a cazar Pokemons")
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
            self.manager.stopUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: pokemonSpwanTimer, repeats: true, block: { (timer) in
                //hay que generar un neuvo prokemon
                print("generando un nuevo pokemon")
                
                if let coordinate = self.manager.location?.coordinate {
                    /* let annotation = MKPointAnnotation()
                     annotation.coordinate = coordinate
                     annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500)/400000
                     annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500)/400000 */
                    
                    let randomPos = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                    let pokemon = self.pokemons[randomPos]
                    
                    let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemon)
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500)/400000
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500)/400000
                    self.mapView.addAnnotation(annotation)
                }
                
            })
            
        }

    }
    
    
    
   // MARK: Map View Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        }else {
            
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            annotationView.image = UIImage(named: pokemon.imageFileName!)
            
        }
        
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, captureDistance, captureDistance)
        self.mapView.setRegion(region, animated: false)
        
        
        if let coordinate = self.manager.location?.coordinate {
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coordinate)){
                print("Pokemons captura el pokemon")
                let vc = BattleViewController()
                vc.pokemon = (view.annotation! as! PokemonAnnotation).pokemon
                
                self.mapView.removeAnnotation(view.annotation!)
                
                self.present(vc, animated: true, completion: nil)
                
            } else {
                print("Demasiado lejos para cazar ese Pokemon")
                let pokemon = ((view.annotation) as! PokemonAnnotation).pokemon
                let alertController = UIAlertController(title: "Estas demasiado lejos", message: "Acercate a ese \(pokemon.name!)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
    
    
    
    @IBAction func updateUserLocation(_ sender: UIButton) {
        if let coordinate = self.manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, mapDistance, mapDistance)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

