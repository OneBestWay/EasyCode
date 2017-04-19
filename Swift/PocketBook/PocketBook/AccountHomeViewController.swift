//
//  ViewController.swift
//  PocketBook
//
//  Created by GK on 2017/3/11.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class AccountHomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    fileprivate let dataService: ConsumptionDataService = ConsumptionDataService()
    
    var headerHeight: CGFloat = 135.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        headerViewFrameHeight(height: headerHeight)
        setUI()
    }
    func headerViewFrameHeight(height:CGFloat) {
        var headerFrame = tableHeaderView.frame
        headerFrame.size.height = height
        tableHeaderView.frame = headerFrame
    }
    func setUI() {
        //segemented control style
        segmentedControl.layer.borderColor = UIColor.black.cgColor
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.cornerRadius = 4
        segmentedControl.clipsToBounds = true
    }
    
    @IBAction func didSelectedControl(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            headerHeight = 135
            headerViewFrameHeight(height: headerHeight)
            print("did selected 明细")
        case 1:
            headerHeight = 380
            headerViewFrameHeight(height: headerHeight)
            print("did selected 类别报表")
        case 2:
            headerHeight = 135
            headerViewFrameHeight(height: headerHeight)
            print("did selected 账户")
        default: break
            
        }

    }
}

extension AccountHomeViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.consumptionList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.cellIdentifier())
        return cell!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let consumptionDTO = dataService.consumptionList[indexPath.row]
        
        if let detailCell = cell as? DetailsCell {
            detailCell.configCell(consumptionDTO: consumptionDTO)
        }
    }
}

extension AccountHomeViewController: ConsumptionDataServiceDelegate {
    func listDidChanged() {
        self.tableView.reloadData()
    }
}
