//
//  ViewController.swift
//  imdb5
//
//  Created by Aigul Buketova on 17.03.2024.
//

import UIKit

class ViewController: UIViewController {

    var  movie:[Result] = []
    let  urlString:String = "https://api.themoviedb.org"
    let apiKey:String = "e516e695b99f3043f08979ed2241b3db"
    let urlPath = "/3/movie/now_playing"
    
    private var movieTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        apiRequest()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
    }
    
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(movieTableView)
        movieTableView
    }
    
    func apiRequest()
    {
       
        let session = URLSession(configuration: .default)
       lazy var urlComponents: URLComponents = {
                var components = URLComponents()
                components.scheme = "https"
                components.host = "api.themoviedb.org"
                components.queryItems = [
                    URLQueryItem(name: "api_key", value: apiKey)
                ]
                return components
            }()
        var components = urlComponents
         components.path = "/3/movie/now_playing"
        guard let requestUrl = components.url else {
                    return
                }
        let task = session.dataTask(with: requestUrl) { data, response, error in
            guard let data = data else {return}
            if let movie = try? JSONDecoder().decode(Movie.self, from: data)
            {
                DispatchQueue.main.async {
                    self.movie = movie.results
                        self.movieTableView.reloadData()
                }
                
            }
        }
        task.resume()
       
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.labelMovie.text = movie[indexPath.row].title
        let urlString = "https://image.tmdb.org/t/p/w200"+(movie[indexPath.row].posterPath )
        let url = URL(string:urlString)!
        
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.imageMovie.image = UIImage(data: data)
                        
    }
    
            }
        }
        
        return cell
    }
    
}
