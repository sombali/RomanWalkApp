//
//  Address.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 26..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation

public class Address: NSObject, NSCoding {
    
    public var administrativeArea: String = ""
    public var name: String = ""
    public var postalCode: String = ""
    public var country: String = ""
    
    enum Key: String {
        case administrativeArea = "administrativeArea"
        case name = "name"
        case postalCode = "postalCode"
        case country = "country"
    }

    init(administrativeArea: String, name: String, postalCode: String, country: String) {
        self.administrativeArea = administrativeArea
        self.name = name
        self.postalCode = postalCode
        self.country = country
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(administrativeArea, forKey: Key.administrativeArea.rawValue)
        coder.encode(name, forKey: Key.name.rawValue)
        coder.encode(postalCode, forKey: Key.postalCode.rawValue)
        coder.encode(country, forKey: Key.country.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        guard let dAdministrativeArea = coder.decodeObject(forKey: Key.administrativeArea.rawValue) as? String,
                let dName = coder.decodeObject(forKey: Key.name.rawValue) as? String,
                let dPostalCode = coder.decodeObject(forKey: Key.postalCode.rawValue) as? String,
                let dCountry = coder.decodeObject(forKey: Key.country.rawValue) as? String else { return nil }
        
        self.init(administrativeArea: dAdministrativeArea, name: dName, postalCode: dPostalCode, country: dCountry)
    }
}
