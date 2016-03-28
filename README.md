# ADSwiftModel
swift模型转换框架
使用swift反射实现的模型转换和对象归档框架

###使用方法
直接继承JLBObject创建模型对象</br>
生成的对象可以直接归档</br>
可以直接使用扩展提供的方法进行模型转换</br>
* 字典转模型使用</br>
class func objectWithKeyValue(keyValue:[String:AnyObject]) -> AnyObject?</br>
* 字典数组转模型数组</br>
class func objectWithKeyValues(keyValues:[[String:AnyObject]]) -> [AnyObject]?</br>
* 对象归档</br>
 class func saveObject(object:AnyObject, name:String)</br>
* 对象解档</br>
  class func readObjectWithName(name:String) -> AnyObject?</br>
 ###Example
```  
//Person.swift
import UIKit

class Person: JLBObject {
    var name:String?
    var age:Int32 = 0
    var sex:Bool = false
    var book:[Book]?
}

//Book.swift

import UIKit

class Book: JLBObject {
    var name:String?
    var price:String?
    var count:Int32 = 0
    var author:Author?
}

//Author.swift
import UIKit

class Author: JLBObject {
    var name:String?
    var age:String?
    var sex:Bool = true
}

//ViewController.swift
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
}
```
