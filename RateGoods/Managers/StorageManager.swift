//
//  StorageManager.swift
//  RateGoods
//
//  Created by Vadim on 12/29/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageManager {
    
    static let shared = StorageManager()
    
    var ref: StorageReference!
    
    init() {
        ref = Storage.storage().reference()
    }
    
    func uploadMedia(path: String, image: UIImage, completion: @escaping (Result<URL?>) -> Void) {
        let imageName = NSUUID().uuidString
        let storageRef = ref.child(path).child("\(imageName).png")
        
        if let uploadData = image.pngData() {
            storageRef.putData(uploadData, metadata: nil) { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                storageRef.downloadURL(completion: { url, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(url))
                })
            }
        }
    }
    
    func loadImage(with url: String, completion: @escaping (Result<UIImage?>) -> Void) {
        Storage.storage().reference(forURL: url).getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(UIImage(data: data)))
                return
            }
            
            completion(.success(nil))
        }
    }
}
