//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Hayley Robinson on 2/18/21.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4 //controls space bewteen rows
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3 //width changes with dfiiff phones
        layout.itemSize = CGSize(width: width, height: width * 3/2) //want height to be taller than width for poster size
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/464052/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
               if let error = error
               {
                  print(error.localizedDescription)
               }
               else if let data = data
               {
                  let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                  // TODO: Get the array of movies
                  // TODO: Store the movies in a property to use elsewhere
                  // TODO: Reload your table view data
            
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            self.collectionView.reloadData() //now it has 20 movies to display
                print(self.movies)
            
        
           }
        }
        task.resume()
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
       
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        
        cell.posterView.af_setImage(withURL: posterUrl)
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        let cell = sender as! UICollectionViewCell //sender is collection view cell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row] //acess movies array
        
        
        // Pass the selected movie to the new view controller.
        let detailCollectionController = segue.destination as! PosterController
        detailCollectionController.movie = movie
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    

}
