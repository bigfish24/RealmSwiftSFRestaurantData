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
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
    #else
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        
        if (ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] == nil) {
            
            var identifier = Bundle.main.bundleIdentifier
            
            if (identifier == nil) {
                identifier = (Bundle.main.executablePath! as NSString).lastPathComponent
            }
            
            path = path.appendingPathComponent(identifier!) as NSString
            
            try! FileManager.default.createDirectory(atPath: (path as String), withIntermediateDirectories: true, attributes: nil)
        }
    #endif
    
    return path.appendingPathComponent(fileName)
}

/**
Retrieve the path for the prebuilt SFRestaurantScores Realm file

:returns: path to SFRestaurantScores.realm
*/
public func ABFRestaurantScoresPath() -> String {
    
    let fileInDocuments = ABFDocumentFilePathWithName(fileName: "SFRestaurantScores.realm")
    
    if (!FileManager.default.fileExists(atPath: fileInDocuments)) {
        
        let fileInBundle = Bundle(for: ABFRestaurantObject.self).path(forResource: "SFRestaurantScores", ofType: "realm")
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.copyItem(atPath: fileInBundle!, toPath: fileInDocuments)
        } catch {
            print("Copy File Error: \(error)")
        }
        
        do {
            try fileManager.setAttributes([FileAttributeKey.posixPermissions : 0o644], ofItemAtPath: fileInDocuments)
        } catch {
            print("File Permission Error: \(error)")
        }
    }
    
    return fileInDocuments
}
