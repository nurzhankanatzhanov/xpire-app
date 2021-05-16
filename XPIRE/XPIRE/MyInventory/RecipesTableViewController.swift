//
//  RecipesTableViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 4/23/21.
//

import UIKit

struct recipeUrl: Codable {
    let sourceUrl: String
}

class RecipesTableViewController: UITableViewController {
    
    var dataTask: URLSessionDataTask?
    let defaultSession = URLSession(configuration: .default)
    //let apiKey = "87748376c1524c648ede2073a7e02839"
    let apiKey = "a3670596dee640609c258bab0e9513a7"
    var results = [Recipe]()
    var recipeUrlResult: recipeUrl?
    var productName = String()
    @IBOutlet var loadingHeader: UIView!
    @IBOutlet var headerActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = nil
        fetchRepcipes(query: productName)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.count == 0 {
            tableView.setEmptyView(title: "", message: "Sorry, there are no recipes found for the provided ingredient.\nPlease try other ingredients!", titleColor: .black, msgColor: .black, bottomConstant: 200.0)
        } else {
            tableView.restore()
            headerActivityIndicator.stopAnimating()
        }
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        cell.nameLabel.text = results[indexPath.row].title
        // Configure the cell...

        return cell
    }
    
    func fetchRepcipes(query: String){
        tableView.tableHeaderView = loadingHeader
        headerActivityIndicator.startAnimating()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/findByIngredients/"
        let ingredientsQuery = URLQueryItem(name: "ingredients", value: query)
        let key = URLQueryItem(name: "apiKey", value: apiKey)
        let pantryOption =  URLQueryItem(name: "ignorePantry", value: "true")
        let rankOption =  URLQueryItem(name: "ignorePantry", value: "true")
        let numOfRecipes = URLQueryItem(name: "ranking", value: "1")
        
        urlComponents.queryItems = [ingredientsQuery, numOfRecipes, rankOption, pantryOption, key]
        
        guard let validateUrl = urlComponents.url else { return }

        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: validateUrl) {data, response, error in
            if let data = data {
                do {
                    self.results = try JSONDecoder().decode([Recipe].self, from: data)
                } catch let error {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.tableView.tableHeaderView = nil
                    self.headerActivityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    self.tableView.tableFooterView = UIView(frame: .zero)
                }
            }
        }

        dataTask?.resume()
    }
    
    func fetchRecipeUrl(id: String) -> Result<recipeUrl, NetworkError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/\(id)/information/"

        let key = URLQueryItem(name: "apiKey", value: apiKey)

        urlComponents.queryItems = [key]

        guard let validateUrl = urlComponents.url else { return .failure(.url) }
        var result: Result<recipeUrl, NetworkError>!
        let semaphore = DispatchSemaphore(value: 0)

        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: validateUrl) { data, response, error in
            if let data = data {
                do {
                    result = .success(try JSONDecoder().decode(recipeUrl.self, from: data))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            semaphore.signal()
        }
        dataTask?.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return result
    }
    
    func loadWebView(url: String){
        var formattedUrl: String!
        
        if url.contains("https"){
            formattedUrl = url
            
        }else{
            formattedUrl = "https" + url.dropFirst(4)
        }
        
        guard let url = URL(string: formattedUrl) else { return }
        let vc = ViewRecipeViewController(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let urlString = try fetchRecipeUrl(id: "\(results[indexPath.row].id)").get().sourceUrl
            loadWebView(url: urlString)
        }catch {
            print("no url found")
        }
    }
}
