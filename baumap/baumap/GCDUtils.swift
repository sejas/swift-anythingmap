//
//  GCDUtils.swift
//  baumap
//
//  Created by Antonio Sejas on 15/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
