//
//  GoodsAddingViewController.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/12/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import Cosmos
import Toast_Swift

protocol GoodsAddingViewControllerInteractor: class {
    var store: Store { get }
    func saveGoods(with goodsTitle: String, goodsImageUrl: String, rating: Double, goodsReview: String)
}

protocol GoodsAddingViewControllerCoordinator: class {
    func dismiss()
}

class GoodsAddingViewController: UIViewController {
    
    var interactor: GoodsAddingViewInteractor!
    weak var coordinator: GoodsAddingViewCoordinator?
    
    @IBOutlet weak var goodsTextField: UITextField!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    private var picker = UIImagePickerController()
    
    private var imageIsChoosen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePicker()
        self.registerNotificationObservers()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardShouldHide))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.coordinator?.dismiss()
        }
    }
    
    @objc func keyboardShouldHide() {
        self.view.endEditing(true)
    }
    
    private func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configurePicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        self.goodsImageView.addGestureRecognizer(tapGesture)
        self.goodsImageView.isUserInteractionEnabled = true
        self.picker.delegate = self
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
        
        self.present(alert, animated: true)
    }
    
    private func openCamera() {
        self.picker.sourceType = .camera
        self.picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    private func openGallery() {
        self.picker.sourceType = .photoLibrary
        self.picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.coordinator?.stop()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let goodsTitle = goodsTextField.text,
            let goodsReview = reviewTextView.text,
            let goodsImage = goodsImageView.image,
            !goodsTitle.isEmpty,
            imageIsChoosen else {
                self.view.makeToast("Enter text and choose image to continue", duration: 2.0, position: .bottom)
                return
        }

        if rateView.rating < 1 && !reviewTextView.text.isEmpty {
            self.view.makeToast("Enter rating")
            return
        }
        
        self.view.makeToastActivity(.center)
        self.view.isUserInteractionEnabled = false
        StorageManager.shared.uploadMedia(path: Constants.Storage.goodsImages, image: goodsImage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let url):
                guard let url = url else { return }
                self.interactor.saveGoods(with: goodsTitle,
                                                goodsImageUrl: url.absoluteString,
                                                rating: self.rateView?.rating ?? 0.0,
                                                goodsReview: goodsReview)
                self.coordinator?.stop()
            case .failure(let error):
                self.view.makeToast(error.localizedDescription, duration: 2.0, position: .bottom)
            }
            self.view.isUserInteractionEnabled = true
            self.view.hideToastActivity()
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        contentScrollView.contentInset.bottom = view.convert(keyboardSize, from: nil).size.height
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        contentScrollView.contentInset.bottom = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension GoodsAddingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let chosenImage = info[.editedImage] as? UIImage {
            self.goodsImageView.contentMode = .scaleToFill
            self.goodsImageView.image = chosenImage
            self.imageIsChoosen = true
        }
        
        self.picker.dismiss(animated: true, completion: nil)
    }
    
}

extension GoodsAddingViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let bottomOffset = CGPoint(x: 0,
                                   y: contentScrollView.contentSize.height - contentScrollView.bounds.size.height + contentScrollView.contentInset.bottom)
        self.contentScrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 500
    }
}

extension GoodsAddingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        if text.isEmpty && string == " " {
            return false
        }
        
        let count = text.count + string.count - range.length
        return count < 20
    }
}
