//
//  MemeEditorViewController.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 08/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Foundation

protocol MemeEditorDelegate {
    func didCancel()
}

class MemeEditorViewController: UIViewController {
    
    /// Outlets
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButtoon: UIBarButtonItem!
    
    var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    var shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
    
    /// variables
    let top = "TOP"
    let bottom = "BOTTOM"
    
    /// RxSwift
    var disposeBag = DisposeBag()
    var shareIsEnable = BehaviorRelay<Bool>(value: false)
    
    override var prefersStatusBarHidden: Bool { return true }
    
    var delegate: MemeEditorDelegate?
    
    /// lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        configureTextField(topTextField)
        configureTextField(bottomTextField)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func save(_ memedImage: UIImage) {
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, original: imagePickerView.image!, meme: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.accept(appDelegate.memes.value + [meme])
    }
    
    func generateMemedImage() -> UIImage {
        configureBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureBars(false)
        
        return memedImage
    }
    
    func configureBars(_ isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
        toolBar.isHidden = isHidden
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func configureTextField(_ textField: UITextField) {
        let memeTextAttributes: [String: Any] = [
            NSAttributedString.Key.strokeColor.rawValue: UIColor.black,
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
            NSAttributedString.Key.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth.rawValue: -3.0]
        
        textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    func configurePickerAnImage(_ sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        present(imagePicker, animated: true, completion: nil)
        shareIsEnable.accept(true)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == top || textField.text == bottom {
            textField.text = ""
        }
        
        textField == bottomTextField ? subscribeToKeyboardNotifications() : unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setups
extension MemeEditorViewController {
    
    private func setupViews() {
        topTextField.text = top
        bottomTextField.text = bottom
        
        shareIsEnable.accept(false)
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func bindViews() {
        
        shareIsEnable.bind(to: shareButton.rx.isEnabled).disposed(by: disposeBag)
        
        cancelButton.rx.tap.bind { [weak self] in
            self?.delegate?.didCancel()
        }.disposed(by: disposeBag)
        
        cameraButton.rx.tap.bind { [weak self] in
            self?.configurePickerAnImage(.camera)
        }.disposed(by: disposeBag)
        
        albumButtoon.rx.tap.bind { [weak self] in
            self?.configurePickerAnImage(.photoLibrary)
        }.disposed(by: disposeBag)
        
        shareButton.rx.tap.bind { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cancelButton.isEnabled = true
            
            let image = strongSelf.generateMemedImage()
            let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            controller.completionWithItemsHandler = { activity, completed, items, error in
                if completed {
                    strongSelf.save(image)
                    strongSelf.delegate?.didCancel()
                }
            }
            strongSelf.present(controller, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
