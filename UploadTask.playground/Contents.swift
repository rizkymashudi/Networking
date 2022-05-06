import UIKit
import Foundation

let file = "Location/To/Your/File.mp4"
let url = URL(string: "https://api.dicoding.com/upload")

var request = URLRequest(url: url!)
request.httpMethod = "POST"
request.setValue(file.lastPathComponent, forHTTPHeaderField: "filename")

//URLSession Configuration
let config = URLSessionConfiguration.background(withIdentifier: "it.erem.upload")
config.isDiscretionary = false
config.networkServiceType = .video

let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
let task = session.uploadTask(with: request, fromFile: file)
task?.resume()
