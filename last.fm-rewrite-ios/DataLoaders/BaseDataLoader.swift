//
//  BaseDataLoader.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 04.04.2022..
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import ProgressHUD


class BaseDataLoader<Item>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    let disposeBag = DisposeBag()
    var request: Cancellable?
    var items: BehaviorRelay<[Item]> = BehaviorRelay.init(value: [Item]())
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    var errorOccured:((Bool) -> Void)?
    weak var collectionView: UICollectionView?
    var didSelect:((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: Item) -> Void)?

    
    var baseCellIdentifier: String {
        return "BaseCellIdentifier"
    }
    
    var loadingCellIdentifier: String {
        return "LoadingCellIdentifier"
    }
    
    required override init() {
        super.init()
        
        items.subscribe(onNext: { [weak self] (_) in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }).disposed(by: disposeBag)
        
    }

    //MARK: - UICollectionView Setup
    
    func setupCollectionView(collectionView: UICollectionView) {
        self.collectionView = collectionView
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.nib, forCellWithReuseIdentifier: baseCellIdentifier)
    }
    
    //MARK: - UICollectionViewDataSource
    
    func configCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        
    }
    
    func item(indexPath: IndexPath) -> Item {
        return items.value[indexPath.item]
    }
    
    func cellIdentifier(indexPath: IndexPath) -> String {
        return baseCellIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cellID = cellIdentifier(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.value.isEmpty ? 1 : items.value.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let callback = didSelect {
            callback(collectionView, indexPath, item(indexPath: indexPath))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    //MARK: - UICollectionDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = (collectionView.frame.width - 2)  / 2
        return CGSize(width: size, height: size)
    }
    
    //MARK: - Items Loading
    
    func loadItems(isPagging: Bool) {
    }
    
    func onPagination(indexPath: IndexPath) {
       
    }
    
}
