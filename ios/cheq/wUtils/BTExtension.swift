//
//  BTExtension.swift
//  cheq
//
//  Created by Isaac Jang on 5/14/24.
//

import Foundation
import CoreBluetooth

extension JVC: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
         switch central.state {

         case .unknown:
             print("central.state is unknown")
         case .resetting:
             print("central.state is resetting")
         case .unsupported:
             print("central.state is unsupported")
         case .unauthorized:
             print("central.state is unauthorized")
         case .poweredOff:
             print("central.state is poweredOff")
         case .poweredOn:
             print("central.state is poweredOn")
             
         @unknown default:
             print("central.state default case")
         }
     }
    
    
    // Bluetooth 감지
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if btMap.contains(peripheral.identifier.uuidString) {
            return
        }
        btMap.append(peripheral.identifier.uuidString)
        
        print("peripheral : \(peripheral) / \(RSSI)")
//        viewModel.findPeripheral.accept((peripheral, CGFloat(RSSI)))
    }
    
    // Bluetooth 연결 후
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Connected")
        // 아래 파라미터가 nil이면 모든 서비스를 검색.
//        devicePeripheral.discoverServices(nil)
        centralManager.stopScan()
        // 연결 끊기
        // centralManager.cancelPeripheralConnection(peripheral)
    }
    
}

// MARK: Bluetooth Peripheral
extension JVC: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = devicePeripheral.services else {return}
//        for service in services {
//            print(service)
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {return}
        for characteristic in characteristics {
            print("characteristic: \(characteristic)")
            if characteristic.properties.contains(.read) {
                print("readable")
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor characteristic")
        print(characteristic.value ?? "can't get value")
    }
}
