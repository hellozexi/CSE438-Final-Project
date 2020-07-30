//
//  ResultViewController.swift
//  CSE438 Final Project
//
//  Created by Michael Zhao on 7/28/20.
//  Copyright © 2020 Michael Zhao. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ClassTableViewCell: UITableViewCell{
    var myCourse:ResultCourse!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    func update(){
        nameLabel.text=myCourse.id+" "+myCourse.name
        unitLabel.text="Credit: "+String(myCourse.credits)
        descriptionLabel.text="Description: "+myCourse.description
    }
}
class ResultViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var resultTable: UITableView!
    //let userdefaults = UserDefaults.standard
    var departmentID:String?
    var isSearch:Bool!
    var searchText:String?
    var results:[ResultCourse]=[]
    var selectedCourseID:String=""
    var selectedCourseName:String=""
    var selectedCourseCredit:String=""
    var selectedCourseDescription:String=""
    //var isStudent = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resultTable.register(UITableViewCell.self, forCellReuseIdentifier: "classCell")
        resultTable.dataSource = self
        resultTable.delegate=self
        if(isSearch){
            if(searchText != nil && searchText != ""){
                search(text: searchText!)
            }
        }else{
            getCourses()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "toDetailVC" {
            let VC = segue.destination as? UITabBarController
            let barViews = VC?.viewControllers
            let infoVC = barViews![0] as! CourseInfoViewController
            let statsVC = barViews! [1] as! StatsViewController
            let commentVC = barViews! [2] as! CommentsViewController
            //declare a course ID variable in CourseDetailViewController, and pass the selectedCourseID to it, and that will be the ID for the selected Course
            commentVC.courseId = selectedCourseID
            statsVC.courseId = selectedCourseID
            statsVC.departmentId = departmentID!
            infoVC.courseId = selectedCourseID
            infoVC.name = selectedCourseName
            infoVC.credits = selectedCourseCredit
            infoVC.courseDes = selectedCourseDescription
//            print(selectedCourseID)
//            print(selectedCourseName)
//            print(selectedCourseCredit)
//            print(selectedCourseDescription)
        }
        /*else if(segue.identifier == "toMyCoursesVC") {
            let VC = segue.destination as? MyCoursesViewController
            VC!.departmentID = self.departmentID
        }*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCourseID=results[indexPath.row].id
        selectedCourseName = results[indexPath.row].name
        selectedCourseCredit = String(results[indexPath.row].credits)
        selectedCourseDescription = results[indexPath.row].description
        
        self.performSegue(withIdentifier: "toDetailVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTable.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! ClassTableViewCell
        cell.myCourse=results[indexPath.row]
        cell.update()
        return cell
    }
    func search(text:String){
        let ref = Database.database().reference().child("courses")
        results=[]
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
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
                    let course = ResultCourse(id: id, name: name, credits: credits, description: description, instructor: "")
                    if (name.contains(text)){
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
    func getCourses(){
        if let depID=departmentID{
            let ref = Database.database().reference().child("courses").child(depID)
            results=[]
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if(value==nil){
                    return
                }
                for course in value!{
                    let id = course.key as! String
                    let dic = course.value as! NSDictionary
                    let name = dic["name"] as! String
                    let credits = dic["unit"] as! Int
                    let description = dic["description"] as! String
                    let course = ResultCourse(id: id, name: name, credits: credits, description: description, instructor: "")
                    self.results.append(course)
                }
                self.results.sort(by: { $0.id < $1.id })
                self.resultTable.reloadData()
            
              // ...
              }) { (error) in
                
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    
}
