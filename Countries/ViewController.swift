//
//  ViewController.swift
//  Countries
//
//  Created by Dmitry Reshetnik on 26.04.2020.
//  Copyright © 2020 Dmitry Reshetnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var capitalNameLabel: UILabel!
    @IBOutlet weak var phoneCodeLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    var country: Country? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = country?.name
        capitalNameLabel.text = country?.capital
        phoneCodeLabel.text = country?.phone
        currencyCodeLabel.text = country?.currency
    }


}

