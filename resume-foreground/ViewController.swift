//
//  ViewController.swift
//  resume-foreground
//
//  Created by Kyle Hilla on 2/21/23.
//

import UIKit

class ViewController: UIViewController {

    var alertController = UIAlertController()
    
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @IBAction func blurButtonTapped(_ sender: Any) {
        if blurButton.isSelected == true {
            blurButton.isSelected = false
            BlockingManager.shared.useBlur = true
            blurButton.setTitle("Blocking Blur", for: .normal)
        } else {
            blurButton.isSelected = true
            BlockingManager.shared.useBlur = false
            blurButton.setTitle("Blocking View", for: .normal)
        }
    }
    
    @IBAction func alertButtonTapped(_ sender: Any) {
        presentAlert(name: "test")
    }
    
    func presentAlert(name: String) {
        alertController = UIAlertController(title: "Testing", message: "When an alert is top most view controller.", preferredStyle: .alert)
                   
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: {_ in
        })
                   
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(self.alertController, animated: true, completion: nil)
        }
    }

    @objc func appMovedToBackground() {
//        performSegue(withIdentifier: "AppResumeSegue", sender: self)
    }
}

