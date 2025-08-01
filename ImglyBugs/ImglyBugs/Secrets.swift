//
//  Secrets.swift
//  ImglyBugs
//
//  Created by Hakim Gulam Ali on 01/08/25.
//


import _AVKit_SwiftUI
import AVFoundation
import IMGLYEngine
import IMGLYVideoEditor
import SwiftUI

enum Secrets {
	static let ImglyLicenseKey: String = ""// Replace with your actual Imgly license key
	static let UserId: String = "test_user"
	static let Settings: EngineSettings = .init(license: ImglyLicenseKey, userID: UserId)
}
