//
//  LocationExtension.swift
//  cheq
//
//  Created by Isaac Jang on 5/14/24.
//

import Foundation
import CoreLocation

extension JVC: CLLocationManagerDelegate {
    

    func initLocation() {
        locationManager.delegate = self                         // 델리게이트 넣어줌.
        locationManager.requestAlwaysAuthorization()            // 위치 권한 받아옴.
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startLocaion() {
        DLog.p("startLocation")
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        locationManager.distanceFilter = 3000.0
//        locationManager.startUpdatingLocation()                 // 위치 업데이트 시작
        

        locationManager.startMonitoring(for: getBeaconRegion())
    }
    
    // 위치 서비스에 대한 권한이 받아들여지면 MonitorBeacons() 함수 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            DLog.p("monitor beacons run")
            monitorBeacons()
        } else {
            print("permission denied")
        }
    }
    
    

    // Monitoring 진행이 가능한 상태면 Monitoring 진행
    func monitorBeacons(){
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            DLog.p("inner monitoring able")
            // 디바이스가 이미 영역 안에 있거나 앱이 실행되고 있지 않은 상황에서도 영역 내부 안에 들어오면 백그라운드에서 앱을 실행시켜
            // 헤당 노티피케이션을 받을 수 있게 함
            getBeaconRegion().notifyEntryStateOnDisplay = true
            // 영역 안에 들어온 순간이나 나간 순간에 해당 노티피케이션을 받을 수 있게 함
            getBeaconRegion().notifyOnExit = true
            getBeaconRegion().notifyOnEntry = true
//            locationManager.startMonitoring(for: getBeaconRegion())
//            locationManager.startRangingBeacons(satisfying: nil)
//            locationManager.startUpdatingLocation()
            
            
        } else {
            print("CLLocation Monitoring is unavailable")
        }
    }

    // 모니터링이 실행된 후 영역의 판단이 이루어지는 순간에 이 메소드가 실행
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        DLog.p("location Manager : \(state) / \(region)")
        if state == .inside {        // 영역 안에 들어온 순간
//            locationManager.startRangingBeacons(in: getBeaconRegion())
            let beaconUUID = UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!
            locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconUUID))
        }else if state == .outside { // 영역 밖에 나간 순간
//            locationManager.startRangingBeacons(in: getBeaconRegion())
            locationManager.stopRangingBeacons(in: getBeaconRegion())
        }else if state == .unknown {
            print("Now unknown of Region")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        DLog.p("didRangeBeacons : \(beacons.count)")
//        for item in beacons {
//            DLog.p("beacon : \(item.uuid)")
//        }
        // 연결할 수 있는 비콘이 있는 경우
        if beacons.count > 0 {
//            for item in beacons {
//                DLog.p("beacon : \(item)")
//            }
            let nearestBeacon = beacons.first!  // 가장 가까이 있는 비콘을 내 비콘으로 잡자.
            // 거리에 맞게 원하는 코드를 작성하면 끝
            self.lastBeacon = beacons.first!
            switch nearestBeacon.proximity {
            case .immediate:
                break
                    
            case .near:
                break
                    
            case .far:
                break
                    
            case .unknown:
                break
            }
        }
        else {
            lastBeacon = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("비콘이 범위 내에 있음")
    }
        
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("비콘이 범위 밖을 벗어남")
    }
    
    func getBeaconUUID() -> UUID {
        return UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!
    }
    
    func getBeaconConstraint() -> CLBeaconIdentityConstraint{
        return CLBeaconIdentityConstraint(uuid: getBeaconUUID())
    }
    
    func getBeaconRegion() -> CLBeaconRegion {
        let beaconRegionConstraints = CLBeaconIdentityConstraint(uuid: getBeaconUUID())
        let region = CLBeaconRegion.init(uuid: getBeaconUUID(), identifier: getBeaconUUID().uuidString)
        return region
    }
}
