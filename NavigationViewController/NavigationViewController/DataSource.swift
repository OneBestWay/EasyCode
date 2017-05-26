//
//  DataSource.swift
//  NavigationBar
//
//  Created by GK on 2017/5/23.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class DataSource: NSObject,UITableViewDataSource,UITableViewDelegate {
    
    typealias SelectedRow = (_ indexPath: IndexPath) -> Void
    
    var selectedRow: SelectedRow?
    
    static let dataSource = DataSource()
    
    private override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = String(format: "%d", indexPath.row)
        
        let refrenceRed = Float((arc4random() % 255)) / 255.0
        let refrenceGreen = Float((arc4random() % 255)) / 255.0
        let refrenceBlue = Float((arc4random() % 255)) / 255.0
        
        let offset = 40
        let red = Float((Int(arc4random()) % (offset * 2) - offset)) / 255.0 + refrenceRed
        let green = Float((Int(arc4random()) % (offset * 2) - offset)) / 255.0 + refrenceGreen
        let blue = Float((Int(arc4random()) % (offset * 2) - offset)) / 255.0 + refrenceBlue
        
        cell?.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRow = selectedRow else {
            return
        }
        selectedRow(indexPath)
    }
}

