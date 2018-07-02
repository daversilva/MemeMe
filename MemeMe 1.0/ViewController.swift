//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 02/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pickerAnImageFromCamera(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func pickerAnImageFromAlbum(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func pickerCancel(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func pickerShare(_ sender: UIBarButtonItem) {
    }
    
}

