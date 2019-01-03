//
//  StoreAddingViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/23/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import Toast_Swift
import GoogleMaps

protocol StoreAddingViewControllerDelegate: class {
    func storeSaved(with coordinate: CLLocationCoordinate2D)
}

class StoreAddingViewController: UIViewController {
    
    var storeAddingPanel: StoreAddingPanel!
    
    weak var delegate: StoreAddingViewControllerDelegate?

    var storeLocation: CLLocationCoordinate2D?
    
    init(storeLocation: CLLocationCoordinate2D) {
        self.storeLocation = storeLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.storeAddingPanel = R.nib.storeAddingPanel().instantiate(withOwner: nil, options: nil).first as? StoreAddingPanel
        self.storeAddingPanel.frame = view.frame
        self.storeAddingPanel.delegate = self
        self.storeAddingPanel.storeNameTextField.delegate = self
        self.storeAddingPanel.configurePicker()
        
        self.view.addSubview(storeAddingPanel)
    }
}

extension StoreAddingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if !text.isEmpty {
            storeAddingPanel.saveButton.isUserInteractionEnabled = true
            storeAddingPanel.saveButton.backgroundColor = UIColor.purple
        } else {
            storeAddingPanel.saveButton.isUserInteractionEnabled = false
            storeAddingPanel.saveButton.backgroundColor = UIColor.lightGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if text.isEmpty && string == " " {
            return false
        }
        return true
    }
}

extension StoreAddingViewController: StoreAddingPanelDelegate {
    
    func alert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func picker(_ picker: UIImagePickerController) {
        present(picker, animated: true, completion: nil)
    }
    
    func saveButtonPressed() {
        guard let storeTitle = storeAddingPanel.storeNameTextField.text,
            let storeImage = storeAddingPanel.storeImageView.image,
            let coordinate = storeLocation else {
                return
        }
        // сделать кнопку добавления активной когда текст не пустой
        if storeTitle != "" {
            self.storeAddingPanel.showActivityIndicator()
            StorageManager.shared.uploadMedia(image: storeImage) { [weak self] (url, error) in
                if let url =  url, error == nil {
                    DatabaseManager.shared.addStore(with: storeTitle,
                                                    imageUrl: url.absoluteString,
                                                    latitude: coordinate.latitude.description,
                                                    longitude: coordinate.longitude.description)
                    self?.delegate?.storeSaved(with: coordinate)
                    self?.storeAddingPanel.hideActivityIndicator()
                } else {
                    print(error as Any)
                }
            }
        }
    }
}
