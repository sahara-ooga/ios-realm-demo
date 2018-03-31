//
//  ToDoModel.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/02/17.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoModel: Object {
    @objc dynamic var taskID = 0
    @objc dynamic var title = ""
    @objc dynamic var limitDate: Date?
    @objc dynamic var isDone = false
    @objc dynamic private var _image: UIImage? = nil
    @objc dynamic private var imageData: Data? = nil
    @objc dynamic var image: UIImage?{
        set{
            //imageにsetすると、自動的に_imageに値が保持され、imageDataにも変換&setされる。
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    
    override static func primaryKey() -> String? {
        return "taskID"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
}
