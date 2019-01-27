//
//  StoreAddingPanel.swift
//  RateGoods
//
//  Created by Vadim on 12/26/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import Rswift

protocol StoreAddingPanelDelegate: class {
    func alert(_ alert: UIAlertController)
    func picker(_ picker: UIImagePickerController)
    func storeSaving()
}

class StoreAddingPanel: UIView {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    weak var delegate: StoreAddingPanelDelegate?
    
    var picker = UIImagePickerController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurePicker()
    }
    
    private func configurePicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        storeImageView.addGestureRecognizer(tapGesture)
        storeImageView.isUserInteractionEnabled = true
        picker.delegate = self
    }
    
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let galleryAction = UIAlertAction(title: "Open Gallery", style: .default) { _ in
            self.openGallery()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }

        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        delegate?.alert(alert)
    }
    
    private func openCamera() {
        picker.sourceType = .camera
        picker.allowsEditing = true
        delegate?.picker(picker)
    }
    
    private func openGallery() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        delegate?.picker(picker)
    }
    
    func showActivityIndicator() {
        activityView.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityView.stopAnimating()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate?.storeSaving()
    }
    
}

extension StoreAddingPanel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let chosenImage = info[.editedImage] as? UIImage {
            storeImageView.contentMode = .scaleToFill
            storeImageView.image = chosenImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

}
