//
//  GTNAddressValidation.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/21/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNAddressValidation: NSObject {

    public var isValid: Bool = false;
    public var reason: String = "";
    public var score: Int = -999;
    public var proposedAddress: GTNProposedAddress = GTNProposedAddress();
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject){
        if let isValidS = jsonObj["IsValid"] as? Bool { self.isValid = isValidS; }
        if let reasonS = jsonObj["Reason"] as? String { self.reason = reasonS; }
        if let scoreS = jsonObj["Score"] as? Int { self.score = scoreS; }
        if let pAddressObj = jsonObj["ProposedAddress"], pAddressJson = pAddressObj {
            self.proposedAddress = GTNProposedAddress(pAddressJson);            
        }
    }
}