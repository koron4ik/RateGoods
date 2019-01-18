//
//  Database.swift
//  RateGoods
//
//  Created by Vadim on 12/21/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

protocol SnapshotProtocol {
    var key: String { get }
    var ref: DatabaseReference { get }
    init?(snapshot: DataSnapshot)
    func toAny() -> Any
}

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var ref: DatabaseReference!
    lazy var storeRef = ref.child(Constants.Database.stores)
    
    init() {
        ref = Database.database().reference()
    }
    
    func loadMapStyle(completion: @escaping (Result<String?>) -> Void) {
        ref.child(Constants.Database.mapStyle).observe(.value, with: { snapshot in
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
    
    func uploadData(to itemRef: DatabaseReference, _ data: Any, completion: (() -> Void)? = nil) {
        itemRef.setValue(data)
        completion?()
    }
    
    func loadData<T: SnapshotProtocol>(from itemRef: DatabaseReference, completion: @escaping (Result<[T]?>) -> Void) {
        itemRef.observe(.value, with: { snapshot in
            var items = [T]()
            snapshot.children.forEach {
                if let snapshot = $0 as? DataSnapshot,
                    let item = T(snapshot: snapshot) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }, withCancel: { error in
            completion(.failure(error))
        })
    }

//    storeRef = storeRef
//    goodsRef = storeRef.child(storeUrl).child(Constants.Database.goods)
//    reviewRef = storeRef.child(storeUrl).child(Constants.Database.goods).child(goodsUrl).child(Constants.Database.review)
}
