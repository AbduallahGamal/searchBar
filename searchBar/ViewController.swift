//
//  ViewController.swift
//  searchBar
//
//  Created by Abdalla on 9/21/19.
//  Copyright © 2019 edu.data. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ListLanguages: [LanguagesModel] = []
    var searchListLanguages: [LanguagesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        getData()
        setUpSearchBar()
    }
    
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func getData(){
        NetworkManager().getDataFromServer(path: "lang/ar", callback:{ data in
            do{
                let jsonDecoder = JSONDecoder()
                let jsonData = try jsonDecoder.decode([LanguagesModel].self, from: data)
                self.ListLanguages = jsonData
                self.searchListLanguages = self.ListLanguages
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            }catch{
                print(error)
            }
        })
    }
}

class cellTableView: UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vieew: UIView!
}

//MARK:- Handlers

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellTableView
        
        let language = searchListLanguages[indexPath.row]
        cell.lblName.text = language.name
        
        
        // making of star rating
        let cosmosView: CosmosView = {
            let view = CosmosView()
            //view.settings.updateOnTouch = false
            view.settings.filledImage = UIImage(named: "filled")?.withRenderingMode(.alwaysOriginal)
            view.settings.emptyImage = UIImage(named: "empty")?.withRenderingMode(.alwaysOriginal)
            view.settings.totalStars = 7
            view.settings.starSize = 25
            view.settings.starMargin = 4
            view.settings.fillMode = .precise
            return view
        }()
        cell.vieew.addSubview(cosmosView)
        cosmosView.centerInSuperview()
        cosmosView.didTouchCosmos = { rating in
            print("Rated: \(rating)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            searchListLanguages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchListLanguages  = ListLanguages;
            tableView.reloadData()
            return
        }
        searchListLanguages = ListLanguages.filter({langg -> Bool in
            (langg.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }

}

//MARK:- Model

struct LanguagesModel: Codable {
    
    var name: String?
}

