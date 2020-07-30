//
//  EditCommentViewController.swift
//  CSE438 Final Project
//
//  Created by 王梓辰 on 7/29/20.
//  Copyright © 2020 Michael Zhao. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class EditCommentViewController: UIViewController {
    
    
    @IBOutlet weak var content: UITextView!
    var courseId:String?
    var username:String = ""
    var realname:String = ""
    let ref = Database.database().reference(withPath: "comments")
    var checkBox:Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        realname = UserDefaults.standard.string(forKey: "name")!
        checkBox = Checkbox(frame: CGRect(x: 340, y: 438, width: 21, height: 21))
        self.view.addSubview(checkBox)
    }
    @IBAction func publishAction(_ sender: Any) {
        var commentDict:[String:Any] = [:]
        commentDict.updateValue(0, forKey: "likes")
        commentDict.updateValue(0, forKey: "dislikes")
        if checkBox.isChecked{
            commentDict.updateValue("Anonymous", forKey: "username")
        }else{
            commentDict.updateValue(realname, forKey: "username")
        }
        commentDict.updateValue(courseId!, forKey: "courseId")
        if content.text != nil && content.text != "" {
            commentDict.updateValue(content.text!, forKey: "content")
        }else{
            let alert = UIAlertController(title: "Reminder", message: "The comment cannot be empty", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)
            return
        }
        let identifier = UUID()
        let commentRef = ref.child("\(identifier)")
        commentRef.setValue(commentDict) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
            let alert = UIAlertController(title: "Fail", message: "Some error ocurred during publishing", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)
          } else {
            print("data upload successfully")
            self.navigationController?.popViewController(animated: true)
          }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
