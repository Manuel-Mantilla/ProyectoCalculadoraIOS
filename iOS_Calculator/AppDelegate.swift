//
//  AppDelegate.swift
//  iOS_Calculator
//
//  Created by Manuel Mantilla on 2/06/22.
//  Copyright © 2022 Manuel Mantilla. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? //Contenedor principal de la app


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Run setup
        setupView()
        
        return true
    }
    
    //MARK: - Private Methods
    
    private func setupView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = HomeViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }

}

