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
	}

	@IBAction func clearButtonPressed(_ sender: UIButton) {
		imageView.image = nil
	}
}

