//
//  AnyRouterExtensions.swift
//  ImglyBugs
//
//  Created by Hakim Gulam Ali on 01/08/25.
//
import Foundation
import SwiftfulRouting
import SwiftUI

extension AnyRouter {
	@MainActor func navigateToVideoPreview(url: URL){
		self.showScreen(.push) { _ in
			VideoEditorView(videoUrl: url)
		}
	}
	
	@MainActor func navigateToNextPage(){
		self.showScreen(.push) { _ in
			GoBackView()
		}
	}
}
