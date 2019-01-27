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

protocol StoreAddingViewControllerInteractor: class {
    var storeLocation: CLLocationCoordinate2D { get }
    func saveStore(storeTitle: String, storeImage: UIImage, storeLocation: CLLocationCoordinate2D, completion: @escaping (_ error: Error?) -> Void)
}

protocol StoreAddingViewControllerCoordiantor: class {
    func storeSaved()
}

class StoreAddingViewController: UIViewController {
    
    weak var storeAddingPanel: StoreAddingPanel!
        
    var interactor: StoreAddingViewInteractor!
    weak var coordinator: StoreAddingViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePanel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.coordinator?.dismiss()
        }
    }
    
    private func configurePanel() {
        self.storeAddingPanel = R.nib.storeAddingPanel.instantiate(withOwner: nil, options: nil).first as? StoreAddingPanel
        self.storeAddingPanel.frame = view.frame
        self.storeAddingPanel.delegate = self
        self.storeAddingPanel.storeNameTextField.delegate = self
        
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
    
    func storeSaving() {
        guard let storeTitle = storeAddingPanel.storeNameTextField.text,
            let storeImage = storeAddingPanel.storeImageView.image else {
                return
        }

        self.storeAddingPanel.showActivityIndicator()
        self.interactor.saveStore(storeTitle: storeTitle, storeImage: storeImage, storeLocation: interactor.storeLocation) { [weak self] _ in
            self?.storeAddingPanel.hideActivityIndicator()
            self?.coordinator?.storeSaved()
        }
    }
}
