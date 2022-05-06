import UIKit
import Foundation

//Model
struct Movies: Codable {
  let page: Int
  let totalResults: Int
  let totalPages: Int
  
  let movies: [Movie]
  
  //manual mapping with Codingkeys
  enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case totalPages = "total_pages"
    
    case movies = "results"
  }
}

struct Movie: Codable {
  let popularity: Double
  let posterPath: String
  let title: String
  let genres: [Int]
  let voteAverage: Double
  let overview: String
  let releaseDate: Date
  
  //Manual mapping
  enum CodingKeys: String, CodingKey {
    case popularity
    case posterPath = "poster_path"
    case title
    case genres = "genre_ids"
    case voteAverage = "vote_average"
    case overview
    case releaseDate = "release_date"
  }
  
  //Custom Mapping
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)     //Initialize container using key from Codingkeys
    let path = try container.decode(String.self, forKey: .posterPath)   //Decode from .posterPath
    
    //decode value from .releaseDate, convert from string to Date
    let dateString = try container.decode(String.self, forKey: .releaseDate)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString)!
    
    popularity = try container.decode(Double.self, forKey: .popularity)
    posterPath = "https://image.tmdb.org/t/p/w300\(path)"
    
    //Decode value title, genres, voteAvg, and overvoew
    title = try container.decode(String.self, forKey: .title)
    genres = try container.decode([Int].self, forKey: .genres)
    voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    overview = try container.decode(String.self, forKey: .overview)
    
    releaseDate = date
    
  }
}


// ===================== Main CODE ========================= //

let apiKey = "29a458142f7f1f0541a21cbbc163fcce"
let language = "en-US"
let page = "1"

var components = URLComponents(string: "https://api.themoviedb.org/3/movie/popular")!
components.queryItems = [
  URLQueryItem(name: "api_key", value: apiKey),
  URLQueryItem(name: "language", value: language),
  URLQueryItem(name: "page", value: page)
]

let request = URLRequest(url: components.url!)
let task = URLSession.shared.dataTask(with: request) { data, response, error in
  guard let response = response as? HTTPURLResponse, let data = data else { return }
  
  if response.statusCode == 200 {
    decodeJSON(data: data)
  } else {
    print("ERROR: \(data), HTTP Status: \(response.statusCode)")
  }
}

task.resume()


//decode JSON to object model
private func decodeJSON(data: Data) {
  let decoder = JSONDecoder()
  
  if let movies = try? decoder.decode(Movies.self, from: data) as Movies {
    print("PAGE: \(movies.page)")
    print("TOTAL RESULTS: \(movies.totalResults)")
    print("TOTAL PAGES: \(movies.totalPages)")
    
    //get data from each arrau object
    movies.movies.forEach { movie in
      print("TITLE: \(movie.title)")
      print("POSTER: \(movie.posterPath)")
      print("DATE: \(movie.releaseDate)")
    }
  } else {
    print("ERROR: Can't Decode JSON")
  }
  
}
