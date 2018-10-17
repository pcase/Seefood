//
//  ViewController.swift
//  SeeFood
//
//  Created by Patty Case on 10/14/18.
//  Copyright © 2018 Azure Horse Creations. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var choices = ["waterfalls","mountain","dog","rabbit","hamburger","pizza","hotdog"]
    var pickerView = UIPickerView()
    var typeValue = String()
    
    let apiKey = "41T3884Bc5ufPS3fwMi-PjP4WQA_I8ZF_tfn4WIaJ_Ls"
    let imagePicker = UIImagePickerController()
    let version = "2018-07-17"
    var classificationResults : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Whatsit"
        imageView.image = UIImage(named: "azurehorsecreations")!
        typeValue = choices[0]
        showAlert()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
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
                
                for index in 0..<classes.count {
                    self.classificationResults.append(classes[index].className)
                }
                print(self.classificationResults)
                
                let word = self.typeValue
                
                if self.classificationResults.contains(where: {$0.caseInsensitiveCompare(word) == .orderedSame}) {
                    DispatchQueue.main.async {
                        self.navigationItem.title = self.typeValue + "!"
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not " + self.typeValue + "!"
                    }
                }
            }
        } else {
            print("There was an error picking the image")
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        self.navigationItem.title = ""
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK - PickerView
  func showAlert() {
        let alert = UIAlertController(title: "Choices", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            print("You selected " + self.typeValue )
            
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        typeValue = choices[0]
        
        if row == 0 {
            typeValue = choices[0]
        } else if row == 1 {
            typeValue = choices[1]
        } else if row == 2 {
            typeValue = choices[2]
        } else if row == 3 {
            typeValue = choices[3]
        } else if row == 4 {
            typeValue = choices[4]
        } else if row == 5 {
            typeValue = choices[5]
        } else if row == 6 {
            typeValue = choices[6]
        } else if row == 7 {
            typeValue = choices[7]
        }
    }
}

