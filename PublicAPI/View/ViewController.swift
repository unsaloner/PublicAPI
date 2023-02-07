//
//  ViewController.swift
//  PublicAPI
//
//  Created by Unsal Oner on 7.02.2023.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    
    var viewModel = ViewModel()
    
    var listViewModel = [ViewListModel]()
    
    let refreshControl = UIRefreshControl()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"image3")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
// MARK: SEARCH BAR
    lazy var searchBar : UISearchBar = {
        let s = UISearchBar()
            s.placeholder = "Search Timeline"
            s.delegate = self
            s.tintColor = .white
        s.barTintColor = .white
            s.barStyle = .default
            s.sizeToFit()
        return s
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchBar.delegate = self
//        Search bar'ı her zaman görünür yap.
        navigationItem.hidesSearchBarWhenScrolling = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundView = imageView
//    MARK: GET APIs
        viewModel.fetchAPI { api in
            if let api = api {
                self.listViewModel = api.entries.map({ViewListModel(apis: $0)})
                
                DispatchQueue.main.async {
                    self.collection.reloadData()
                   
                }
            }
        }
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: "cell")
        collection.register(UICollectionViewCell.self, forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collection.addSubview(refreshControl)
    }
    
    
//    MARK: SEARCH BAR DELEGATE
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchBar.resignFirstResponder()
        
        if searchText.isEmpty {
            viewModel.fetchAPI { api in
                if let api = api {
                    self.listViewModel = (api.entries.map({ViewListModel(apis: $0)}))
                    DispatchQueue.main.async {
                        self.collection.reloadData()
                    }
                }
               
            }
        }else {
            listViewModel = listViewModel.filter({
                    return $0.api.lowercased().contains(searchText.lowercased()) ||
                        $0.link.lowercased().contains(searchText.lowercased()) ||
                        $0.description.lowercased().contains(searchText.lowercased())
                })
        }
        collection.reloadData()
    }
    
//    MARK: REFRESH DATA
    
    @objc func refreshData(){
        
        viewModel.fetchAPI { api in
            if let api = api {
                self.listViewModel = api.entries.map({ViewListModel(apis: $0)})
                
                DispatchQueue.main.async {
                    self.collection.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
}

// MARK: COLLECTION VIEW DELEGATE & DATA SOURCE

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return listViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let apiViewModel = listViewModel[indexPath.item]
        cell.apiLabel.text = "API: " + apiViewModel.api
        cell.linkLabel.text = "Link: " + apiViewModel.link
        cell.descriptionLabel.text = "Description: " + apiViewModel.description
        cell.isHttpsLabel.text = "isHTTPS: " + String(apiViewModel.isHttps)
        cell.backgroundView = imageView
        
        return cell
        
    }
//    MARK: ADD SEARCH BAR TO COLLECTION VIEW'S HEADER
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
                header.addSubview(searchBar)
                searchBar.translatesAutoresizingMaskIntoConstraints = false
                searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
                searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
                searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
                searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        
        return header
    }
    
}
