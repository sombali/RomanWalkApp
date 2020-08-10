//
//  NSManagedObjectContext+Ext.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 25..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
