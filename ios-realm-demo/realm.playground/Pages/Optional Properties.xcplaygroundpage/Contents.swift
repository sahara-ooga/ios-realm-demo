//: [Previous](@previous)

import Foundation

import UIKit
import Realm
import RealmSwift

// Get the default Realm
let realm = try! Realm()

//一旦すべてのレコードを消す
try! realm.write {
    realm.deleteAll()
}

class Person: Object {
    // Optional string property, defaulting to nil
    dynamic var name: String? = nil
    
    // Optional int property, defaulting to nil
    // RealmOptional properties should always be declared with `let`,
    // as assigning to them directly will not work as desired
    let age = RealmOptional<Int>()
}

try! realm.write {
    var person = realm.create(Person.self, value: ["Jane", 27])
    // Reading from or modifying a `RealmOptional` is done via the `value` property
    person.age.value = 28
}


//: [Next](@next)
