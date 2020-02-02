//
//  ViewController.swift
//  MapVis
//
//  Created by Michael Redig on 2/1/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var overlayImage: UIImageView!

	var currentRoom: Room? {
		imageGen?.currentRoom
	}

	var imageGen: MapImage?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		guard let url = Bundle.main.url(forResource: "rooms500", withExtension: "json") else { return }

		do {
			let data = try Data(contentsOf: url)
			self.imageGen = try MapImage(jsonData: data)
		} catch {
			NSLog("Failed opening: \(error)")
			return
		}

		guard let imageGen = imageGen else { return }
		let scale = view.frame.width / max(imageGen.unscaledSize.width, imageGen.unscaledSize.height)
		imageGen.scale = scale
	}

	@IBAction func renderButtonPressed(_ sender: UIButton) {
		imageView.image = imageGen?.generateOverworldMap()
		overlayImage.image = imageGen?.generateCurrentRoomOverlay()
	}

	@IBAction func clearButtonPressed(_ sender: UIButton) {
		imageView.image = nil
	}

	@IBAction func upButtonPressed(_ sender: UIButton) {
		guard let roomID = currentRoom?.northRoomID,
			let room = imageGen?.room(for: roomID) else { return }
		imageGen?.changeRoom(room: room)
		overlayImage.image = imageGen?.generateCurrentRoomOverlay()
	}

	@IBAction func downButtonPressed(_ sender: UIButton) {
		guard let roomID = currentRoom?.southRoomID,
			let room = imageGen?.room(for: roomID) else { return }
		imageGen?.changeRoom(room: room)
		overlayImage.image = imageGen?.generateCurrentRoomOverlay()
	}

	@IBAction func rightButtonPressed(_ sender: UIButton) {
		guard let roomID = currentRoom?.eastRoomID,
			let room = imageGen?.room(for: roomID) else { return }
		imageGen?.changeRoom(room: room)
		overlayImage.image = imageGen?.generateCurrentRoomOverlay()
	}

	@IBAction func leftButtonPressed(_ sender: UIButton) {
		guard let roomID = currentRoom?.westRoomID,
			let room = imageGen?.room(for: roomID) else { return }
		imageGen?.changeRoom(room: room)
		overlayImage.image = imageGen?.generateCurrentRoomOverlay()
	}


}

