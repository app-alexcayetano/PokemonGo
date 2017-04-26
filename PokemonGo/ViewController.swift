//
//  ViewController.swift
//  PokemonGo
//
//  Created by alex on 4/24/17.
//  Copyright © 2017 Alexander Cayetano Yaya. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    let mapDistance : CLLocationDistance = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Estamos listos para salir a cazar Pokemons")
            self.mapView.showsUserLocation = true
            self.manager.stopUpdatingLocation()
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
    
    @IBAction func updateUserLocation(_ sender: UIButton) {
        if let coordinate = self.manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, mapDistance, mapDistance)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    

}

