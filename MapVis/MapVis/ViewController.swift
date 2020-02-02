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

		guard let url = Bundle.main.url(forResource: "rooms100", withExtension: "json") else { return }

		do {
			let data = try Data(contentsOf: url)
			self.imageGen = try MapImage(jsonData: data, scale: 50)
		} catch {
			NSLog("Failed opening: \(error)")
			return
		}
	}

	@IBAction func renderButtonPressed(_ sender: UIButton) {
		imageView.image = imageGen?.generateImage()
	}

	@IBAction func clearButtonPressed(_ sender: UIButton) {
		imageView.image = nil
	}
}

