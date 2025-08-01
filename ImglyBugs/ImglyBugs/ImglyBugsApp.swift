//
//  ImglyBugsApp.swift
//  ImglyBugs
//
//  Created by Hakim Gulam Ali on 01/08/25.
//
import SwiftfulRouting
import SwiftUI

@main
struct ImglyBugsApp: App {
	var body: some Scene {
		WindowGroup {
			RouterView { router in
				ContentView()
			}
		}
	}
}
