//
//  ViewController.swift
//  CSE438 Final Project
//
//  Created by Michael Zhao on 7/22/20.
//  Copyright © 2020 Michael Zhao. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LogInViewController: UIViewController {
    let userdefault = UserDefaults.standard
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet var options: [UIButton]!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    var option: String = "Student Log In"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.isHidden = true
        nameTextField.isHidden = true
    }
    @IBAction func optionSelected(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else{
            for button in options{
                button.isHidden = true
            }
            return
        }
        self.option = title
        if(title=="Student Log In"||title == "Professor Log In"){
            submitButton.setTitle("Log In", for: .normal)
        }else{
            submitButton.setTitle("Sign Up", for: .normal)
        }
        if(title == "Student Log In" || title == "Student Sign Up" || title == "Professor Sign Up") {
            nameLabel.isHidden = true
            nameTextField.isHidden = true
        } else {
            nameLabel.isHidden = false
            nameTextField.isHidden = false
        }
        optionButton.setTitle(title, for: .normal)
        for button in options{
            button.isHidden = true
        }
    }
    
    @IBAction func seeOptions(_ sender: Any) {
        for button in options{
            button.isHidden = !button.isHidden
        }
    }
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        let username = self.usernameTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        let name: String = self.nameTextField.text ?? ""
        if(option == "Student Log In" || option == "Professor Log In") {
            if(option == "Student Log In") {
                userdefault.set(true, forKey: "isStudent")
            } else {
                userdefault.set(false, forKey: "isStudent")
                userdefault.set(name, forKey: "name")
            }
            if(name == "" && option == "Professor Log In") {
                let alert = UIAlertController(title: "Error", message: "Professor must provide a real name", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.present(alert, animated: true)
                return
            }
            Auth.auth().signIn(withEmail: username, password: password) { (authResult, error) in
                //var user = authResult?.user
                if(error != nil) {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    self.present(alert, animated: true)
                    return
                }
                
                self.performSegue(withIdentifier: "signInToSearchVC", sender: nil)
            }
        } else if(option == "Student Sign Up" || option == "Professor Sign Up") {
            Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
                if(error != nil) {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    self.present(alert, animated: true)
                    return
                }
                let user = authResult?.user
                let ref = Database.database().reference()
                //print("desc:" + ref.description())
                let usersReference = ref.child("users")
                let userId = user?.uid
                let newUserReference = usersReference.child(userId!)
                newUserReference.setValue(["username": self.usernameTextField.text!, "role": (self.option == "Student Sign Up" ? "student" : "professor")])
                
                let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.present(alert, animated: true)
                //self.option = "Student Log In"
                //self.optionButton.setTitle(self.option, for: .normal)
                //self.submitButton.setTitle("Log In", for: .normal)
            }
            
        } else {
            
        }
    }
    
}

