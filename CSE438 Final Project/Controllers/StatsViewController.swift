//
//  StatsViewController.swift
//  CSE438 Final Project
//
//  Created by 王梓辰 on 7/28/20.
//  Copyright © 2020 Michael Zhao. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Charts

class StatsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var numberA: UILabel!
    @IBOutlet weak var numberB: UILabel!
    @IBOutlet weak var numberC: UILabel!
    @IBOutlet weak var numberD: UILabel!
    @IBOutlet weak var numberPass: UILabel!
    @IBOutlet weak var numberFail: UILabel!
    @IBOutlet weak var avgGPA: UILabel!
    
    var departmentId:String?
    var courseId:String?
    
    var scores = ["A":0, "B":0, "C":0, "D":0, "Pass":0, "Fail":0]
    var gpa:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getGrades()

        // Do any additional setup after loading the view.
        
    }
    
    func getGrades(){
        if let depID = departmentId, let courID = courseId{
            let ref = Database.database().reference().child("courseInfo").child(depID).child(courID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if(value==nil){
                    return
                }
                self.scores["A"] = value!["A"]! as? Int
                print(self.scores["A"]!)
                print(value!["A"]!)
                self.scores["B"] = value!["B"]! as? Int
                self.scores["C"] = value!["C"]! as? Int
                self.scores["D"] = value!["D"]! as? Int
                self.scores["Pass"] = value!["Pass"]! as? Int
                self.scores["Fail"] = value!["Fail"]! as? Int
                self.gpa = (value!["avgGPA"]! as? Double)!
                print(self.scores)
                print(self.gpa)
                
                self.numberA.text = "\(self.scores["A"]!)"
                self.numberB.text = "\(self.scores["B"]!)"
                self.numberC.text = "\(self.scores["C"]!)"
                self.numberD.text = "\(self.scores["D"]!)"
                self.numberPass.text = "\(self.scores["Pass"]!)"
                self.numberFail.text = "\(self.scores["Fail"]!)"
                self.avgGPA.text = "\(self.gpa)"
                let pieChartFrame = CGRect(x: 0, y: 165, width: self.view.frame.width, height: self.view.frame.width)
                let pieChart = PieChartView(frame: pieChartFrame)
                pieChart.delegate = self
                var entries = [PieChartDataEntry]()
                
                entries.append(PieChartDataEntry(value: Double(self.scores["A"]!), label: "A"))
                entries.append(PieChartDataEntry(value: Double(self.scores["B"]!), label: "B"))
                entries.append(PieChartDataEntry(value: Double(self.scores["C"]!), label: "C"))
                entries.append(PieChartDataEntry(value: Double(self.scores["D"]!), label: "D"))
                entries.append(PieChartDataEntry(value: Double(self.scores["Pass"]!), label: "Pass"))
                entries.append(PieChartDataEntry(value: Double(self.scores["Fail"]!), label: "Fail"))
                
                let set = PieChartDataSet(entries: entries)
                set.colors = ChartColorTemplates.pastel()
                
                let data = PieChartData(dataSet: set)
                
                pieChart.data = data
                
                self.view.addSubview(pieChart)
            }) { (error) in
                           
                           print(error.localizedDescription)
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
