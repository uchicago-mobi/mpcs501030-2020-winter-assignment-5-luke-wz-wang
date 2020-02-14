//
//  DataManager.swift
//  WhereInTheWord
//
//  Created by sinze vivens on 2020/2/9.
//  Copyright © 2020 Luke. All rights reserved.
//

import Foundation

public struct PlaceInfo{
    var name: String
    var description: String
    var lat: Double
    var long: Double
    var type: Int
    func inti(){
       
    }
}

public class DataManager {
  
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()

    public var placeArray = [Dictionary<String, Any>]()
    
    public var regionArray = NSArray()
    
    public var region = [Double]()
    
    public var places = [PlaceInfo]()
    
    public var favPlaces: [String: PlaceInfo] = [:]
    
    public var addedFav = [String]()
    
    fileprivate init() {}
    
    func loadAnnotationFromPlist() {
        
        let dictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist")!);
        placeArray = dictionary?["places"] as! [Dictionary<String, Any>]
        regionArray = dictionary?["region"] as! NSArray
        for item in regionArray{
            let newItem = item as! Double
            region.append(newItem)
            
        }
        for item in placeArray{
            let newPlace = PlaceInfo(name:  item["name"] as! String, description: item["description"] as! String, lat: item["lat"] as! Double, long: item["long"] as! Double, type: -1)
            places.append(newPlace)
            favPlaces.updateValue(newPlace, forKey: newPlace.name)
        }
        // retrieve data from userdefaults
        let defaultFavList = UserDefaults.standard.stringArray(forKey: "name") ?? [String]()
        for item in defaultFavList{
            addedFav.append(item)
        }
        
        for item in defaultFavList{
            favPlaces[item]?.type = 1
        }

        
        
    }
    func saveFavorites(placeName: String) {
        addedFav.append(placeName)
        favPlaces[placeName]!.type = 1
        UserDefaults.standard.set(addedFav, forKey: "name")
    }
    func deleteFavorite(placeName: String) {
        favPlaces[placeName]!.type = -1
        addedFav.remove(object: placeName)
        UserDefaults.standard.set(addedFav, forKey: "name")
    }
    func listFavorites() {
        
    }
  
}
