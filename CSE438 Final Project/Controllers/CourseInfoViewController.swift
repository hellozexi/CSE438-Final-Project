//
//  CourseInfoViewController.swift
//  CSE438 Final Project
//
//  Created by 王梓辰 on 7/28/20.
//  Copyright © 2020 Michael Zhao. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Charts

class CourseInfoViewController: UIViewController {
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseDescription: UITextView!
    @IBOutlet weak var instructor: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var seats: UILabel!
    
    let ref = Database.database().reference(withPath: "sections")
    
    var courseId:String?
    var name:String?
    var credits:String?
    var courseDes:String?
    var theSections:[Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let name_ = name{
            courseName.text = name_
        }
        credit.text = credits
        courseDescription.text = courseDes
        getSection()
    }
    
    
    func getSection(){
        if let courId = courseId{
            print(courId)
            let secRef = ref.child(courId)
            theSections = []
            secRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot.value!)
              let value = snapshot.value as? NSDictionary
                let value1 = snapshot.value as? NSMutableArray
              if(value==nil && value1 == nil){
                  print("no result")
                  return
              }else if(value1 == nil){
                for section in value!{
                    let id = section.key as! String
                    let dic = section.value as! NSDictionary
                    let day = dic["day"] as! String
                    let instructor = dic["instructor"] as! String
                    let location = dic["location"] as! String
                    let seats = dic["seats"] as! Int
                    let time = dic["time"] as! String
                    let aSection = Section(id: id, day: day, instructor: instructor, location: location, seats: seats, time: time)
                    self.theSections.append(aSection)
                  //print(self.theSections)
                  
                }
                  self.setupSectionInfos()
              }else if(value == nil){
                let dic = value1![1] as! NSDictionary
                let day = dic["day"] as! String
                let instructor = dic["instructor"] as! String
                let location = dic["location"] as! String
                let seats = dic["seats"] as! Int
                let time = dic["time"] as! String
                let aSection = Section(id: "1", day: day, instructor: instructor, location: location, seats: seats, time: time)
                self.theSections.append(aSection)
                self.setupSectionInfos()
                }
              
              }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func setupSectionInfos(){
        //print(theSections)
        var items:[String] = []
        for aSection in theSections{
            items.append("Section "+aSection.id)
        }
        print(items)
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 27, y: 10, width: 320, height: 30)
        customSC.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        instructor.text = theSections[0].instructor
        location.text = theSections[0].location
        seats.text = String(theSections[0].seats)
        schedule.text = "\(theSections[0].day) \(theSections[0].time)"
        infoView.addSubview(customSC)
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        let num = segmentedControl.selectedSegmentIndex
        instructor.text = theSections[num].instructor
        location.text = theSections[num].location
        seats.text = String(theSections[num].seats)
        schedule.text = "\(theSections[num].day) \(theSections[num].time)"
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
