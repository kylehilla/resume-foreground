//
//  BlockingViewController.swift
//  resume-foreground
//
//  Created by Kyle Hilla on 2/21/23.
//

import UIKit

class BlockingViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @IBAction func dismissSelf(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("dismissBlocker"), object: nil)
    }
    
    @objc func appMovedToForeground() {
//        self.dismiss(animated: true)
    }
}
