//
//  GTNAddress.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/18/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNAddress: NSObject{

    public var firstName: String = "";
    public var lastName: String = "";
    public var line1: String = "";
    public var line2: String = "";
    public var city: String = "";
    public var state: String = "";
    public var countryCode: String = "";
    public var postalCode: String = "";
    public var phone: String = "";
    public var email: String = "";
    
    public override init() {
        super.init();
    }
    
    init (_ jsonObj: AnyObject){
        super.init();
        self.parseJson(jsonObj);
    }
    
    public init(firstName: String, lastName: String, line1: String, line2: String, city: String, state: String, countryCode: String, postalCode: String, phone: String, email: String) {
        super.init();
        self.firstName = firstName;
        self.lastName = lastName;
        self.line1 = line1;
        self.line2 = line2;
        self.city = city;
        self.state = state;
        self.countryCode = countryCode;
        self.postalCode = postalCode;
        self.phone = phone;
        self.email = email;
    }
    
    func parseJson(jsonObj: AnyObject){
        if let firstNameS = jsonObj["FirstName"] as? String { self.firstName = firstNameS };
        if let lastNameS = jsonObj["LastName"] as? String { self.lastName = lastNameS };
        if let line1S = jsonObj["Line1"] as? String { self.line1 = line1S };
        if let line2S = jsonObj["Line2"] as? String { self.line2 = line2S };
        if let cityS = jsonObj["City"] as? String { self.city = cityS };
        if let stateS = jsonObj["State"] as? String { self.state = stateS };
        if let countryCodeS = jsonObj["CountryCode"] as? String { self.countryCode = countryCodeS };
        if let postalCodeS = jsonObj["PostalCode"] as? String { self.postalCode = postalCodeS };
        if let phoneS = jsonObj["Phone"] as? String { self.phone = phoneS };
        if let emailS = jsonObj["Email"] as? String {self.email = emailS};
    }
    
    func elements()->[String:String]{

        return ["FirstName" : firstName,
                "LastName" : lastName,
                "Line1" : line1,
                "Line2" : line2,
                "City" : city,
                "State" : state,
                "PostalCode" : postalCode,
                "CountryCode" : countryCode,
                "Phone" : phone,
                "Email" : email]
    }
}