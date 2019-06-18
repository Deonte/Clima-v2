//
//  ViewController.swift
//  Clima v2
//
//  Created by Deonte on 6/17/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet var forecastCollectionView: UICollectionView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var temperatueLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var humidityPercentageLabel: UILabel!
    @IBOutlet var weatherIconImage: UIImageView!
    @IBOutlet var todayButton: UIButton!
    @IBOutlet var tomorrowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
        
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: forecastCell, for: indexPath)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//    
    
}

