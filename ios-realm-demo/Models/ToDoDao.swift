//
//  ToDoDao.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/02/18.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import Foundation
import RealmSwift

final class ToDoDao {
    
    static let dao = RealmDaoHelper<ToDoModel>()
    
    static func add(model: ToDoModel) {
        let object = ToDoModel()
        object.taskID = ToDoDao.dao.newId()!
        object.title = model.title
        object.isDone = model.isDone
        object.limitDate = model.limitDate
        object.image = model.image
        ToDoDao.dao.add(d: object)
    }
    
    @discardableResult static func update(model: ToDoModel) -> Bool {
        guard let object = dao.findFirst(key: model.taskID as AnyObject) else {
            return false
        }
        object.title = model.title
        object.limitDate = model.limitDate
        object.isDone = model.isDone
        object.image = model.image
        return dao.update(d: object)
    }
    
    static func delete(taskID: Int) {
        guard let object = dao.findFirst(key: taskID as AnyObject) else {
            return
        }
        dao.delete(d: object)
    }
    
    static func deleteAll() {        
        dao.deleteAll()
    }
    
    static func find(by taskID: Int) -> ToDoModel? {
        guard let object = dao.findFirst(key:taskID as AnyObject) else {
            return nil
        }
        return object
    }
    
    static func findAll() -> [ToDoModel] {
        let objects =  ToDoDao.dao.findAll()
        return objects.map { ToDoModel(value: $0) }
    }
}

extension ToDoDao {
    static func find(by predicate: NSPredicate) -> [ToDoModel] {
        return ToDoDao.dao.find(by: predicate).map({ToDoModel(value: $0)})
    }
}

extension ToDoDao {
    
    /// レコードの更新処理
    ///
    /// - Parameters:
    ///   - model: 更新したいオブジェクト
    ///   - transaction: 更新したいオブジェクトの更新処理　トランザクションのブロックで実行される
    /// - Returns: 成功時true
    @discardableResult static func update(model: ToDoModel,
                                          transaction: @escaping () -> Void) -> Bool {
        return dao.update(d: model, block: transaction)
    }
}
