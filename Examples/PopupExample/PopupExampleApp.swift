//
//  PopupExampleApp.swift
//  PopupExample
//
//  Created by 伊藤紀一 on 2023/08/04.
//

import ComposableArchitecture
import SwiftUI

@main
struct PopupExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: Content.State()) {
                    Content()
                }
            )
        }
    }
}
