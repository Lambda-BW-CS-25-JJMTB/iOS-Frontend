//
//  MapImage.swift
//  MapVis
//
//  Created by Michael Redig on 2/1/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import UIKit

class MapImage {
//	let image: UIImage?

	let jsonData: Data
	let rooms: RoomCollection
	let scale: CGFloat

	init(jsonData: Data, scale: CGFloat) throws {
		self.jsonData = jsonData
		self.rooms = try JSONDecoder().decode(RoomCollection.self, from: jsonData)
		self.scale = scale
	}

	func generateImage() -> UIImage {
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

		// find offset to normalize negative values to 0
		let xOffset = 0 - xRange.lowerBound
		let yOffset = 0 - yRange.lowerBound
		let offset = CGVector(dx: xOffset, dy: yOffset)

		// find span between lowest and largest values
		let xSpan = (xRange.upperBound - xRange.lowerBound) + 1
		let ySpan = (yRange.upperBound - yRange.lowerBound) + 1

		// create context and draw
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: xSpan, height: ySpan) * scale)
		let image = renderer.image { context in
			// flip context vertical so drawing with origin in bottom left
			context.cgContext.translateBy(x: 0, y: ySpan * scale)
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
