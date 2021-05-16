//
//  SearchProductViewController.swift
//  XPIRE
//
//  Created by Mando Quintana on 2/17/21.
//

import UIKit

class SearchProductViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var results = [Product]()
    var clickCount = 0
    
    @IBOutlet var searchResultsTableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchingIndicator.isHidden = true
        searchingIndicator.stopAnimating()
        searchResultsTableView.rowHeight = UITableView.automaticDimension
        searchResultsTableView.estimatedRowHeight = 600
        
        let backgroundImage  = getImageWithCustomColor(color: .clear, size: CGSize(width: searchResultsTableView.frame.width, height: 45))
        searchBar.setSearchFieldBackgroundImage(backgroundImage, for: .normal)
        
        searchResultsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getImageWithCustomColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if there are no results and the search button has been clicked on already
        if results.count == 0 && clickCount > 0 {
            tableView.setEmptyView(title: "😕 Sorry, no results came back.", message: "Please search for something else!", titleColor: UIColor.black, msgColor: UIColor.black, messageImage: #imageLiteral(resourceName: "up-arrow"))
        }
        // if there are no results and the search button has NOT been clicked on yet
        else if results.count == 0 && clickCount == 0 {
            tableView.setEmptyView(title: "Your search results will appear here!", message: "Please search for any food in the search bar above!", titleColor: UIColor.black, msgColor: UIColor.black, messageImage: #imageLiteral(resourceName: "up-arrow"))
        }
        // in any other case - restore the background and separator style of the TableView
        else {
            tableView.restore()
        }
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProductTableViewCell", for: indexPath) as! SearchProductTableViewCell
        cell.productName.text =  results[indexPath.row].name
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        fetchProduct(query: textField.text!)
        return true
    }
    
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        guard let searchQuery = searchBar.text else {return}
        fetchProduct(query: searchQuery)
        clickCount += 1
        self.view.endEditing(true)
    }
    
    func fetchProduct(query: String){
        searchingIndicator.isHidden = false
        searchingIndicator.startAnimating()
        searchResultsTableView.isHidden = true
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "shelf-life-api.herokuapp.com"
        urlComponents.path = "/search/"
        let productQuery = URLQueryItem(name: "q", value: query)
        urlComponents.queryItems = [productQuery]
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: urlComponents.url!) {data, response, error in
            if let data = data {
                do {
                    self.results = try JSONDecoder().decode([Product].self, from: data)
                } catch let error {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.searchingIndicator.isHidden = true
                    self.searchingIndicator.stopAnimating()
                    self.searchResultsTableView.isHidden = false
                    self.searchResultsTableView.reloadData()
                }
            }
        }
        dataTask?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetail"{
            let cell = sender as! UITableViewCell
            guard let indexPath = searchResultsTableView.indexPath(for: cell)?.row else {return}
            let selectedItem = results[indexPath]
            let view = segue.destination as! ItemDetailViewController
            view.item = selectedItem
        }
    }
}
