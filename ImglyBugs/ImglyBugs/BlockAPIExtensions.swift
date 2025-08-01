//
//  BlockAPIExtensions.swift
//  ImglyBugs
//
//  Created by Hakim Gulam Ali on 01/08/25.
//
import IMGLYEngine
import SwiftUI

extension BlockAPI {
	
	// This seems to be working
	func addTopSafeArea(for id: DesignBlockID, to parent: DesignBlockID) throws -> DesignBlockID {
		let block = try create(.graphic)
		let shape = try createShape(.rect)
		try setShape(block, shape: shape)
		let fill = try createFill(.color)
		
		try setFill(block, fill: fill)
		try setFillSolidColor(block, r: 0.12, g: 0.12, b: 0.12, a: 0.6)
		try setAlwaysOnTop(block, enabled: true)
		try setIncludedInExport(block, enabled: false)
		
		let width = try getWidth(id)
		let height = try getHeight(id)
		
		try setWidthMode(block, mode: .absolute)
		try setWidth(block, value: width)
		try setHeightMode(block, mode: .absolute)
		try setHeight(block, value: height / 6)
		try appendChild(to: parent, child: block)
		return block
	}
	
	//This does not work, it draws the block but its still aligned to the top of the screen.
	func addBottomSafeArea(for id: DesignBlockID, to parent: DesignBlockID) throws -> DesignBlockID {
		let block = try create(.graphic)
		let shape = try createShape(.rect)
		try setShape(block, shape: shape)
		let fill = try createFill(.color)
		
		try setFill(block, fill: fill)
		try setFillSolidColor(block, r: 0.12, g: 0.12, b: 0.12, a: 0.6)
		try setAlwaysOnBottom(block, enabled: true)
		try setIncludedInExport(block, enabled: false)
		
		let width = try getWidth(id)
		let height = try getHeight(id)
		
		try setWidthMode(block, mode: .absolute)
		try setWidth(block, value: width)
		try setHeightMode(block, mode: .absolute)
		try setHeight(block, value: height / 6)
		try appendChild(to: parent, child: block)
		return block
	}
}
