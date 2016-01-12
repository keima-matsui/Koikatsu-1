//
//  Test1ViewController.swift
//  sPre2
//
//  Created by keima on 2015/12/05.
//  Copyright © 2015年 keima. All rights reserved.
//

import UIKit
import Parse


class Test1ViewController: UIViewController {

    //MARK: Variable
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    var array : Array <String> = []
    var array1 : Array <Int> = []
    var array2 : Array <String> = []
    var array3 : Array <String> = []
    var array4 : Array <UIImage?> = []
    var imageFiles : PFFile? = nil
    var u = 0
    
    //MARK: MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myImgView.layer.borderColor = UIColor.grayColor().CGColor
        self.myImgView.layer.borderWidth = 1
        self.myImgView.layer.cornerRadius = 74
        self.myImgView.layer.masksToBounds = true
        

        let query = PFQuery(className:"_User")
        query.whereKey("sex", equalTo:"m")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {

                print("Successfully retrieved2 \(objects!.count) .")
            
                if let objects = objects {
                    for object in objects {
                        
                        let dateformatter: NSDateFormatter = NSDateFormatter()
                        dateformatter.locale = NSLocale(localeIdentifier: "ja")
                        dateformatter.dateFormat = "yyyy/MM/dd"
                        
                        let age = self.age(dateformatter.dateFromString((object.objectForKey("birthday")?.description)!)!)
                        let nickname = object.objectForKey("nickname")?.description
                        let region = object.objectForKey("region")?.description
                        let comment = object.objectForKey("PR")?.description
                        
                        
                        
                        if(object["thumb"] != nil){
                            self.imageFiles = object["thumb"] as? PFFile
                            
                            
                            do{
                                let imageFile  = try self.imageFiles?.getData()
                                self.array4.append((UIImage(data:imageFile!)))
                            }catch{
                                print("Image fetch error")
                            }
                        }else{
                            self.array4.append(nil)
                        }

                        self.array.append(nickname!)
                        
                        self.array1.append(age)
                        
                        self.array2.append(region!)
                        
                        if(comment != nil){
                            self.array3.append(comment!)
                        }else{
                            self.array3.append("なし")
                        }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   // MARK: FUNCTION
    
    func age(birthDate: NSDate,baseDate: NSDate = NSDate()) -> Int {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        var comps = (0, 0, 0, 0)
        calendar.getEra(&comps.0, year: &comps.1, month: &comps.2, day: &comps.3, fromDate: birthDate)
        
        var comps2 = (0, 0, 0, 0)
        calendar.getEra(&comps2.0, year: &comps2.1, month: &comps2.2, day: &comps2.3, fromDate: baseDate)
        
        var y = comps2.1 - comps.1
    
        if comps2.2 < comps.2 {
            y = y - 1
        } else if (comps2.2 == comps.2) && (comps2.3 < comps.3) {
            y = y - 1
        }
        return y
    }
    
    //MARK: Action
    
    @IBAction func addFavAction(sender: AnyObject) {
    
        if(self.u < array1.count){
        
            infoLabel.text = self.array[u] + "(" + String(self.array1[u]) + "歳" + "・" + self.array2[u] + ")"
            prLabel.text = self.array3[u]
        
            if(self.array4[u] != nil){
                myImgView.image = self.array4[u]
        }else{
            myImgView.image = UIImage(named: "noimg.png")
        }
       
        }else{
            infoLabel.text = "該当するユーザがいません"
            prLabel.text = ""
            myImgView.image = UIImage(named: "noimg.png")
        }
        
        u++
        
    }

}
