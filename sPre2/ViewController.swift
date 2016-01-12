//
//  ViewController.swift
//  sPre2
//
//  Created by keima on 2015/12/01.
//  Copyright © 2015年 keima. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action
    
    @IBAction func loginAction(sender: AnyObject) {
   
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        
        if(username?.characters.count < 4 || password?.characters.count < 5){
            
            let alert = UIAlertController(title: "Invaild", message: "Username must be greater than 4 and Password must be greater than 5", preferredStyle: UIAlertControllerStyle.Alert)
            
            presentViewController(alert, animated: true, completion: nil)
            
            
        }else{
            
            
            
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user,error) -> Void in
                
                if((user) != nil) {
                    
                    let alert = UIAlertController(title: "完了", message: "ログインが完了しました。", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default) {
                        
                        action in self.performSegueWithIdentifier("GoIndex", sender: self)
                        
                        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
                        appDelegate.username = username

                        
                    }
                    
                    alert.addAction(defaultAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)

                    
                }else{
                    
                    let alert = UIAlertController(title: "Error", message: "¥(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                
                
            })
            
        }

        
    }


}

