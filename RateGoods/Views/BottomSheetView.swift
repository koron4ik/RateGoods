//
//  BottomSheetView.swift
//  RateGoods
//
//  Created by Vadim on 12/26/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import Rswift

protocol BottomSheetViewDelegate: class {
    func alert(_ alert: UIAlertController)
    func picker(_ picker: UIImagePickerController)
    func saveButtonPressed()
}

class BottomSheetView: UIView {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    
    weak var delegate: BottomSheetViewDelegate?
    
    var picker = UIImagePickerController()
    
    func setupPicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        storeImageView.addGestureRecognizer(tapGesture)
        storeImageView.isUserInteractionEnabled = true
        
        picker.delegate = self
    }
    
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let galleryAction = UIAlertAction(title: "Open Gallery", style: .default) { (action) in self.openGallery()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.openCamera()
        }

        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        delegate?.alert(alert)
    }
    
    func openCamera(){
        picker.sourceType = .camera
        picker.allowsEditing = true
        delegate?.picker(picker)
    }
    
    func openGallery()
    {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        delegate?.picker(picker)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate?.saveButtonPressed()
    }
    
}

extension BottomSheetView: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.editedImage] as! UIImage
        storeImageView.contentMode = .scaleToFill
        storeImageView.image = chosenImage
        
        picker.dismiss(animated: true, completion: nil)
    }

}
