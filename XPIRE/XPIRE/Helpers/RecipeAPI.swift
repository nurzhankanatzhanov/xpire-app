//
//  RecipeAPI.swift
//  XPIRE
//
//  Created by Nurzhan Kanatzhanov on 3/25/21.
//

import Foundation

public struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let likes: Int
}

// network error enum for API call
public enum NetworkError: Error {
    case url
    case server
}

// Spoonacular API testing for recipes with given ingredients
//https://michaellong.medium.com/how-to-chain-api-calls-using-swift-5s-new-result-type-and-gcd-56025b51033c
public func getListOfRecipes(query: String) -> Result<[Recipe], NetworkError> {
    // apiKey for Spoonacular API
    let apiKey = "87748376c1524c648ede2073a7e02839"

    // ingredient search main URL part
    let urlString = "https://api.spoonacular.com/recipes/findByIngredients?ingredients"
    
    let fullURL = "\(urlString)=\(query)&number=5&ranking=1&ignorePantry=true&apiKey=\(apiKey)"
    
    // add space encoding if there's a space in the fullURL
    let formattedURL = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? fullURL
    
    // GET Request URL
    guard let url = URL(string: formattedURL) else {
        return .failure(.url)
    }
    
    var results: Result<[Recipe], NetworkError>!
    
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    request.httpMethod = "GET"
    
    // assigning the result of an asynchronous call in a synchronous manner
    let semaphore = DispatchSemaphore(value: 0)

    URLSession.shared.dataTask(with: request) {data, response, error in
        if let data = data {
            do {
                results = .success(try JSONDecoder().decode([Recipe].self, from: data))
            } catch let error {
                print(error)
            }
        }
        semaphore.signal()
    }.resume()
    
    _ = semaphore.wait(wallTimeout: .distantFuture)
    
    return results
}

