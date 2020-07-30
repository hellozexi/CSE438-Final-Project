//
//  MyCoursesViewController.swift
//  CSE438 Final Project
//
//  Created by Mike Liu on 7/29/20.
//  Copyright © 2020 Michael Zhao. All rights reserved.
//



import Foundation
import UIKit
import FirebaseDatabase

class MyCourseTableViewCell: UITableViewCell{
    var myCourse:ResultCourse!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    func update(){
        nameLabel.text=myCourse.id+" "+myCourse.name
        unitLabel.text="Credit: "+String(myCourse.credits)
        descriptionLabel.text="Description: "+myCourse.description
    }
}
class MyCoursesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var resultTable: UITableView!
    let userdefaults = UserDefaults.standard
//    var departmentID:String?
    var results: [ResultCourse] = []
    var selectedCourseID:String=""
    var selectedCourseName:String=""
    var selectedCourseCredit:String=""
    var selectedCourseDescription:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTable.dataSource = self
        resultTable.delegate=self
        
        getMyCourses()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVC" {
            let VC = segue.destination as? CourseEditController
            VC?.courseId = selectedCourseID
            //VC?.departmentId = self.departmentID
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCourseID=results[indexPath.row].id
        selectedCourseName = results[indexPath.row].name
        selectedCourseCredit = String(results[indexPath.row].credits)
        selectedCourseDescription = results[indexPath.row].description
        
        self.performSegue(withIdentifier: "toEditVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTable.dequeueReusableCell(withIdentifier: "myCourseCell", for: indexPath) as! MyCourseTableViewCell
        cell.myCourse=results[indexPath.row]
        cell.update()
        return cell
    }
    
    func isInstructor(_ name: String, _ instructors: String) -> Bool {
        let arr = instructors.split(separator: ";")
        for instructor in arr {
            if(name == instructor) {
                return true
            }
        }
        return false
    }
    
    func getMyCourses(){
        let ref = Database.database().reference().child("courses")
        results=[]
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = self.userdefaults.string(forKey: "name")
            if(value==nil){
                return
            }
            for dep in value!{
                let courses = dep.value as!NSDictionary
                for course in courses{
                    let id = course.key as! String
                    let dic = course.value as! NSDictionary
                    let name = dic["name"] as! String
                    let credits = dic["unit"] as! Int
                    let description = dic["description"] as! String
                    if(dic["instructor"] == nil) {
                        continue
                    }
                    let instructor = dic["instructor"] as! String
                    if(self.isInstructor(username!, instructor)) {
                        let course = ResultCourse(id: id, name: name, credits: credits, description: description, instructor: instructor)
                        self.results.append(course)
                    }
                    
                }
                
            }
            self.results.sort(by: { $0.id < $1.id })
            self.resultTable.reloadData()
        
          // ...
          }) { (error) in
            
            print(error.localizedDescription)
        }
        
        
    }
    
    
}
