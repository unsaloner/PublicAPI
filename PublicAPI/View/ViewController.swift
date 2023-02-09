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
            s.placeholder = "Search APIs"
            s.delegate = self
        s.searchBarStyle = .prominent
        s.barTintColor = .white
        s.barStyle = .default
        s.sizeToFit()
        return s
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundView = imageView

        getData()
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: "cell")
        collection.register(UICollectionViewCell.self, forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collection.addSubview(refreshControl)
    }
    
    //    MARK: SEARCH BAR DELEGATE
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            getData()
        }else {
            listViewModel = listViewModel.filter({
                    return $0.api.lowercased().contains(searchText.lowercased())
                })
        }
        collection.reloadData()
    }
    
    
//    MARK: - GET DATA
    func getData(){
        viewModel.fetchAPI { api in
            if let api = api {
                self.listViewModel = (api.entries.map({ViewListModel(apis: $0)}))
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            }
           
        }
    }

    
//    MARK: - REFRESH DATA
    
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
        
        return cell
        
    }
//    MARK: ADD SEARCH BAR TO COLLECTION VIEW'S HEADER
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        header.addSubview(searchBar)
        return header
    }
    
//    If the user scrolls the search bar also scrolls with it.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.addSubview(searchBar)
        searchBar.frame = CGRect(x: 0, y:scrollView.contentOffset.y, width: view.frame.width, height: searchBar.frame.height)
//        print(searchBar.frame)
        
    }

    
}
