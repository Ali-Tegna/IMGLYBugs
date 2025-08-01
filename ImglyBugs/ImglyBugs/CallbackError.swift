//
//  CallbackError.swift
//  ImglyBugs
//
//  Created by Hakim Gulam Ali on 01/08/25.
//


import _AVKit_SwiftUI
import AVFoundation
import IMGLYEngine
import IMGLYVideoEditor
import SwiftUI

enum CallbackError: Error {
	case unknownSceneMode
	case noScene
	case noPage
	case couldNotExport
}