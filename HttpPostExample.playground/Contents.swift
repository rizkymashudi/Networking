import UIKit
import Foundation


let apiKey = "29a458142f7f1f0541a21cbbc163fcce"

//Model
struct Guest: Codable {
  let success: Bool
  let guestSessionId: String
  
  enum CodingKeys: String, CodingKey {
    case success
    case guestSessionId = "guest_session_id"
  }
}

func getGuestSessionId(completion: ((Guest) -> ())?) {
  var components = URLComponents(string: "https://api.themoviedb.org/3/authentication/guest_session/new")!
  components.queryItems = [
    URLQueryItem(name: "api_key", value: apiKey),
  ]
  
  //create url request with param
  let request = URLRequest(url: components.url!)
  
  //create data task with sharedSession
  let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let response = response as? HTTPURLResponse, let data = data else { return }
    
    if response.statusCode == 200 {
      
      //Map result to model Guest
      let decoder = JSONDecoder()
      let response = try! decoder.decode(Guest.self, from: data)
      
      //assign response to completion
      completion?(response)
    } else {
      print("ERROR: \(data), HTTP Status: \(response.statusCode)")
    }
  }
  
  task.resume()
}

//Model
struct ReviewRequest: Codable {
  let value: Double
}

getGuestSessionId { guest in
  var components = URLComponents(string: "https://api.themoviedb.org/3/movie/339095/rating")!
  
  components.queryItems = [
    URLQueryItem(name: "api_key", value: apiKey),
    URLQueryItem(name: "guest_session_id", value: guest.guestSessionId),
  ]
  
  //create url request
  var request = URLRequest(url: components.url!)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  
  let reviewRequest = ReviewRequest(value: 8.5)
//  let jsonRequest = [
//    "value": 8.5
//  ]
  
  //convert dictionary into json
//  let jsonData = try! JSONSerialization.data(withJSONObject: jsonRequest, options: [])
  let jsonData = try! JSONEncoder().encode(reviewRequest)
  
  let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
    guard let response = response as? HTTPURLResponse, let data = data else { return }
    
    if response.statusCode == 201 {
      print("DATA: \(data)")
    }
  }
  
  task.resume()
}
