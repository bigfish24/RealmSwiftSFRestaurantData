# RealmSwiftSFRestaurantData
Prebuilt Realm dataset composed of San Francisco restaurant scores for Realm Swift

[Data Source](https://data.sfgov.org/data?search=restaurants)

####Data Model
`Object` subclasses corresponding to the data model are included in the objects folder. 

Data model structure:

* `ABFRestaurantObject`
  * businessId: `String` (primary key)
  * name: `String`
  * address: `String`
  * city: `String`
  * state: `String`
  * postalCode: `String`
  * latitude: `Double`
  * longitude: `Double`
  * phoneNumber: `String`
  * violations: `List<ABFViolationObject>()`
  * inspections: `List<ABFInspectionObject>()`
* `ABFInspectionObject`
  * restaurant: `ABFRestaurantObject`
  * score: `Int`
  * date: `NSDate`
  * type: `ABFInspectionType`
* `ABFViolationObject`
  * restaurant: `ABFRestaurantObject`
  * date: `NSDate`
  * violationDescription: `String`

####Installation
`RealmSwiftSFRestaurantData` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:
```
pod "RealmSwiftSFRestaurantData"
```
From your project:
```Swift
let realm = Realm(path: ABFRestaurantScoresPath())

let restaurants = realm.objects(ABFRestaurantObject)
```
####Demo
An example project that uses `RealmSwiftSFRestaurantData` is provided in the [ABFRealmSearchViewController](https://github.com/bigfish24/ABFRealmSearchViewController) repo. To install follow the instructions provided.
