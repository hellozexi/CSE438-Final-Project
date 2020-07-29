//
//  CouseEditController.swift
//  CSE438 Final Project
//
//  Created by Mike Liu on 7/28/20.
//  Copyright © 2020 Michael Zhao. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
class CourseEditController: UIViewController {
    var courseId: String?
    var departmentId: String?
    @IBOutlet weak var AText: UITextField!
    @IBOutlet weak var BText: UITextField!
    @IBOutlet weak var CText: UITextField!
    @IBOutlet weak var DText: UITextField!
    @IBOutlet weak var PText: UITextField!
    @IBOutlet weak var FText: UITextField!
    @IBOutlet weak var avgGPAText: UITextField!
    @IBOutlet weak var courseNameLabel: UILabel!
    let ref = Database.database().reference(withPath: "courseInfo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = self.departmentId! + self.courseId!
        courseNameLabel.text = text
        //print(self.courseId ?? "")
    }
    
    
    @IBAction func Submit(_ sender: Any) {
        var courseDict: [String: Any] = [:]
        if (AText.text != nil && AText.text != "") {
            courseDict.updateValue(Int(AText.text!) ?? 0, forKey: "A")
        }
        if (BText.text != nil && BText.text != "") {
            courseDict.updateValue(Int(BText.text!) ?? 0, forKey: "B")
        }
        if (CText.text != nil && CText.text != "") {
            courseDict.updateValue(Int(CText.text!) ?? 0, forKey: "C")
        }
        if (DText.text != nil && DText.text != "") {
            courseDict.updateValue(Int(DText.text!) ?? 0, forKey: "D")
        }
        if (PText.text != nil && PText.text != "") {
            courseDict.updateValue(Int(PText.text!) ?? 0, forKey: "Pass")
        }
        if (FText.text != nil && FText.text != "") {
            courseDict.updateValue(Int(FText.text!) ?? 0, forKey: "Fail")
        }
        if (avgGPAText.text != nil && avgGPAText.text != "") {
            courseDict.updateValue(Double(avgGPAText.text!) ?? 0, forKey: "avgGPA")
        }
        //print(courseDict)
        let deptRef = ref.child(self.departmentId!)
        let childRef = deptRef.child(self.courseId!)
        
        childRef.setValue(courseDict) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data except GPA could not be saved: \(error).")
          } else {
            print("Data except GPA saved successfully!")
          }
        }
        
    }
    
}
