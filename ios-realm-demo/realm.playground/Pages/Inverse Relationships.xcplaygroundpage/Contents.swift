//: [Previous](@previous)

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
    dynamic var age = 0
    let owners = LinkingObjects(fromType: Person.self, property: "dogs")
}

class Person: Object {
    dynamic var name = ""
    dynamic var birthdate = NSDate(timeIntervalSince1970: 1)
    var dogs = List<Dog>()
}

let jim = Person()
jim.name = "jim"

let rex = Dog()
jim.dogs.append(rex)

rex.owners.count

let Alex = Person()
Alex.dogs.append(rex)

rex.owners.count
//: [Next](@next)
