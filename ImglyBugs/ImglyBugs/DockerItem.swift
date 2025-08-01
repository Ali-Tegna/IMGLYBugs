//
//  DockerItem.swift
//  ImglyBugs
//
//  Created by Hakim Gulam Ali on 01/08/25.
//


import _AVKit_SwiftUI
import AVFoundation
import IMGLYEngine
import IMGLYVideoEditor
import SwiftUI

struct DockerItem: Dock.Item {
	var title: LocalizedStringKey
	var icon: String
	var action: (() -> Void)? = nil
	
	var id: EditorComponentID { "Dockitems.\(title)" }
	
	func body(_ context: Dock.Context) throws -> some View {
		Button(action: {
			action?()
		}) {
			VStack(spacing: 5) {
				Image(systemName: icon)
				Text(title)
					.font(Font.custom("Nunito", size: 14).weight(.bold))
					.foregroundColor(.white)
			}
			.padding(.horizontal, 26)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	func isVisible(_ context: Dock.Context) throws -> Bool {
		true
	}
}