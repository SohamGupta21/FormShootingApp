//
//  StatisticsViewModel.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/19/22.
//

import Foundation
import CoreGraphics
import FirebaseFirestore
import FirebaseAuth

class StatsViewModel : ObservableObject{
    
    @Published var statsData = [[String : String]]()
    @Published var bigChartData : [Daily] = []
    
    @Published var circle_Data = [
        Stats(id: 0, title: "Running", currentData: 6.8, goal: 15, color: Colors().redColor),
        Stats(id: 1, title: "Water", currentData: 3.5, goal: 5, color: Colors().whiteColor),
        Stats(id: 2, title: "Energy Burn", currentData: 585, goal: 1000, color: Colors().greyColor),
        Stats(id: 3, title: "Sleep", currentData: 6.2, goal: 10, color: Colors().redColor),
        Stats(id: 4, title: "Cycling", currentData: 12.5, goal: 25, color: Colors().greenColor),
        Stats(id: 5, title: "Steps", currentData: 16889, goal: 20000, color: Colors().orangeColor)
    ]
    
    init(){
        self.downloadStats()
    }
    
    func generateBigChartData(){
        let last_seven_days = self.getDates(forLastNDays: 7)
        // text to display
        var last_seven_weekdays = [String]()
        var last_seven_shots = [Int]()
        var counter = 0
        for day in last_seven_days.reversed(){
            var shotsSum = 0
            for workout in statsData {
                if workout["date"] == day {
                    shotsSum += Int(workout["shots_taken"] ?? "0") ?? 0
                }
            }
            
            bigChartData.append(Daily(id: counter, day: self.getAbbrevOfDay(self.getDayOfWeek(day)!), workout_In_Min: shotsSum))
            
            counter += 1
        }
        // shots put up
    }
    
    func generateCircleChartData() {
        
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func getAbbrevOfDay(_ day : Int) -> String {
        if day == 1 {
            return "S"
        } else if day == 2 {
            return "M"
        } else if day == 3 {
            return "T"
        } else if day == 4 {
            return "W"
        } else if day == 5 {
            return "Th"
        } else if day == 6 {
            return "F"
        } else if day == 7 {
            return "S"
        } else {
            return ""
        }
    }
    
    func downloadStats(){
        let docRef  = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                self.statsData = dataDescription["workout_log"] as! [[String : String]]
                
                self.generateBigChartData()

            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func getType(val : String)-> String{
        switch val {
        case "Water" : return "L"
        case "Skeep" : return "Hrs"
        case "Running" : return "Km"
        case "Cycling": return "Km"
        case "Steps": return "stp"
        default:return "Kcao"
        }
    }

    func getDec(val: CGFloat)->String{
        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        return format.string(from: NSNumber.init(value: Float(val)))!
    }

    func getPercent(current: CGFloat, Goal: CGFloat)->String{
        let per = (current  / Goal) * 100
        
        return String(format: "%.1f", per)
    }

    func getHeight(value : CGFloat)->CGFloat{
        let hrs = CGFloat(value / 150) * 200

        return hrs
    }

    func getHrs(value
                : CGFloat)->String{
        let hrs = value / 60
        return String(format: "%.1f", hrs)
    }
    
    func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())

        var arrDates = [String]()

        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        return arrDates
    }
    
}

