//
//  SFRestaurantScores.swift
//  RealmSwiftSFRestaurantData
//
//  Created by Adam Fish on 6/16/15.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

import Foundation
import RealmSwift

/**
The type of inspection

- Initial:  An initial inspection type
- Routine:  A routine inspection type
- FollowUp: A follow up inspection type
*/
enum ABFInspectionType: Int {
    case Initial = 0,Routine, FollowUp
}

/**
 *  Model for a restaurant in San Francisco
 */
public class ABFRestaurantObject: Object {
    public dynamic var businessId: String?
    public dynamic var name: String?
    public dynamic var address: String?
    public dynamic var city: String?
    public dynamic var state: String?
    public dynamic var postalCode: String?
    public dynamic var latitude: Double = 37.7859547
    public dynamic var longitude: Double = -122.4024658
    public dynamic var phoneNumber: String?
    public let violations = List<ABFViolationObject>()
    public let inspections = List<ABFInspectionObject>()
    
    override public static func primaryKey() -> String? {
        return "businessId"
    }
}

/**
 *  Model for an inspection at a restaurant
 */
public class ABFInspectionObject: Object {
    public dynamic var restaurant: ABFRestaurantObject?
    public dynamic var score = 0
    public dynamic var date: NSDate?
    public dynamic var type = 0
}

/**
 *  Model for a violation at a restaurant
 */
public class ABFViolationObject: Object {
    public dynamic var restaurant: ABFRestaurantObject?
    public dynamic var date: NSDate?
    public dynamic var violationDescription: String?
}

/**
Retrieve the path for a given file name in the documents directory

:param: fileName the name of the file in the documents directory

:returns: path to SFRestaurantScores.realm
*/
public func ABFDocumentFilePathWithName(fileName: String) -> String {
    #if os(iOS)
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        #else
        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        
        if (NSProcessInfo.processInfo().environment["APP_SANDBOX_CONTAINER_ID"] == nil) {
            
            var identifier = NSBundle.mainBundle().bundleIdentifier
            
            if (identifier == nil) {
                identifier = (NSBundle.mainBundle().executablePath! as NSString).lastPathComponent
            }
            
            path = path.stringByAppendingPathComponent(identifier!)
            
            try! NSFileManager.defaultManager().createDirectoryAtPath((path as String), withIntermediateDirectories: true, attributes: nil)
        }
    #endif
    
    return path.stringByAppendingPathComponent(fileName)
}

/**
Retrieve the path for the prebuilt SFRestaurantScores Realm file

:returns: path to SFRestaurantScores.realm
*/
public func ABFRestaurantScoresPath() -> String {
    
    let fileInDocuments = ABFDocumentFilePathWithName("SFRestaurantScores.realm")
    
    if (!NSFileManager.defaultManager().fileExistsAtPath(fileInDocuments)) {
        
        let fileInBundle = NSBundle(forClass: ABFRestaurantObject.self).pathForResource("SFRestaurantScores", ofType: "realm")
        
        let fileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.copyItemAtPath(fileInBundle!, toPath: fileInDocuments)
        } catch {
            print("Copy File Error: \(error)")
        }
        
        do {
            try fileManager.setAttributes([NSFilePosixPermissions : 0o644], ofItemAtPath: fileInDocuments)
        } catch {
            print("File Permission Error: \(error)")
        }
    }
    
    return fileInDocuments
}
