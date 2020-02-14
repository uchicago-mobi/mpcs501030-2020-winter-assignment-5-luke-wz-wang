//
//  MapAnnotation.swift
//  WhereInTheWord
//
//  Created by sinze vivens on 2020/2/9.
//  Copyright © 2020 Luke. All rights reserved.
//

// Attribution: playground from lecture

import Foundation

import MapKit

class MapAnnotation: NSObject, MKAnnotation {
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D
 

  init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
    super.init()
  }
 
}
