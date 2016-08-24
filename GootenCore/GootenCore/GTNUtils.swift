//
//  GTNUtils.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/4/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

func printgt(items: Any...){
    if !GTNConfig.sharedInstance.turnOffLogs {
        print(items);
    }
}

func gtnUtilsReplace(searchString: String, pattern: String, replacementPattern: String) -> String?{
    do {
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators);
        let replacedString = regex.stringByReplacingMatchesInString(searchString, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, searchString.characters.count), withTemplate: replacementPattern)
        return replacedString}
    catch let error as NSError {
        printgt("GTNUtils.replace error: \(error)");
    }
    return nil;
}

class GTNUtils {
    
    
}