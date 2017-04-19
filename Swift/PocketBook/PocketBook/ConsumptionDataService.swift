//
//  ConsumptionDataService.swift
//  PocketBook
//
//  Created by GK on 2017/3/23.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation

protocol ConsumptionDataServiceDelegate {
    func listDidChanged()
}
class ConsumptionDataService {
    var consumptionList: [ConsumptionDTO] = []

    var delegate: ConsumptionDataServiceDelegate?
    
    
}

class readJSON {
    static func readJSON(fileName: String) -> [String:Any] {
        do {
            if let file = Bundle.main.url(forResource: "consumption", withExtension: "json"),let data = Data(contentsOf:file) {
                
            }
        } catch {
            print("file load error")
        }
    }
}
