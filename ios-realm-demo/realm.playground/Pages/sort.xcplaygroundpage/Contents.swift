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

//SetUpper.cleanUpRealm()

//:
class Person: Object {
    dynamic var name = ""
    dynamic var dog: Dog?
}

class Dog: Object {
    dynamic var name = ""
    dynamic var age = 0
}

func defineAndSaveDogOwners(){
    let john = Person()
    john.name = "John"
    
    let myDog = Dog()
    myDog.name = "DJ"
    myDog.age = 5
    
    john.dog = myDog
    
    try! realm.write {
        realm.add(myDog)
        realm.add(john)
    }
    
    let tomas = Person()
    tomas.name = "Tomas"
    
    let mimi = Dog()
    mimi.name = "Mimi"
    mimi.age = 3
    
    tomas.dog = mimi
    
    try! realm.write {
        realm.add(mimi)
        realm.add(tomas)
    }
}

defineAndSaveDogOwners()

let dogOwners = realm.objects(Person.self)
let ownersByDogAge = dogOwners.sorted(byKeyPath: "dog.age")

for owner in ownersByDogAge{
    print(owner.name)
    print(owner.dog!.name)
    print("")
}


//: [Next](@next)
