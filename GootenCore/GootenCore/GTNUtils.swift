//
//  GTNUtils.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/4/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

func printgt(_ items: Any...){
    if !GTNConfig.sharedInstance.turnOffLogs {
        print(items);
    }
}

func gtnUtilsReplace(_ searchString: String, pattern: String, replacementPattern: String) -> String?{
    do {
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators);
        let replacedString = regex.stringByReplacingMatches(in: searchString, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, searchString.characters.count), withTemplate: replacementPattern)
        return replacedString}
    catch let error as NSError {
        printgt("GTNUtils.replace error: \(error)");
    }
    return nil;
}

class GTNUtils {
    
    
}
