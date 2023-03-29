//
//  ViewController.swift
//  TelegramInspiredAnimatableButtons
//
//  Created by Sergey Zapuhlyak on 10.11.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cancelBackView: CancelBackView!
    @IBOutlet var textAligmentView: TextAligmentView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBackView.apply(model: .init(state: .back))
        textAligmentView.apply(model: .init(aligment: .left))
    }
    
    @IBAction func slowAnimationsSwitchSwitchChanged(_ sender: UISwitch) {
        Preferences.shared.slowAnimations = sender.isOn
    }
}

class Preferences {
    
    static let shared = Preferences()
    
    var slowAnimations: Bool = false
}
