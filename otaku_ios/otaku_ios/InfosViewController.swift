//
//  InfosViewController.swift
//  otaku_ios
//
//  Created by EL FATHI LALAOUI on 18/01/2022.
//

import UIKit
import Alamofire
import SwiftUI

class InfosViewController: UIViewController {
    
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var peopleTable: UITableView!
    @IBOutlet weak var actorsItemHeight: NSLayoutConstraint!
    @IBOutlet weak var tradTitleLabel: UILabel!
    @IBOutlet weak var locationTable: UITableView!
    
    
    var movie: GhibliResponse?
    private var datasource: [People] = []
    private var datasourceL: [Location] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = movie?.original_title_romanised

        peopleTable.dataSource = self
        peopleTable.delegate = self
        
        locationTable.dataSource = self
        locationTable.delegate = self
        
        titleLabel.textColor = .red
        titleLabel.text = movie?.original_title
        tradTitleLabel.text = movie?.title
        
        let url = URL(string: movie?.movie_banner ?? "https://static.boredpanda.com/blog/wp-content/uploads/2016/06/download-free-studio-ghibli-wallpapers-miyazaki-anime-27-5761220e70f13__880.jpg")
        if let url = url {
            bannerImage.kf.setImage(with:url)
        }
        
        directorLabel.text = "Director: \(movie?.director ?? "Inconu")"
        
        producerLabel.text = "Producer: \(movie?.producer ?? "Inconu")"
        
        descriptionLabel.textColor = .gray
        descriptionLabel.text = "Description: \(movie?.description ?? "Ghibli")"
        
        if (movie?.people?.first?.hasSuffix("/people/") == false) {
            let taskGroup = DispatchGroup()
            var actors: [People] = []
            
            
            for url in movie?.people ?? [] {
                if let url = URL(string: url){
                    taskGroup.enter()
                    self.getPeople(url: url,withCompletion: { actor in
                        if let actor = actor {
                            actors.append(actor)
                        }
                        taskGroup.leave()
                    })
                }
            }
            
            
            taskGroup.notify(queue: .main) {[weak self] in
                //Tout est fini
                if let self = self {
                    self.datasource = actors
                    self.peopleTable.reloadData()
                    self.actorsItemHeight.constant = 80.0 * CGFloat(self.datasource.count)
                }
            }
        }
        
        
        if (movie?.locations?.first?.hasSuffix("/locations/") == false) {
            let taskGroup = DispatchGroup()
            var locations: [Location] = []
            for url in movie?.locations ?? [] {
                if let url = URL(string: url){
                    taskGroup.enter()
                    self.getLocation(url: url,withCompletion: { location in
                        if let location = location {
                            locations.append(location)
                        }
                        taskGroup.leave()
                    })
                }
            }
            
            
            taskGroup.notify(queue: .main) {[weak self] in
                //Tout est fini
                if let self = self {
                    self.datasourceL = locations
                    self.locationTable.reloadData()
                }
            }
        }
        
    }
    
    func getPeople(url: URL, withCompletion completion: @escaping (People?) -> Void){
        AF.request(url, method: .get, parameters: nil)
            .validate(statusCode: [200])
            .responseDecodable(of: People.self) { resp in
                switch resp.result {
                    case .success(let actor):
                        completion(actor)
                    case .failure(_) :
                        completion(nil)
                }
        }
        
    }
    
    
    func getLocation(url: URL, withCompletion completion: @escaping (Location?) -> Void){
        AF.request(url, method: .get, parameters: nil)
            .validate(statusCode: [200])
            .responseDecodable(of: Location.self) { resp in
                switch resp.result {
                    case .success(let location):
                        completion(location)
                    case .failure(_) :
                        completion(nil)
                }
            }
        }

}

extension InfosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//Implémentation de l'interface UITableViewDataSource
extension InfosViewController: UITableViewDataSource {
    //Le nombre de lignes dans mon tableau
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == peopleTable) {
            return datasource.count
        } else {
            return datasourceL.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == peopleTable) {
            let actor = datasource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCellID", for: indexPath) as? ActorTableViewCell
            cell?.titleLabel?.text = "Actor's Name"
            cell?.nameActorLabel?.text = actor.name
            cell?.nameActorLabel?.textColor = .red
            
            return cell ?? UITableViewCell()
        } else {
            let location = datasourceL[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationItems", for: indexPath) as? LocationTableViewCell
            cell?.titleLabel?.text = "Location's Name"
            cell?.NameLabel?.text = location.name
            
            return cell ?? UITableViewCell()
        }
    }
}
