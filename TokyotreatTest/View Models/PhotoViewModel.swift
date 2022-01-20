//
//  PhotoViewModel.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import Foundation
import RxSwift
import RxCocoa

class PhotoViewModel {
    private let photoService: PhotoService
    private let disposeBag = DisposeBag()
    
    init(q: Driver<String>, page: Int, photoService: PhotoService) {
        self.photoService = photoService
        q
            .throttle(.milliseconds(300))
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (queryString) in
                self?.getBookItems(q: queryString, page: page)
                if queryString.isEmpty {
                    self?._items.accept([])
                    self?._info.accept("Search your favorite photos")
                }
            }).disposed(by: disposeBag)
    }
    
    private let _items = BehaviorRelay<[Photo]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _info = BehaviorRelay<String?>(value: nil)
    public var gridView: Bool = false
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var items: Driver<[Photo]> {
        return _items.asDriver()
    }
    
    var info: Driver<String?> {
        return _info.asDriver()
    }
    
    var hasInfo: Bool {
        return _info.value != nil
    }
    
    var numberOfItems: Int {
        return _items.value.count
    }
    
    func viewModelForPhoto(at index: Int) -> PhotoViewViewModel? {
        guard index < _items.value.count else {
            return nil
        }
        return PhotoViewViewModel(photo: _items.value[index])
    }
    
    func getBookItems(q: String?, page: Int) {
        guard let q = q, !q.isEmpty else {
            return
        }
        self._items.accept([])
        self._isFetching.accept(true)
        self._info.accept(nil)
        photoService.getItems(q: q, page: page) { result in
            switch result {
            case .success(let response):
                self._isFetching.accept(false)
                if response.items.count == 0 {
                    self._info.accept("No result for \(q)")
                }
                self._items.accept(response.items)
            case .failure(let error):
                self._isFetching.accept(false)
                self._info.accept(error.localizedDescription)
            }
        }
    }
}
