//
//  MainTabVC.swift
//  instagram-clone
//
//  Created by Roman Akhtariev on 2019-02-24.
//  Copyright © 2019 Roman Akhtariev. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Delegate.
        self.delegate = self
        
        // configure view controllers
        configureViewControllers()
        
        // user validation
        checkIfUserLoggedIn()
        
    }
    

    // function to create view controllers that exist within tab bar controller
    func configureViewControllers()
    {
        // home feed controller
        let feedVC = constructNavController(
            unselectedImage: UIImage(named: "home_unselected.png")!,
            selectedImage: UIImage(named: "home_selected.png")!,
            rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // search feed controller
        let searchVC = constructNavController(
            unselectedImage: UIImage(named: "search_unselected.png")!,
            selectedImage: UIImage(named: "search_selected.png")!,
            rootViewController: SearchVC())
        
        // post controller
        let uploadPostVC = constructNavController(
            unselectedImage: UIImage(named: "plus_unselected.png")!,
            selectedImage: UIImage(named: "plus_unselected.png")!,
            rootViewController: UploadPostVC())
        
        // notifiction controller
        let notificationVC = constructNavController(
            unselectedImage: UIImage(named: "like_unselected.png")!,
            selectedImage: UIImage(named: "like_selected.png")!,
            rootViewController: NotificationsVC())
        
        // profile controller
        let userProfileVC = constructNavController(
            unselectedImage: UIImage(named: "profile_unselected.png")!,
            selectedImage: UIImage(named: "profile_selected.png")!,
            rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // view controllers to be added to tab controller
        
        viewControllers = [feedVC, searchVC, uploadPostVC, notificationVC, userProfileVC]
        
        // tab bar tint colour
        tabBar.tintColor = .black
        
    }
    
    /// construct navigation controllers
    func constructNavController(
        unselectedImage: UIImage,
        selectedImage: UIImage,
        rootViewController: UIViewController = UIViewController()) -> UINavigationController
    {
        
        // construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        return navController
    }
    
    func checkIfUserLoggedIn()
    {
        if Auth.auth().currentUser == nil
        {
            DispatchQueue.main.async
                {
                    // present login controller
                    let loginVC = LoginVC()
                    let navController = UINavigationController(rootViewController: loginVC)
                    self.present(navController, animated: true, completion: nil)
            }
        }
    }
    
}
