//
//  ViewController.swift
//  RandomCollection
//
//  Created by GK on 2017/4/9.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataSource = DataSource()
    let layout = DynamicLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = dataSource
        self.collectionView.backgroundColor = UIColor.white
    }





}

