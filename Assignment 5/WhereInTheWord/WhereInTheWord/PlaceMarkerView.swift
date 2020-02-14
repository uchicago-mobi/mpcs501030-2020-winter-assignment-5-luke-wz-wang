//
//  PlaceMarkerView.swift
//  WhereInTheWord
//
//  Created by sinze vivens on 2020/2/9.
//  Copyright © 2020 Luke. All rights reserved.
//

import UIKit
import MapKit

class PlaceMarkerView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   
    override var annotation: MKAnnotation? {
        willSet {
            //clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            image = UIImage(named: "pin")
            tintColor = .purple
            
        }
    }
    
    

}
