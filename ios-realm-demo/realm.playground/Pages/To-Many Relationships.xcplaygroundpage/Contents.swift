//: [Previous](@previous)

import Foundation

/*:
 一対多の関係は、`List`型を使って表現することができる
 同じオブジェクトへの参照を複数格納することができる
 */

//: [公式チュートリアル](https://realm.io/docs/swift/latest/)
import UIKit
import Realm
import RealmSwift

// Get the default Realm
let realm = try! Realm()

//一旦すべてのレコードを消す
try! realm.write {
    realm.deleteAll()
}

class Dog: Object {
    dynamic var name = ""
    dynamic var owner: Person? // to-one relationships must be optional
}

// Person model
class Person: Object {
    dynamic var name = ""
    dynamic var birthdate = NSDate(timeIntervalSince1970: 1)
    var dogs = List<Dog>()
}

let someDogs = realm.objects(Dog.self).filter("name contains 'Fido'")
let jim = Person()
let rex = Dog()

jim.dogs.append(objectsIn: someDogs)
jim.dogs.append(rex)
//: 挿入の順序は保証されている
//: [Next](@next)
