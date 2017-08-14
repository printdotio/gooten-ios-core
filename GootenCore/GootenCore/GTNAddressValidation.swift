//
//  GTNAddressValidation.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/21/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNAddressValidation: NSObject {

    open var isValid: Bool = false;
    open var reason: String = "";
    open var score: Int = -999;
    open var proposedAddress: GTNProposedAddress = GTNProposedAddress();
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let isValidS = jsonObj["IsValid"] as? Bool { self.isValid = isValidS; }
        if let reasonS = jsonObj["Reason"] as? String { self.reason = reasonS; }
        if let scoreS = jsonObj["Score"] as? Int { self.score = scoreS; }
        if let pAddressObj = jsonObj["ProposedAddress"] {
            self.proposedAddress = GTNProposedAddress(pAddressObj as AnyObject);
        }
    }
}
