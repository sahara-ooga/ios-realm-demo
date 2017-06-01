//: Playground - noun: a place where people can play
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

// Define your models like regular Swift classes
class Dog: Object {
    dynamic var name = ""
    dynamic var owner:Person?
    dynamic var age = 0
}

class Person: Object {
    dynamic var name = ""
    dynamic var picture: NSData? = nil // optionals supported
    let dogs = List<Dog>()
}

// Use them like regular Swift objects
let myDog = Dog()
myDog.name = "DJ"
myDog.age = 1
print("name of dog: \(myDog.name)")

// Query Realm for all dogs less than 2 years old
let puppies = realm.objects(Dog.self).filter("age < 2")
puppies.count // => 0 because no dogs have been added to the Realm yet

// Persist your data easily
try! realm.write {
    realm.add(myDog)
}

// Queries are updated in realtime
puppies.count // => 1

// Query and update from any thread
DispatchQueue(label: "background").async {
    autoreleasepool {
        let realm = try! Realm()
        let theDog = realm.objects(Dog.self).filter("age == 1").first
        try! realm.write {
            theDog!.age = 3
        }
    }
}

realm.objects(Dog.self).filter("age == 3")
