# ios-realm-demo
iOS Realmを利用したCRUD操作のサンプルです。

## 1. PodFile

```
  pod 'RealmSwift' , '<= 2.4.1'
```

## 2. import する

```
import RealmSwift
```

## 3. モデルの作成

```
class ToDoModel: Object {
    @objc dynamic var taskID = 0
    @objc dynamic var title = ""
    @objc dynamic var limitDate: Date?
    @objc dynamic var isDone = false
    @objc dynamic private var _image: UIImage? = nil
    @objc dynamic private var imageData: Data? = nil
    @objc dynamic var image: UIImage?{
        set{
            //imageにsetすると、自動的に_imageに値が保持され、imageDataにも変換&setされる。
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    
    override static func primaryKey() -> String? {
        return "taskID"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
}
```

## 4. Daoの作成

```
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
```

## 参考:Realm データベースへのアクセサ

```
import RealmSwift

final class RealmDaoHelper <T : RealmSwift.Object> {
    let realm: Realm
    
    init() {
        try! realm = Realm()
    }
    
    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        
        if let last = realm.objects(T.self).last,// as? RealmSwift.Object,
            let lastId = last[key] as? Int {
            return lastId + 1
        } else {
            return 1
        }
    }
    
    /**
     * 全件取得
     */
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }
    
    /**
     * 1件目のみ取得
     */
    func findFirst() -> T? {
        return findAll().first
    }
    
    /**
     * 指定キーのレコードを取得
     */
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    /**
     * 最後のレコードを取得
     */
    func findLast() -> T? {
        return findAll().last
    }
    
    /// フィルタリングしたレコードを取得
    ///
    /// - Parameter predicate: フィルタリングの条件
    /// - Returns: フィルタリングしたレコードの配列
    func find(by predicate:NSPredicate) -> Results<T> {
        return realm.objects(T.self).filter(predicate)
    }
    
    /**
     * レコードを追加
     */
    func add(d :T) {
        do {
            try realm.write {
                realm.add(d)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    /**
     * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
     */
    func update(d: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(d, update: true)
            }
            return true
        } catch let error as NSError {
            print(error.description)
        }
        return false
    }
    
    /**
     * レコード削除
     */
    func delete(d: T) {
        do {
            try realm.write {
                realm.delete(d)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    /**
     * レコード全削除
     */
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
}
```

## 不整合が発生した時

もし消してもいいのであれば、`po Realm.Configuration.defaultConfiguration.fileURL`でRealmのDBの本体を特定して消去することで整合性の問題は解消される。

## 開発環境
| Category | Version |
|:-----------:|:------------:|
| Swift | 4 |
| Xcode | 9.2 |
| iOS | 10.0~ |


## Reference

[Realm × Swift2 でシームレスに画像を保存する - Qiita](https://qiita.com/_ha1f/items/593ca4f9c97ae697fc75)

[Realm swift get started](https://realm.io/docs/swift/latest#getting-started)

[SwiftでRealmを使う時のTips(3) NSPredicate編 - Qiita](https://qiita.com/nakau1/items/40865299dacc50d71604)

[NSPredicate Cheatsheet](https://academy.realm.io/posts/nspredicate-cheatsheet/)