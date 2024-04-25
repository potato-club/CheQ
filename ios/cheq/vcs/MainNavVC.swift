//
//  MainNavVC.swift
//  cheq
//
//  Created by Isaac Jang on 4/16/24.
//  try to git init

import Foundation
import UIKit

class MainNavVC : UINavigationController {
    var defView : UIViewController = MainViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isHidden = true

        viewControllers = [defView]
    }

    @MainActor
    func clearPush(vc: UIViewController) {
        
        pushViewController(vc, animated: true)

        viewControllers = [vc]
    }

    @MainActor
    func removeVC(rvc: UIViewController) {
        for i in 0 ..< viewControllers.count {
            let vc = viewControllers[i]
            if vc == rvc {
                viewControllers.remove(at: i)
            }
        }
    }
}
