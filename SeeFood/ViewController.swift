//
//  ViewController.swift
//  SeeFood
//
//  Created by Patty Case on 10/14/18.
//  Copyright © 2018 Azure Horse Creations. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    let apiKey = "41T3884Bc5ufPS3fwMi-PjP4WQA_I8ZF_tfn4WIaJ_Ls"
    let imagePicker = UIImagePickerController()
    let version = "2018-07-17"
    var classificationResults : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            let imageData = image.jpegData(compressionQuality: 0.01)
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
            try? imageData?.write(to: fileURL, options: [])
            let failure = { (error: Error) in print(error) }
            visualRecognition.classify(image: image, failure: failure) { classifiedImages in
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                
                self.classificationResults = []
                self.navigationItem.title = ""
                
                for index in 0..<classes.count {
                    self.classificationResults.append(classes[index].className)
                }
                print(self.classificationResults)
                
                let word = "waterfalls"
                
                if self.classificationResults.contains(where: {$0.caseInsensitiveCompare(word) == .orderedSame}) {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Waterfalls!"
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Waterfalls!"
                    }
                }
                
//                if self.classificationResults.contains("Waterfalls") {
//                    DispatchQueue.main.async {
//                        self.navigationItem.title = "Waterfalls!"
//                    }
//                }
//                else {
//                    DispatchQueue.main.async {
//                        self.navigationItem.title = "Not Waterfalls!"
//                    }
//                }
            }
        } else {
            print("There was an error picking the image")
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

