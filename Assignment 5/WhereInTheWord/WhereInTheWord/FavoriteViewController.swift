//
//  FavoriteViewController.swift
//  WhereInTheWord
//
//  Created by sinze vivens on 2020/2/9.
//  Copyright © 2020 Luke. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: PlacesFavoritesDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        dismissButton.backgroundColor = UIColor.gray
        dismissButton.tintColor = UIColor.green
        
        dismissButton.addTarget(self, action: #selector(self.didTapCancel(_:)), for: .touchUpInside)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       
    }
    
    @objc func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.sharedInstance.addedFav.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = DataManager.sharedInstance.addedFav[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate!.favoritePlace(name: DataManager.sharedInstance.addedFav[indexPath.row])
        dismiss(animated: true)
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
