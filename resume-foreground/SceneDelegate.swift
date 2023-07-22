//
//  SceneDelegate.swift
//  resume-foreground
//
//  Created by Kyle Hilla on 2/21/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var isUserLoggedIn = true
    
    var blurView: UIView?
    var useBlur = false
    
    var blockingViewController: UIViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissBlocker), name: Notification.Name("dismissBlocker"), object: nil)
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        if BlockingManager.shared.useBlur == true {
            UIView.animate(withDuration: 0.2) {
                self.blurView?.alpha = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.blurView?.removeFromSuperview()
            }
        }
    }
    
    @objc func dismissBlocker()
    {
        UIView.animate(withDuration: 0.2) {
            self.blockingViewController?.view.alpha = 0.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.blockingViewController?.view.removeFromSuperview()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        if BlockingManager.shared.useBlur == true {
            window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.last!
            blurView = UIView(frame: CGRect(x: 0, y: 0, width: (window?.frame.size.width)!, height: (window?.frame.size.height)!))

            // https://pspdfkit.com/blog/2020/blur-effect-materials-on-ios/
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = blurView!.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView?.addSubview(blurEffectView)
            blurView?.alpha = 0.0
            window?.addSubview(blurView!)

            UIView.animate(withDuration: 0.2) {
                self.blurView?.alpha = 1.0
            }
            
        } else {
            if let topVC = UIApplication.getLastViewController() {
                if !topVC.isKind(of: BlockingViewController.self) {
                    let storyboard = UIStoryboard(name: "Blocker", bundle: nil)
                    blockingViewController = storyboard.instantiateViewController(withIdentifier: "BlockingViewController")

                    blockingViewController?.view.alpha = 0.0
                    window?.addSubview((blockingViewController?.view)!)
                    
                    UIView.animate(withDuration: 0.2) {
                        self.blockingViewController?.view.alpha = 1.0
                    }
                }
            }
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: UIApplication extensions
extension UIApplication {

    class func getLastViewController(base: UIViewController? = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.last { $0.isKeyWindow }?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getLastViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getLastViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getLastViewController(base: presented)
        }

        return base
    }
}
