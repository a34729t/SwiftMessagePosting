//
//  Analytics.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/1/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation

let analyticsMetricTimeInApp = "Time in App"

func trackOpen(launchOptions:NSDictionary!) {
    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
}

func trackTimeInApp(recordedTimeInApp:Bool, startDateTime:NSDate) -> Bool {
    if recordedTimeInApp == false {
        let seconds = startDateTime.timeIntervalSinceNow * -1
        let minutes = Int(seconds/60)
        
        var timeInAppRange:String
        switch minutes {
        case 0...1:
            timeInAppRange = "0...1"
        case 1...3:
            timeInAppRange = "1...3"
        case 3...5:
            timeInAppRange = "3...5"
        case 5...10:
            timeInAppRange = "5...10"
        default:
            timeInAppRange = "10+"
        }
        
        let dimensions = [
            "timeRange": timeInAppRange
            // possibly add user to this
        ]
        // Send the dimensions to Parse along with the 'search' event
        PFAnalytics.trackEvent(analyticsMetricTimeInApp, dimensions:dimensions)
        
        return true
    } else {
        return false
    }
}