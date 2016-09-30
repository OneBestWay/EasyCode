//
//  ViewController.swift
//  StoryboardDemo
//
//  Created by GK on 2016/9/30.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let storyboard = UIStoryboard(storyboard: .News)
        let newsVC: NewsViewController = storyboard.instantiateViewController()
        print("init view controller : %@", String(describing: newsVC))
        
        self.navigationController?.pushViewController(newsVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

