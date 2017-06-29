//: [Previous](@previous)

import Foundation
import Realm
import RealmSwift

// Get the default Realm
let realm = try! Realm()

//一旦すべてのレコードを消す
try! realm.write {
    realm.deleteAll()
}

// A Realm Object that represents a city
class City: Object {
    dynamic var city = ""
    dynamic var id = 0
    
    override static func primaryKey()->String?{
        return "id"
    }
}

//: オブジェクトのプロパティ名と、jsonのキー名は合致していないと正しくjsonからオブジェクトを生成してロードできない
//let data = "{\"name\": \"San Francisco\", \"cityId\": 123}".data(using: .utf8)!   //正しくロードできない
let data = "{\"city\": \"San Francisco\", \"id\": 123}".data(using: .utf8)!

// Insert from NSData containing JSON
try! realm.write {
    let json = try! JSONSerialization.jsonObject(with: data, options: [])
    realm.create(City.self, value: json, update: true)
}

let cities = realm.objects(City.self)
cities[0].id
cities[0].city

//: オブジェクトのプロパティの変更は、write節の内部で行わないと実行時エラー
try! realm.write {
    cities[0].city = "SF"
}

//変更が反映されている
cities[0].city


//: [Next](@next)
