//: [Previous](@previous)

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
    dynamic var address:Address?    //型のネスト
    //let dogs = List<Dog>()
}

/*:
 `Object`型のプロパティをネストしていくことができる
 */
class Address: Object{
    dynamic var country:Country?
}

class Country: Object{
    dynamic var name = "Japan"
}

let jim = Person()

let jimAddress = Address()
jimAddress.country = Country()
jim.address = jimAddress

let rex = Dog()
rex.owner = jim

jim.address?.country?.name

//: [Next](@next)
