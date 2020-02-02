//
//  ViewController.swift
//  MapVis
//
//  Created by Michael Redig on 2/1/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		guard let url = Bundle.main.url(forResource: "rooms500", withExtension: "json") else { return }

		let data: Data
		do {
			data = try Data(contentsOf: url)
		} catch {
			NSLog("Failed opening: \(error)")
			return
		}

		let rooms: RoomCollection
		do {
			rooms = try JSONDecoder().decode(RoomCollection.self, from: data)
		} catch {
			NSLog("failed decoding: \(error)")
			return
		}
		print(rooms)
	}


}

