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

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		guard let url = Bundle.main.url(forResource: "rooms100", withExtension: "json") else { return }

		let imageGen: MapImage
		do {
			let data = try Data(contentsOf: url)
			imageGen = try MapImage(jsonData: data, scale: 50)
		} catch {
			NSLog("Failed opening: \(error)")
			return
		}

//		let image = imageGen.generateImage()
		imageView.image = imageGen.generateImage()

	}


}

