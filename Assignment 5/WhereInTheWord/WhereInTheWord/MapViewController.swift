//
//  MapViewController.swift
//  WhereInTheWord
//
//  Created by sinze vivens on 2020/2/9.
//  Copyright © 2020 Luke. All rights reserved.
//

import UIKit
import MapKit

protocol PlacesFavoritesDelegate: class {
  func favoritePlace(name: String) -> Void
}

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var detailAnnotation: UIView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailFavButton: UIButton!
    @IBOutlet weak var detailDescription: UILabel!
    
    let locationManager = CLLocationManager()
    
    var placeList = [Place]()
    
    var placeFromData = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Request authorization and
        // set the view controller as the location manager's delegate

        locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.delegate = self
        
        let rioRegion = registerGeographicalRegion()
        locationManager.startMonitoring(for: rioRegion)
        print(locationManager.monitoredRegions)
        
        // Test your current state (calls `didDetermineState`)
       locationManager.requestState(for: rioRegion)
        
        // Set the view controller as the map view's delegate
        mapView.delegate = self
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsCompass = false
       
        
        // Track the user's location on the map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        DataManager.sharedInstance.loadAnnotationFromPlist()
        
        // Set the initial region on the map
        let zoomLocation = CLLocationCoordinate2DMake(DataManager.sharedInstance.region[0], DataManager.sharedInstance.region[1])
        let zoomSpan = MKCoordinateSpan(latitudeDelta: DataManager.sharedInstance.region[2], longitudeDelta: DataManager.sharedInstance.region[3])
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation, span: zoomSpan)
        mapView.setRegion(viewRegion, animated: true)
        
        loadPointsOfInterests()
        
        var rioRegions = [CLCircularRegion]()
        var i: Int = 0
        for item in DataManager.sharedInstance.places{
            let rioRegion = registerGeographicalRegion(lat: item.lat, long: item.long)
            rioRegions.append(rioRegion)
            locationManager.startMonitoring(for: rioRegion)
            i += 1
        }
        
        detailFavButton.tintColor = UIColor.yellow
        
        // intialize favorite button
        favButton.backgroundColor = UIColor.gray
        favButton.alpha = 0.9
        
        detailAnnotation.alpha = 0.87
        detailAnnotation.backgroundColor = UIColor.gray
        detailName.textColor = UIColor.white
        detailDescription.textColor = UIColor.white
        self.view.sendSubviewToBack(detailAnnotation)
        
        detailFavButton.addTarget(self, action: #selector(self.favButtonTapped(_:)), for: .touchUpInside)
        
    }
    
    
    func registerGeographicalRegion(lat:Double, long:Double) -> CLCircularRegion {
        let coordinate = CLLocationCoordinate2DMake(lat, long)
        let rioRegion = CLCircularRegion(center: coordinate, radius: 1000, identifier: "Rio")
        rioRegion.notifyOnEntry = true

        rioRegion.notifyOnExit = true
        return rioRegion
    }
    
    // default one
    func registerGeographicalRegion() -> CLCircularRegion {
        let coordinate = CLLocationCoordinate2DMake(41.948287,-87.655697)
        let rioRegion = CLCircularRegion(center: coordinate, radius: 1000, identifier: "Rio")
        rioRegion.notifyOnEntry = true
        rioRegion.notifyOnExit = true
        return rioRegion
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.prepare(identifier: "favSegue", for: segue)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func prepare(identifier: String, for segue: UIStoryboardSegue) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "favSegue"{
            let vc = segue.destination as! FavoriteViewController
            vc.delegate = self
        }
    }
    
    
    // load place of interests from data manager
    func loadPointsOfInterests(){
        for item in DataManager.sharedInstance.places{
           
            let coordinates =  CLLocationCoordinate2DMake(item.lat, item.long)
            //let newPlace = MapAnnotation(title: item.name,
                                         //subtitle: item.description, coordinate: coordinates)
            let newPlace = Place()
            newPlace.name = item.name
            newPlace.longDescription = item.description
            newPlace.coordinate = coordinates
            newPlace.title = newPlace.name
            
            mapView.addAnnotation(newPlace)
            self.placeFromData.append(newPlace)
        }
    }
    
    @objc func favButtonTapped(_ button: UIButton){
        let placeName = (self.detailName.text)!
        if DataManager.sharedInstance.favPlaces[placeName]!.type == -1{
            self.detailFavButton.isSelected = true
            DataManager.sharedInstance.saveFavorites(placeName: placeName)
        }else{
            self.detailFavButton.isSelected = false
            DataManager.sharedInstance.deleteFavorite(placeName: placeName)
        }
    }
    


}

extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        if (view.annotation is MKUserLocation) {
            return
        }
        
        let annotation  = view.annotation as! Place
        self.detailName.text = (annotation.name)!
        self.detailDescription.text = (annotation.longDescription)!
        annotation.title = annotation.name
        
        
        let placeName = (self.detailName.text)!
        
       
        if DataManager.sharedInstance.favPlaces[placeName]!.type == -1{
           
            self.detailFavButton.isSelected = false
           
        }else{
            self.detailFavButton.isSelected = true
        }
        
        self.view.bringSubviewToFront(self.detailAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //print("Tapped a callout")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if let annotation = annotation as? Place{
            let identifier = "CustomPin"
            
            // Create a new view
            var view: PlaceMarkerView
            
            // Deque an annotation view or create a new one
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PlaceMarkerView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                annotation.title = annotation.name
                view = PlaceMarkerView(annotation: annotation, reuseIdentifier: identifier)
                annotation.title = annotation.name
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
        
            return view
            
        }
        return nil
    }
    
}


extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized!")
        case .notDetermined:
            print("We need to request authorization")
        default:
            print("Not authorized :(")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didEnterRegion region: CLRegion) {
        print("Enter region")
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didExitRegion region: CLRegion) {
      print("Leaving region")
      
      //locationManager.stopMonitoring(for: region)
    }
    
    // Called when we request state for region
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState,for region: CLRegion) {
        //print(" in range!!!")
        if state == CLRegionState.inside {
          print("We are already in this region")
           let alert = UIAlertController(title: "You entered some location of interest!", message: "It is somehow recommended :)", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
           

          self.present(alert, animated: true)
        }
    }
}

extension MapViewController: PlacesFavoritesDelegate {
  func favoritePlace(name: String) -> Void {
   // Update the map view based on the favorite
   // place that was passed in
    self.detailName.text = name
    
    if DataManager.sharedInstance.favPlaces[name]!.type == -1{
        self.detailFavButton.isSelected = false
       
    }else{
        self.detailFavButton.isSelected = true
    }
    self.detailDescription.text = DataManager.sharedInstance.favPlaces[name]!.description
    let zoomLocation = CLLocationCoordinate2DMake(DataManager.sharedInstance.favPlaces[name]!.lat, DataManager.sharedInstance.favPlaces[name]!.long)
    let zoomSpan = MKCoordinateSpan(latitudeDelta: DataManager.sharedInstance.region[2], longitudeDelta: DataManager.sharedInstance.region[3])
    let viewRegion = MKCoordinateRegion(center: zoomLocation, span: zoomSpan)
    mapView.setRegion(viewRegion, animated: true)
    
  }
}



