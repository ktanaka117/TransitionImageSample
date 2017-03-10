//
//  SecondViewController.swift
//  TransitionImageSample
//
//  Created by 田中賢治 on 2017/03/09.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var indexPath: IndexPath!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        imageView.image = #imageLiteral(resourceName: "ktanaka117")
    }
    
    @IBAction func tapButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
