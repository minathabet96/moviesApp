//
//  DetailsViewController.swift
//  day7-CoreData2
//
//  Created by Mina on 01/05/2024.
//

import UIKit
import Kingfisher
import Reachability
class DetailsViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var genreTxt: UILabel!
    @IBOutlet weak var releaseTxt: UILabel!
    @IBOutlet weak var ratingTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    var movie: Movie?
    let reachability = try! Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if reachability.connection == .unavailable {
            titleTxt.text = movie?.title
            ratingTxt.text = String(movie?.voteCount ?? 0)
            releaseTxt.text = movie?.releaseDate
            genreTxt.text = movie?.genre ?? "genre"
            movieImageView.image = UIImage(data: movie!.img!)
        }
        else {
            titleTxt.text = movie?.originalTitle
            ratingTxt.text = String(movie?.voteCount ?? 0)
            releaseTxt.text = movie?.releaseDate
            genreTxt.text = genres[movie?.genreIDS?[0] ?? 0]
            var myString = "https://image.tmdb.org/t/p/w500/"
            myString += movie?.posterPath ?? ""
            let url = URL(string: myString)
            movieImageView.kf.setImage(with: url)

        }
    }
}
