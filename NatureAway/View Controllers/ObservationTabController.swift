//
//  ObservationTabController.swift
//  NatureAway
//
//  Created by Chris Beale on 5/18/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

protocol ObservationTab : class {
    var observations: [Observation]? { get set }
}

class ObservationTabController: UITabBarController {

    var species: Species?
    var observations: [Observation]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadObservations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadObservations() {
        if let species = species, taxonId = species.id {
            INaturalistClient.sharedInstance.getObservations(taxonId, completion: { (observations: [Observation]?, error: NSError?) -> Void in
                if let observations = observations {
                    self.observations = observations
                    if let controllers = self.viewControllers {
                        for controller in controllers {
                            if let controller = controller as? ObservationTab {
                                controller.observations = observations
                            }
                        }
                    }
                }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
