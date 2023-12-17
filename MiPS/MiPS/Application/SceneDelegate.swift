//
//  SceneDelegate.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
        
        let initVC = SelectMusicViewController()
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(initVC, animated: false)
    }
}

