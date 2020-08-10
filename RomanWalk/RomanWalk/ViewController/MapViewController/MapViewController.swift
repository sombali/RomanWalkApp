//
//  MapViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 24..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, Storyboarded {
    
    private var locationManager = LocationManager()
    private var location: CLLocation?
    private var organisation: Organisation?
    private var locations: [Location]?
    private var locationAnnotations: [MapAnnotation]?

    @IBOutlet weak var mapView: MKMapView!
    private let mapViewDelegate = MapViewControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = mapViewDelegate
        mapView.register(LocationMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let organisationDataSource = OrganisationDataSource()
        organisation = organisationDataSource.organisation.first
        
        let locationDataSource = LocationDataSource()
        locations = locationDataSource.locations
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.startLocationManager { [weak self] in
          if let location = self?.locationManager.lastLocation {
            self?.location = location
            if let userCoor = self?.mapView.userLocation.location?.coordinate{
                self!.mapView.setCenter(userCoor, animated: true)
            }

            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            self?.mapView.setRegion(viewRegion, animated: false)

          }
        }
        
        setupAnnotations()
        
        if let locationAnnotations = locationAnnotations {
            mapView.addAnnotations(locationAnnotations)
        }
        
        mapView.showsUserLocation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.stopLocationManager()
        
        mapView.annotations.forEach { annotation in
          self.mapView.removeAnnotation(annotation)
        }
    }
    
    private func setupAnnotations() {
        locationAnnotations = [MapAnnotation]()
        
        setupOrganisationAnnotation()
        setupLocationAnnotations()
    }
    
    private func setupOrganisationAnnotation() {
        if let organisation = organisation {
            let annotation = OrganisationAnnotation(organisation: organisation)

            locationAnnotations?.append(annotation)
        }
    }
    
    private func setupLocationAnnotations() {
        if let locations = locations {
            locations.forEach { (location) in
                let annotation = LocationAnnotation(location: location)

                self.locationAnnotations?.append(annotation)
            }
        }
    }
}
