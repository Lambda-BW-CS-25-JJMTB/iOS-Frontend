import Cocoa

// This won't access URLSessionWebSocketTask bc this project was done in the previous version of Xcode.  So it has to be cut paste and put into the latest Xcode


class SocketController {

	@available(iOS 13.0, *)
	open func webSocketTask(with url: URL) -> URLSessionWebSocketTask {

		let webSocketTask = URLSession.shared.webSocketTask(with: url)

		webSocketTask.resume()

		return webSocketTask
	}
}


let controller = SocketController()
let task = controller.webSocketTask(with: URL(string:"ws://127.0.0.1:8000/ws/rooms/")!)

func repete() {
	task.receive { result in
		switch result {
		case .failure(let error):
			print("Failed to get message: \(error)")
		case .success(let message):
			switch message {
			case .string(let text):
				switch text {
				case "playerIDReq":
					sendPlayerID(onTask: task)
				default:
					break
				}
			case .data(let data):
				print("got binary: \(data)")
			@unknown default:
				fatalError()
			}
			repete()
		}
	}
}

func sendPlayerID(onTask task: URLSessionWebSocketTask) {
	let id: [String : Any] = ["messageType": "playerID", "data": ["id": "1234"]]
	let data = try! JSONSerialization.data(withJSONObject: id, options: [])
	let string = String(data: data, encoding: .utf8)!
	let message = URLSessionWebSocketTask.Message.string(string)
	task.send(message) { error in
		if let error = error {
			print("Error sending id: \(error)")
		}
	}
}

repete()
