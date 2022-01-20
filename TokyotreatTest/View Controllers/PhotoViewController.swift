//
//  PhotoViewController.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var viewModel: PhotoViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let searchBar = self.navigationItem.searchController!.searchBar
        viewModel = PhotoViewModel(q: searchBar.rx.text.orEmpty.asDriver(), page: 1, photoService: PhotoStore.shared)
        
        viewModel.items.drive(onNext: {[unowned self] (_) in
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.isFetching.drive(activityIndicatorView.rx.isAnimating).disposed(by: disposeBag)
        
        viewModel.info.drive(onNext: {[unowned self] (info) in
            self.infoLabel.isHidden = !self.viewModel.hasInfo
            self.infoLabel.text = info
        }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        setupColletionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setTintColor(.black)
        navigationController?.backgroundColor(.white)
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.searchBar.scopeButtonTitles = ["List", "Grid"]
        navigationItem.searchController?.searchBar.showsScopeBar = true
        navigationItem.searchController?.searchBar.delegate = self
        
        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func setupColletionView() {
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.backgroundView = UIView.init(frame: CGRect.zero)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 1 {
            viewModel.gridView = true
        } else {
            viewModel.gridView = false
        }
        collectionView.reloadData()
    }
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.gridView == false ? CGSize(width: collectionView.frame.width - 20.0, height: 220.0) : CGSize(width: collectionView.frame.width / 2 - 20.0, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if let viewModel = viewModel.viewModelForPhoto(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = viewModel.viewModelForPhoto(at: indexPath.row) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPhotoViewController") as! DetailPhotoViewController
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
