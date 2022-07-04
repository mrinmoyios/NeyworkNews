//
//  ViewController.swift
//  NewyorkNews
//
//  Created by Mrinmoy Sinha Mahapatra on 03/07/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate
{
    
    var responsedata : NewsResponseModel?
    @IBOutlet weak var newsOfNewyorkTable: UITableView!
    var webView: WKWebView!
    var loadingIndicator:UIActivityIndicatorView!
    let httpUtility = HttpUtility()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.navigationDelegate = self
        showLoader()
        httpUtility.getApiData(requestUrl: URL(string: NewsOfNewyork.mostPopularUrl)!, resultType: NewsResponseModel.self) { (employeeResult) in
            self.responsedata = employeeResult
            DispatchQueue.main.async { [weak self] in
                self?.newsOfNewyorkTable.reloadData()
                self?.hideLoader()
                
            }
        }
        
        newsOfNewyorkTable.dataSource = self
        newsOfNewyorkTable.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.responsedata?.results?.count ?? 0 > 0 {
            return responsedata?.results?.count ?? 0
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TableCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        if self.responsedata?.results?.count ?? 0 > 0 {
            if responsedata?.results?[indexPath.row].media?.count ?? 0 > 0 {
                cell.articleImage.loadFrom(URLAddress: responsedata?.results?[indexPath.row].media?[0].mediaMetadata?[0].url ?? "")
            }
            else {
                cell.articleImage.image = UIImage(named: "NewsPlaceholder")
            }
            cell.title.text = responsedata?.results?[indexPath.row].title
            cell.author.text = responsedata?.results?[indexPath.row].byline
            cell.abstract.text = responsedata?.results?[indexPath.row].abstract
            cell.dateOfArticle.text = responsedata?.results?[indexPath.row].publishedDate
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openWithWebView(url: responsedata?.results?[indexPath.row].url ?? "www.google.com")
    }
    
    private func openWithWebView(url:String){
        self.view = webView
        let url = URL(string: url)!
        webView.load(URLRequest(url: url))
    }
    
    func showLoader(){
        loadingIndicator = UIActivityIndicatorView(style:.large)
        loadingIndicator.color = .red
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
    }
    
    func hideLoader() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        hideLoader()
    }
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!)
    {
        //Start Progress indicator animation
        print("Start animation")
        showLoader()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoader()
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("webViewWebContentProcessDidTerminate")
    }
    
    
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
