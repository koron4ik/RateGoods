//
//  PanelContentViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/23/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol PanelContentViewControllerDelegate: class {
    func storeSaving(title: String, imageUrl: String)
}

class PanelContentViewController: UIViewController {
    
    private var bottomSheetView: BottomSheetView!
    
    var delegate: PanelContentViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bottomSheetView = R.nib.bottomSheetView().instantiate(withOwner: nil, options: nil).first as? BottomSheetView
        self.bottomSheetView.frame = view.frame
        self.bottomSheetView.delegate = self
        self.bottomSheetView.storeNameTextField.delegate = self
        self.bottomSheetView.setupPicker()
        
        self.view.addSubview(bottomSheetView)                
    }
}

extension PanelContentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PanelContentViewController: BottomSheetViewDelegate {
    
    func alert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func picker(_ picker: UIImagePickerController) {
        present(picker, animated: true, completion: nil)
    }
    
    func saveButtonPressed() {
        guard let storeTitle = bottomSheetView.storeNameTextField.text,
            let storeImage = bottomSheetView.storeImageView.image else {
                return
        }
        
        if storeTitle != "" {
            StorageManager.shared.uploadMedia(image: storeImage) { (url, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let url = url else { return }
                
                self.delegate?.storeSaving(title: storeTitle, imageUrl: url.absoluteString)
            }
            dismiss(animated: true)
        }        
    }
}

