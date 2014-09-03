//
//  Analytics.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/1/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation

let analyticsMetricTimeInApp = "Time in App"
let analyticsMetricComposePost = "Compose Post"
let analyticsMetricComposeComment = "Compose Comment"

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
        case 1...2:
            timeInAppRange = "1...2"
        case 2...3:
            timeInAppRange = "2...3"
        case 3...5:
            timeInAppRange = "3...5"
        default:
            timeInAppRange = "5+"
        }
        
        let dimensions = [
            "timeRange": timeInAppRange
            // possibly add user to this
        ]
        PFAnalytics.trackEvent(analyticsMetricTimeInApp, dimensions:dimensions)
        
        return true
    } else {
        return false
    }
}

func trackComposePost(text:String, date:NSDate) {
    let dimensions = [
        "textLengthRange": textLengthRange(countElements(text))
    ]
    PFAnalytics.trackEvent(analyticsMetricComposePost, dimensions:dimensions)
}

func trackComposeComment(text:String, date:NSDate) {
    let dimensions = [
        "textLengthRange": textLengthRange(countElements(text))
    ]
    PFAnalytics.trackEvent(analyticsMetricComposeComment, dimensions:dimensions)
}

// MARK: - Helpers

func textLengthRange(text:Int) -> String {
    switch text {
    case 0...10:
        return "0...10"
    case 10...20:
        return "10...20"
    case 20...40:
        return "20...40"
    case 40...60:
        return "40...60"
    default:
        return "60-140"
    }
}