//
//  MapImage.swift
//  MapVis
//
//  Created by Michael Redig on 2/1/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import UIKit

class MapImage {
	let jsonData: Data
	let rooms: RoomCollection
	let scale: CGFloat

	private lazy var ranges: (ClosedRange<CGFloat>, ClosedRange<CGFloat>) = {
		// sort x and y values
		let zero: CGFloat = 0
		let xRange = rooms.roomCoordinates.reduce(zero...zero) {
			let lower = min($0.lowerBound, $1.x)
			let upper = max($0.upperBound, $1.x)
			return lower...upper
		}
		let yRange = rooms.roomCoordinates.reduce(zero...zero) {
			let lower = min($0.lowerBound, $1.y)
			let upper = max($0.upperBound, $1.y)
			return lower...upper
		}
		return (xRange, yRange)
	}()

	private lazy var unscaledOffset: CGVector = {
		// find offset to normalize negative values to 0
		let (xRange, yRange) = ranges
		let xOffset = 0 - xRange.lowerBound
		let yOffset = 0 - yRange.lowerBound
		return CGVector(dx: xOffset, dy: yOffset)
	}()

	private lazy var unscaledSize: CGSize = {
		// find span between lowest and largest values
		let (xRange, yRange) = ranges
		let xSpan = (xRange.upperBound - xRange.lowerBound) + 1
		let ySpan = (yRange.upperBound - yRange.lowerBound) + 1 // add one because the point is in the bottom left corner of a node, which pushes the far upper and right nodes off if not compensated
		return CGSize(width: xSpan, height: ySpan)
	}()

	var imageSize: CGSize {
		unscaledSize * scale
	}

	init(jsonData: Data, scale: CGFloat) throws {
		self.jsonData = jsonData
		self.rooms = try JSONDecoder().decode(RoomCollection.self, from: jsonData)
		self.scale = scale
	}

	func generateOverworldMap() -> UIImage {
		let offset = unscaledOffset

		// create context and draw
		let renderer = UIGraphicsImageRenderer(size: imageSize)
		let image = renderer.image { context in
			// flip context vertical so drawing with origin in bottom left
			context.cgContext.translateBy(x: 0, y: imageSize.height)
			context.cgContext.scaleBy(x: 1, y: -1)

			for (_, room) in rooms.rooms {
				// offset room position so it fits with 0,0 as origin
				let unscaledPosition = CGPoint(x: room.position.x, y: room.position.y) + offset
				let color = room.position == .zero ? UIColor.red : UIColor.black
				color.setFill()
				let scaledPosition = unscaledPosition * scale
				// draw room
				context.cgContext.fillEllipse(in: CGRect(origin: scaledPosition, size: CGSize(width: scale, height: scale)))
				// fill in gaps between rooms
				if room.northRoomID != nil {
					let offset = CGVector(dx: 0, dy: scale / 2)
					let fillPoint = scaledPosition + offset
					let rect = CGRect(origin: fillPoint, size: CGSize(width: scale, height: scale / 2))
					context.fill(rect)
				}
				if room.southRoomID != nil {
					let offset = CGVector(dx: 0, dy: 0)
					let fillPoint = scaledPosition + offset
					let rect = CGRect(origin: fillPoint, size: CGSize(width: scale, height: scale / 2))
					context.cgContext.fill(rect)
				}
				if room.westRoomID != nil {
					let offset = CGVector(dx: 0, dy: 0)
					let fillPoint = scaledPosition + offset
					let rect = CGRect(origin: fillPoint, size: CGSize(width: scale / 2, height: scale))
					context.cgContext.fill(rect)
				}
				if room.eastRoomID != nil {
					let offset = CGVector(dx: scale / 2, dy: 0)
					let fillPoint = scaledPosition + offset
					let rect = CGRect(origin: fillPoint, size: CGSize(width: scale / 2, height: scale))
					context.cgContext.fill(rect)
				}
			}
		}
		return image
	}


}
