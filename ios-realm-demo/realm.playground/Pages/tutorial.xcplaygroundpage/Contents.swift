//: Playground - noun: a place where people can play

import UIKit
import Realm
import RealmSwift

var str = "Hello, playground"

let realm = try! Realm()
realm.configuration.fileURL
