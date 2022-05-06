import UIKit

class WebSocketDelegate: NSObject, URLSessionWebSocketDelegate {
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
    print("WebSocket open")
  }
  
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
    guard let theReason = String(data: reason!, encoding: .utf8) else { return }
    print("WebSocket closed with reason: \(theReason)")
  }
}

let url = URL(string: "wss://echo.websocket.org")

//Create instance from WebSocketDelegate
let delegate = WebSocketDelegate()

//Create instance URLSession
let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())

let task = session.webSocketTask(with: url!)
task.resume()    //start task

let hello = "Hell o from erem"
let message = URLSessionWebSocketTask.Message.string(hello)

//Send message with calling task.send
task.send(message) { error in
  if let error = error {
    print("WebSocket sending error: \(error)")
  }
  
  print("Sending message: \(hello)")
}

//Send ping to notify server if the app still active
task.sendPing { error in
  if let error = error {
    print("Ping failed: \(error)")
  }
  
  print("Send ping")
}

//Handler to receive return message from server
task.receive { result in
  switch result {
  case let .failure(error):
    print("Failed to receive message: \(error)")
  case let .success(message):
    switch message {
    case let .string(text):
      print("Receive text message: \(text)")
    case let .data(data):
      print("Receive binary message: \(data)")
    default:
      print("Message unformatted")
    }
  }
  
  //close server connection
  task.cancel(with: .goingAway, reason: "I'm AFK".data(using: .utf8))
}
