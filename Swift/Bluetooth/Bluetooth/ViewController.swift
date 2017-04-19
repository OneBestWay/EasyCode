//
//  ViewController.swift
//  Bluetooth
//
//  Created by GK on 2017/2/8.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    var targetPeripheral: CBPeripheral?
    var targetService: CBService?
    var targetCharacteristic: CBCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        
        //在调用scanForPeripherals方法之前，要确保centralManagerDidUpdateState方法被调用了
        //扫描周围的可用设备  
        // withServices 传入nil,表示周围全部可用的设备，通常需要传入一个CBUUID的数组，表示只发现在该数组的设备
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        //停止扫描  当找到所需要的设备时调用
        centralManager.stopScan()
        
        //连接设备 
        centralManager.connect(targetPeripheral!, options: nil)
        
        //当与peripheral连接成功之后 通信
        
        //找到peripheral的所有的service,service的所携带的数据大小有限制 31bytes,因此数据量大时会有多个service
        //在实际当中不应该传入nil
        targetPeripheral?.discoverServices(nil)
        
        //找到需要的service之后，找该service所提供的characteristic
        //搜索全部的characteristic 调用CBPeripheral的discoverCharacteristics:forService:
        //搜索当前的service的characteristic，forService参数传入刚才找到的service
        targetPeripheral?.discoverCharacteristics(nil, for: targetService!)
        
        //找到所需的characteristic之后，从characteristic中获取数据
        targetPeripheral?.readValue(for: targetCharacteristic!)
        
        //使用 targetPeripheral?.readValue(for: targetCharacteristic!)读取数据的方法并不是实时的
        //如果需要获取实时数据，就需要订阅characteristic
        //通过CBPeripheral的setNotifyValue:forCharacteristic的方法来实现订阅
        
        targetPeripheral?.setNotifyValue(true, for: targetCharacteristic!)
        
        //如果Characteristic可写，可通过CBPeripheral类的writeValue:forCharacteristic:type:方法来写入NSData数据
        
        //<#T##CBCharacteristicWriteType#>
        //CBCharacteristicWriteWithResponse  表示写入成功之后需要回调
        
        //targetPeripheral?.writeValue(<#T##data: Data##Data#>, for: <#T##CBCharacteristic#>, type: <#T##CBCharacteristicWriteType#>)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CBCharacteristic {
    //判断CBCharacteristic是否支持写
    func isSupportWrite() -> Bool {
        let isWriteSupport = self.properties.contains(CBCharacteristicProperties.write)
        return isWriteSupport
    }
    //判断CBCharacteristic是否支持读
    func isSupportRead() -> Bool {
        let isReadSupport = self.properties.contains(CBCharacteristicProperties.read)
        return isReadSupport
    }
    
}
extension ViewController: CBCentralManagerDelegate {
    //required 显示central manager 的可用性
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //根据central.state来判断当前设备是否能作为 central
        if central.state == CBManagerState.poweredOn {
            //当前设备可以作为central
        }else {
            print("当前设备不可以作为central")
        }
    }
    
    //找到可用设备之后回调，会回调多次，每找到一个回调一次，可用数组把找到的设备保存起来 [CBPeripheral]
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        targetPeripheral = peripheral
    }
    
    //连接成功之后调用  可以得到当前的连接状态等数据
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        //给已经连接的Peripheral设代理，这样才能收到peripheral的回调
        targetPeripheral = peripheral
        peripheral.delegate = self
    }
}

extension ViewController: CBPeripheralDelegate {
    
    //找到特定的service之后
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        //获取找到的特定的services
        for service in peripheral.services! {
            targetService = service
        }
    }
    
    //找到所需的characteristic之后，回调
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            targetCharacteristic = characteristic
        }
    }
    
    //如果读取数据正确，回调获取数据 并不是所有的characteristic都可以读值，需要根据CBCharacteristicPropertyRead来判断
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            return
        }
        let data = characteristic.value
    }
    
    //如果订阅，成功与否的回调  并不是所有的characteristic都支持订阅，需要CBCharacteristicPropertyNoify来判断
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    //如果写入数据时type为CBCharacteristicWriteWithResponse，那么写入成功与否都会回调该方法，
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
           print("写入失败")
        }else {
           print("写入成功")
        }
    }
}
