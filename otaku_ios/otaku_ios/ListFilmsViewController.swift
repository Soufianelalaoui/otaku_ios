//
//  ListFilmsViewController.swift
//  otaku_ios
//
//  Created by EL FATHI LALAOUI on 18/01/2022.
//

import UIKit
import Kingfisher
import Alamofire

class ListFilmsViewController: UIViewController {

    @IBOutlet weak var filmsTable: UITableView!
    private var datasource: [GhibliResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Otaku"
        
        filmsTable.dataSource = self
        filmsTable.delegate = self
        
        
        //Automatic dimension
        filmsTable.rowHeight = UITableView.automaticDimension
        
        self.loadGhibliFilms()
    }
    
    private func loadGhibliFilms() {
        AF.request("https://ghibliapi.herokuapp.com/films/", method: .get, parameters: nil)
            .validate(statusCode: [200])
            .responseDecodable(of: [GhibliResponse].self) {resp in
                switch resp.result {
                    case .success(let ghibliResponses):
                    self.datasource = ghibliResponses
                    self.filmsTable.reloadData()
                    case .failure(let aferror) :
                        print(aferror.localizedDescription)
            }
        }
    }
}

extension ListFilmsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FILMINFOS") as? InfosViewController
        vc?.movie = datasource[indexPath.row]
        
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//Implémentation de l'interface UITableViewDataSource
extension ListFilmsViewController: UITableViewDataSource {
    //Le nombre de lignes dans mon tableau
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    //Le nombre de sections dans mon tableau
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Mon tableau me demande (car je (self) suis le "delegate") la cellule à afficher à l'index donné
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movies = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmItem", for: indexPath) as? FilmTableViewCell
        cell?.titleLabel?.text = movies.title
        cell?.titleNameLabel?.text = movies.original_title
        let url = URL(string: movies.image ?? "https://static.boredpanda.com/blog/wp-content/uploads/2016/06/download-free-studio-ghibli-wallpapers-miyazaki-anime-27-5761220e70f13__880.jpg")
        if let url = url {
            cell?.filmImage?.kf.setImage(with:url)
        }
        
        return cell ?? UITableViewCell()
    }
    
    
}
