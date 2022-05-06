import UIKit

let apiKey = "29a458142f7f1f0541a21cbbc163fcce"
let language = "en-US"
let page = "1"

var components = URLComponents(string: "https://api.themoviedb.org/3/movie/popular")!
components.queryItems = [
  URLQueryItem(name: "api_key", value: apiKey),
  URLQueryItem(name: "language", value: language),
  URLQueryItem(name: "page", value: page),
]

//create url request
let request = URLRequest(url: components.url!)

//create shared session type
let task = URLSession.shared.dataTask(with: request) { data, response, error in
  guard let response = response as? HTTPURLResponse else { return }
  
  if let data = data {
    //load data
    if response.statusCode == 200 {
      print("Data: \(data)")
    } else {
      print("ERROR: \(data), Http Status: \(response.statusCode)")
    }
  }
}

task.resume()
