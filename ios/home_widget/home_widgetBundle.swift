//
//  home_widgetBundle.swift
//  home_widget
//
//  Created by Matthew Trent on 2023-09-03.
//  Copyright © 2023 I. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct home_widgetBundle: WidgetBundle {
    var body: some Widget {
        YourWidget() // This is the correct name
        home_widgetLiveActivity() // Assuming this is another widget you have defined
    }
}
