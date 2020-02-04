//
//  ViewController.swift
//  websocket test
//
//  Created by Michael Redig on 2/2/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import UIKit

import SocketIO

class ViewController: UIViewController {
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var sendButton: UIButton!

	let manager = SocketManager(socketURL: URL(string: "https://echo.websocket.org")!, config: [.log(true), .compress])
	var socket: SocketIOClient?

	override func viewDidLoad() {
		super.viewDidLoad()

		socket = manager.defaultSocket
		print(socket)

		// Do any additional setup after loading the view.

		socket?.onAny({ socketEvent in
			print(socketEvent.event, socketEvent.items)
		})
	}

	@IBAction func sendButtonPressed(_ sender: UIButton) {
		guard let text = textField.text, !text.isEmpty else { return }
		print("sending: \(text)")

		socket?.emit("test", with: [text])
	}

}

