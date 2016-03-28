//
//  ViewController.swift
//  ADSwiftModelExample
//
//  Created by bjwltiankong on 16/3/26.
//  Copyright © 2016年 bjwltiankong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var testBool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let dict = ["name":"小史", "age":"34", "sex":true, "book":[["name":"诛仙", "price":"34", "count":"78","author":["name":"萧鼎", "age":"45"]],["name":"诛仙", "price":"34", "count":"78","author":["name":"萧鼎", "age":"45"]],["name":"诛仙二", "price":"34", "count":"78","author":["name":"萧鼎", "age":"45","sex":true]]]]
        
        let person:Person = Person.objectWithKeyValue(dict) as! Person
        
        NSObject.saveObject(person, name: "person")
        
        let person1 = NSObject.readObjectWithName("person") as! Person
        
        print(person1.book![2].name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

