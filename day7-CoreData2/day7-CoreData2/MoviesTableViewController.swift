//
//  MoviesTableViewController.swift
//  day7-CoreData2
//
//  Created by Mina on 01/05/2024.
//

import UIKit
import CoreData
import Kingfisher
import Reachability
class MoviesTableViewController: UITableViewController {
    var allMovies = [Movie]()
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    var moviesArr: [NSManagedObject]!
    let reachability = try! Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    
        if reachability.connection == .unavailable {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDMovie")
            do {
                
                moviesArr = try managedContext.fetch(fetchRequest)
                for movie in moviesArr {
                    guard let title = movie.value(forKey: "title") as? String,
                          let releaseYear = movie.value(forKey: "releaseDate") as? String,
                          let voteCount = movie.value(forKey: "voteCount") as? Int32,
                          let genre = movie.value(forKey: "genre") as? String,
                          let img = movie.value(forKey: "image") as? Data
                    else {
                        return
                    }
                    
                    let moviee = Movie(title: title, genre: genre, releaseDate: releaseYear, voteCount: Int(voteCount), img: img)
                    allMovies.append(moviee)
                }
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            
        }
        else {
            deleteAllData(forEntity: "CDMovie")
            Service.shared.fetchData { [weak self] movies in
                self?.allMovies = movies!
                
                for movie in movies! {
                    let entity = NSEntityDescription.entity(forEntityName: "CDMovie", in: self!.managedContext)
                    let movieManagedObject = NSManagedObject(entity: entity!, insertInto: self!.managedContext)
                    
                    movieManagedObject.setValue(movie.originalTitle, forKey: "title")
                    movieManagedObject.setValue(movie.voteCount, forKey: "voteCount")
                    movieManagedObject.setValue(movie.releaseDate, forKey: "releaseDate")
                    movieManagedObject.setValue(genres[movie.genreIDS?[0] ?? 0], forKey: "genre")
                    var myString = "https://image.tmdb.org/t/p/w500/"
                    myString += movie.posterPath ?? ""
                    let url = URL(string: myString)
                    let imageV = UIImageView()
                    imageV.kf.setImage(with: url!){
                        result in
                        switch result {
                        case .success(let value):
                            
                            if let movieImage = imageV.image {
                                
                                movieManagedObject.setValue(movieImage.pngData(), forKey: "image")
                                do {
                                    try self!.managedContext.save()
                                    
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if reachability.connection == .unavailable {
            cell.textLabel?.text = allMovies[indexPath.row].title ?? ""
            cell.detailTextLabel?.text = allMovies[indexPath.row].releaseDate ?? ""
            cell.imageView?.image = UIImage(data:allMovies[indexPath.row].img!)
        }
        else {
            cell.textLabel?.text = allMovies[indexPath.row].originalTitle ?? ""
            cell.detailTextLabel?.text = allMovies[indexPath.row].releaseDate ?? ""
            var myString = "https://image.tmdb.org/t/p/w500/"
            myString += allMovies[indexPath.row].posterPath ?? ""
            let url = URL(string: myString)
            cell.imageView?.kf.setImage(with: url)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsViewController
        detailsVC.movie = allMovies[indexPath.row]
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func deleteAllData(forEntity entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try managedContext.execute(batchDeleteRequest)
        } catch{
            print(error.localizedDescription)
        }
    }
}
