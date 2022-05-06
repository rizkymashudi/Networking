import UIKit

let path = "https://www.dicoding.com/blog/wp-content/uploads/2017/10/dicoding-logo-square.png"
let url = URL(string: path)

//configuration defaultSession
let configuration = URLSessionConfiguration.default
configuration.waitsForConnectivity = true  //wait for connection before execute task
configuration.timeoutIntervalForRequest = 30
configuration.timeoutIntervalForResource = 30
configuration.allowsCellularAccess = true  //accessing cellular packet data

//initialize URLSession
let session = URLSession(configuration: configuration)

//create dataTask
let downloadTask: URLSessionDataTask = session.dataTask(with: url!) { data, response, error in
  guard let data = data else { return }
  let image = UIImage(data: data)
  print(image)
}

downloadTask.resume()

