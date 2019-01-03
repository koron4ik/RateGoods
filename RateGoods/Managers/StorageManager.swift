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
    
    func uploadMedia(image: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        let imageName = NSUUID().uuidString
        let storageRef = ref.child("storeImages").child("\(imageName).png")
        
        if let uploadData = image.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if metadata == nil {
                    completion(nil, NSError(domain: "core", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected error. Path is nil."]))
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url, error)
                })
            }
        }
    }
    
    func loadImage(with url: String, completion: @escaping (UIImage?) -> Void) {
        Storage.storage().reference(forURL: url).getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            if let error = error {
                print(error)
                completion(nil)
            }
            completion(UIImage(data: data))            
        }
    }
}
