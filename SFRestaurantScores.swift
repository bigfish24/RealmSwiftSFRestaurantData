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
    public dynamic var businessId = ""
    public dynamic var name = ""
    public dynamic var address = ""
    public dynamic var city = ""
    public dynamic var state = ""
    public dynamic var postalCode = ""
    public dynamic var latitude: Double = 37.7859547
    public dynamic var longitude: Double = -122.4024658
    public dynamic var phoneNumber = ""
    public dynamic var violations = List<ABFViolationObject>()
    public dynamic var inspections = List<ABFInspectionObject>()
    
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
    public dynamic var date = NSDate.distantPast() as! NSDate
    public dynamic var type = 0
}

/**
*  Model for a violation at a restaurant
*/
public class ABFViolationObject: Object {
    public dynamic var restaurant: ABFRestaurantObject?
    public dynamic var date = NSDate.distantPast() as! NSDate
    public dynamic var violationDescription = ""
}

/**
Retrieve the path for a given file name in the documents directory

:param: fileName the name of the file in the documents directory

:returns: path to SFRestaurantScores.realm
*/
public func ABFDocumentFilePathWithName(fileName: String) -> String {
    #if os(iOS)
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        #else
        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        
        if (NSProcessInfo.processInfo().environment["APP_SANDBOX_CONTAINER_ID"] == nil) {
            
            var identifier = NSBundle.mainBundle().bundleIdentifier
            
            if (identifier == nil) {
                identifier = NSBundle.mainBundle().executablePath?.lastPathComponent
            }
            
            path = path.stringByAppendingPathComponent(identifier!)
            
            NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
            
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
        
        var error: NSError?
        
        let fileManager = NSFileManager.defaultManager()
        
        if (!fileManager.copyItemAtPath(fileInBundle!, toPath: fileInDocuments, error: &error)) {
            println("Copy File Error: \(error!.description)")
            
            error = nil
        }
        
        if (!fileManager.setAttributes([NSFilePosixPermissions : 0o644], ofItemAtPath: fileInDocuments, error: &error)) {
            println("File Permission Error: \(error!.description)")
        }
    }
    
    return fileInDocuments
}
