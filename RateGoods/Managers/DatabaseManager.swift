//
//  Database.swift
//  RateGoods
//
//  Created by Vadim on 12/21/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol SnapshotProtocol {
    var key: String { get }
    var ref: DatabaseReference { get }
    init?(snapshot: DataSnapshot)
    func toAny() -> Any
}

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var ref: DatabaseReference!
    lazy var mapstyle = ref.child(Constants.Database.mapStyle)
    lazy var storeRef = ref.child(Constants.Database.stores)
    lazy var usersRef = ref.child(Constants.Database.users)
    
    init() {
        ref = Database.database().reference()
    }
    
    func loadMapStyle(completion: @escaping (Result<String?>) -> Void) {
        mapstyle.observeSingleEvent(of: .value, with: { snapshot in
            do {
                let style = try self.jsonToString(json: snapshot.value as Any)
                completion(.success(style))
            } catch {
                completion(.failure(error))
            }
        }, withCancel: { error in
            completion(.failure(error))
        })
    }
    
    private func jsonToString(json: Any) throws -> String? {
        do {
            let data =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let convertedString = String(data: data, encoding: .utf8)
            return convertedString
        } catch {
            throw error
        }
    }
    
    func uploadData(to itemRef: DatabaseReference, data: Any, completion: (() -> Void)? = nil) {
        itemRef.setValue(data)
        completion?()
    }
    
    func loadDataSingleEvent<T: SnapshotProtocol>(from itemRef: DatabaseReference, completion: @escaping (Result<[T]?>) -> Void) {
        itemRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            let items: [T] = self?.getItems(from: snapshot) ?? [T]()
            completion(.success(items))
        }, withCancel: { error in
            completion(.failure(error))
        })
    }
    
    func loadDataEvent<T: SnapshotProtocol>(from itemRef: DatabaseReference, completion: @escaping (Result<[T]?>) -> Void) {
        itemRef.observe(.value, with: { [weak self] snapshot in
            let items: [T] = self?.getItems(from: snapshot) ?? [T]()
            completion(.success(items))
        }, withCancel: { error in
            completion(.failure(error))
        })
    }
    
    private func getItems<T: SnapshotProtocol>(from snapshot: DataSnapshot) -> [T] {
        return snapshot.children.compactMap({ $0 as? DataSnapshot }).compactMap({ T(snapshot: $0) })
    }
    
    func getGoods(with name: String, completion: @escaping (Result<[Goods]?>) -> Void) {
        loadDataSingleEvent(from: storeRef) { (result: Result<[Store]?>) in
            switch result {
            case .success(let stores):
                var filteredGoods = [Goods]()
                guard let stores = stores else {
                    completion(.success(nil))
                    return
                }
                let dispatchGroup = DispatchGroup()
                stores.forEach {
                    dispatchGroup.enter()
                    let goodsRef = $0.ref.child(Constants.Database.goods)
                    self.loadDataSingleEvent(from: goodsRef, completion: { (result: Result<[Goods]?>) in
                        switch result {
                        case .success(let goods):
                            guard let goods = goods else {
                                completion(.success(nil))
                                return
                            }
                            filteredGoods.append(contentsOf: goods.filter { $0.title == name })
                        case .failure(let error):
                            completion(.failure(error))
                        }
                        dispatchGroup.leave()
                    })
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success(filteredGoods))
                }
            case .failure(let erorr):
                completion(.failure(erorr))
            }
        }
    }
}
