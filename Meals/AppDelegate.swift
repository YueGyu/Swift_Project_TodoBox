//
//  AppDelegate.swift
//  Meals
//
//  Created by 조여규 on 26/12/2016.
//  Copyright © 2016 조여규. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = MealListViewController()
        
        let mealListViewController = MealListViewController()
        let navigationController = UINavigationController(
            rootViewController: mealListViewController
        )
        self.window?.rootViewController = navigationController
        
       return true
    }
    
}

