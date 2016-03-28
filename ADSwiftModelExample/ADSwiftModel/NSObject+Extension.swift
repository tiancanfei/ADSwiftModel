//
//  NSObject+Extension.swift
//  test
//
//  Created by bjwltiankong on 16/3/26.
//  Copyright © 2016年 bjwltiankong. All rights reserved.
//

import UIKit

private var _isCustom = false

//MARK: - 基础类型，可归档
class JLBObject:NSObject,NSCoding
{
    override class func initialize()
    {
       self.isCustomClass = true
    }
    
    override init()
    {
       super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init()
        deCoderWithCode(aDecoder)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

//MARK: - 数据模型转换
extension NSObject
{
    //MARK: 获取命名空间
    ///获取命名空间
    class var spaceName:String
    {
        get
        {
            return NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        }
    }
    
    //MARK: 是否是自定义对象
    ///是否是自定义对象
    class var isCustomClass:Bool
    {
        get
        {
            return _isCustom
        }
        set
        {
            _isCustom = newValue
        }
    }
    
    //MARK: 字典转模型
    ///字典转模型
    class func objectWithKeyValue(keyValue:[String:AnyObject]) -> AnyObject?
    {
        if keyValue.isEmpty
        {
            return nil
        }
        let obj = self.init()
        let mirror = Mirror(reflecting: obj)
        for (name, value) in mirror.children
        {
            //获取属性类型字符串
            let valueType = Mirror(reflecting: value).subjectType
            var valueTypeString = "\(valueType)".stringByReplacingOccurrencesOfString("Optional", withString: "")
            
            //处理数组
            if valueTypeString.containsString("Array")
            {
                valueTypeString = valueTypeString.stringByReplacingOccurrencesOfString("<", withString: "")
                valueTypeString = valueTypeString.stringByReplacingOccurrencesOfString(">", withString: "")
                valueTypeString = valueTypeString.stringByReplacingOccurrencesOfString("Array", withString: "")
                if let aDict = keyValue[name!]
                {
                    let aClass = NSClassFromString(NSObject.spaceName + "." + valueTypeString)
                    let aValue = aClass?.objectWithKeyValues(aDict as! [[String : AnyObject]])
                    obj.setValue(aValue, forKey: name!)
                }
            }
            else
            {//非数组
                valueTypeString = valueTypeString.stringByReplacingOccurrencesOfString("<", withString: "")
                valueTypeString = valueTypeString.stringByReplacingOccurrencesOfString(">", withString: "")
                let dClass = NSClassFromString(NSObject.spaceName + "." + valueTypeString)
                if dClass?.isCustomClass == true
                {//处理自定义对象
                    if let dDict = keyValue[name!]
                    {
                        let dValue = dClass?.objectWithKeyValue(dDict as! [String:AnyObject])
                        obj.setValue(dValue, forKey: name!)
                    }
                }
                else
                {//处理普通类型
                    if let key = keyValue[name!]
                    {                        
                        obj.setValue("\(key)", forKey: name!)
                    }
                }
            }
            
        }
        return obj
    }
    
    //MARK: 字典数组转模型数组
    ///字典数组转模型数组
    class func objectWithKeyValues(keyValues:[[String:AnyObject]]) -> [AnyObject]?
    {
        if keyValues.isEmpty
        {
            return nil
        }
        var objs = [AnyObject]()
        for keyValue in keyValues
        {
            if let obj = self.classForCoder().objectWithKeyValue(keyValue)
            {
                objs.append(obj)
            }
        }
        return objs
    }
    
    //MARK: - 归档，解档
    //MARK: 解档
    func deCoderWithCode(coder:NSCoder)
    {
        let mirror = Mirror(reflecting: self)
        
        for (key, _) in mirror.children
        {
            setValue(coder.decodeObjectForKey(key!), forKey: key!)
        }
    }
    
    //MARK: 归档
    func encodeWithCoder(coder: NSCoder)
    {
        let mirror = Mirror(reflecting: self)
        
        for (key, _) in mirror.children
        {
            coder.encodeObject(valueForKey(key!), forKey: key!)
        }
    }
    
    //MARK: 保存对象到沙盒
    class func saveObject(object:AnyObject, name:String)
    {
        let documents = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let path = documents?.stringByAppendingString(name)
        NSKeyedArchiver.archiveRootObject(object, toFile: path!)
    }
    
    //MARK: 从沙盒读取对象
    class func readObjectWithName(name:String) -> AnyObject?
    {
        let documents = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let path = documents?.stringByAppendingString(name)
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path!)
    }
}
