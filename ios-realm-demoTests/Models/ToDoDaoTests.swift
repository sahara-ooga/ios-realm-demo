//
//  ToDoDaoTests.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/02/18.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import XCTest
@testable import ios_realm_demo

class ToDoDaoTests: XCTestCase {
    
    override func setUp() {
        ToDoDao.deleteAll()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        ToDoDao.deleteAll()
    }
    
    func testAddItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        object.image = UIImage(named: "snow.jpg")
        //Exercise
        ToDoDao.add(model:object)
        
        //Verify
        verifyItem(taskID: 1,
                   title: "タイトル",
                   isDone: true,
                   limiteDateStr: "2016/01/01")
    }
    
    func testUpdateItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        object.image = UIImage(named: "snow.jpg")

        //Exercise
        ToDoDao.add(model:object)
        guard let loaded = ToDoDao.find(by: 1) else {
            XCTFail("Fail to load")
            return
        }

        ToDoDao.update(model: loaded){
            //Dao.addメソッドで取得したオブジェクトは、
            //writeの引数のクロージャ内で更新しないとエラーが発生した
            loaded.title = "タイトル更新"
            loaded.isDone = false
            loaded.limitDate = "2017/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        }
        
        //Verify
        verifyItem(taskID: 1,
                   title: "タイトル更新",
                   isDone: false,
                   limiteDateStr: "2017/01/01")
    }
    
    func testDeleteItem() {
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        object.image = UIImage(named: "snow.jpg")

        //Exercise
        ToDoDao.add(model:object)
        ToDoDao.delete(taskID: 1)
        
        //Verify
        verifyCount(count:0)
    }
    
    func testFindAllItem() {
        
        //Setup
        let tasks = [ToDoModel(),ToDoModel(),ToDoModel()]
        
        //Exercise
        _ = tasks.map {
            ToDoDao.add(model:$0)
        }
        
        //Verify
        verifyCount(count:3)
    }
    
    func testFindItem() {
        
        //Setup
        let object = ToDoModel()
        object.taskID = 1
        object.title = "タイトル"
        object.isDone = true
        object.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        object.image = UIImage(named: "snow.jpg")

        //Exercise
        ToDoDao.add(model:object)
        let result = ToDoDao.find(by: 1)
        
        //Verify
        XCTAssertEqual(result?.taskID, 1)
    }
    
    //MARK:-private method
    private func verifyItem(taskID: Int, title: String,
                            isDone: Bool, limiteDateStr: String) {
        
        let result = ToDoDao.findAll()
        
        XCTAssertEqual(result.first?.taskID, taskID)
        
        if let resultTitle = result.first?.title {
            XCTAssertEqual(resultTitle, title)
        }
        
        if let isDoneResult = result.first?.isDone {
            
            if isDone {
                XCTAssertTrue(isDoneResult)
            }
            else {
                XCTAssertFalse(isDoneResult)
            }
        }
        
        if let limiteDate = result.first?.limitDate?.date2Str(dateFormat: "yyyy/MM/dd") {
            XCTAssertEqual(limiteDate, limiteDateStr)
        }
        
    }
    
    private func verifyCount(count: Int) {
        let result = ToDoDao.findAll()
        XCTAssertEqual(result.count, count)
    }
}

extension ToDoDaoTests {
    func testFindAndFilter() {
        threeModel.forEach(ToDoDao.add(model:))
        
        let predicates = [
            NSPredicate(format: "title = %@", argumentArray: ["タイトル2"]),
        ]
        let compoundedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let result = ToDoDao.find(by: compoundedPredicate)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.isDone, true)
    }
    
    var threeModel: [ToDoModel] {
        
        let object1 = ToDoModel()
        object1.taskID = 1
        object1.title = "タイトル"
        object1.isDone = false
        object1.limitDate = "2016/01/01".str2Date(dateFormat: "yyyy/MM/dd")
        object1.image = UIImage(named: "snow.jpg")
        
        let object2 = ToDoModel()
        object2.taskID = 2
        object2.title = "タイトル2"
        object2.isDone = true
        object2.limitDate = "2016/01/02".str2Date(dateFormat: "yyyy/MM/dd")
        object2.image = UIImage(named: "snow.jpg")
        
        let object3 = ToDoModel()
        object3.taskID = 3
        object3.title = "タイトル2"
        object3.isDone = false
        object3.limitDate = "2016/01/03".str2Date(dateFormat: "yyyy/MM/dd")
        object3.image = UIImage(named: "snow.jpg")
        
        return [object1, object2, object3]
    }
}
