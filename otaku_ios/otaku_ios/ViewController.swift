//
//  ViewController.swift
//  otaku_ios
//
//  Created by EL FATHI LALAOUI on 18/01/2022.
//

import UIKit

class ViewController: UIViewController {

    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var filmsButton: UIButton!
    
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Otaku"
        
        titleLabel.textColor = .red
        titleLabel.text = "Welcome to your ghibli films"
    }


    @IBAction func goToFilms(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FILMSGALL")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

