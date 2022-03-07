//
//  ServiceConfigurationViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 24/10/21.
//

import UIKit
import BEMCheckBox

class ServiceConfigurationViewController: BaseViewController {

    @IBOutlet weak var serviceListView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    private lazy var serviceTimingVC: ServiceTimingViewController = {
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.ServiceTimingVC) as! ServiceTimingViewController
        add(asChildViewController: vc)
        return vc
    }()
    
    private lazy var serviceTypeVC: ServiceTypeViewController = {
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.ServiceTypeVC) as! ServiceTypeViewController
        add(asChildViewController: vc)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegment()
    }
    

    @IBAction func segmentalControlBtn(_ sender: UISegmentedControl) {
        setupSegment()
    }

    func setupSegment() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: serviceTimingVC)
            add(asChildViewController: serviceTypeVC)
        } else {
            remove(asChildViewController: serviceTypeVC)
            add(asChildViewController: serviceTimingVC)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        serviceListView.addSubview(viewController.view)

        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



