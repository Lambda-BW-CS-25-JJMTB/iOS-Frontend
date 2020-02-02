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
		let xSpan = xRange.upperBound - xRange.lowerBound
		let ySpan = yRange.upperBound - yRange.lowerBound

		// create context and draw
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: xSpan, height: ySpan) * scale)
		let image = renderer.image { context in
			// flip context vertical so drawing with origin in bottom left
			context.cgContext.translateBy(x: 0, y: ySpan * scale)
			context.cgContext.scaleBy(x: 1, y: -1)

//			context.cgContext.clear(renderer.format.bounds)

//			UIColor.red.setFill()
//			context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: CGSize(width: scale, height: scale)))

			for (_, room) in rooms.rooms {
				let unscaledPosition = CGPoint(x: room.position.x, y: room.position.y) + offset
				let color = unscaledPosition == .zero ? UIColor.red : UIColor.black
				color.setFill()
				let scaledPosition = unscaledPosition * scale
				context.cgContext.fillEllipse(in: CGRect(origin: scaledPosition, size: CGSize(width: scale, height: scale)))
			}


		}
		return image
	}


}
