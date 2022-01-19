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
    var movie: GhibliResponse?
    private var datasource: [People] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.textColor = .red
        titleLabel.text = movie?.title
        let url = URL(string: movie?.movie_banner ?? "https://static.boredpanda.com/blog/wp-content/uploads/2016/06/download-free-studio-ghibli-wallpapers-miyazaki-anime-27-5761220e70f13__880.jpg")
        if let url = url {
            bannerImage.kf.setImage(with:url)
        }
        
        directorLabel.text = "Director: \(movie?.director ?? "Inconu")"
        producerLabel.text = "Producer: \(movie?.producer ?? "Inconu")"
        
        descriptionLabel.textColor = .gray
        descriptionLabel.text = "Description: \(movie?.description ?? "Ghibli")"
        
        if (movie?.people?.first?.hasSuffix("/people/") == false) {
            peopleTable.dataSource = self
            peopleTable.delegate = self
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
                self?.datasource = actors
                self?.peopleTable.reloadData()
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
                    case .failure(let aferror) :
                    completion(nil)
                }
        }
        
    }

}

extension InfosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//Implémentation de l'interface UITableViewDataSource
extension InfosViewController: UITableViewDataSource {
    //Le nombre de lignes dans mon tableau
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let actor = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCellID", for: indexPath)
        cell.textLabel?.text = actor.name
        
        return cell
    }
}
