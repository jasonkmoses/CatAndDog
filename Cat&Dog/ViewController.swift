//
//  ViewController.swift
//  Cat&Dog
//
//  Created by jason Moses on 2019/10/06.
//  Copyright © 2019 jason Moses. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   let imagePicker  = UIImagePickerController()
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var labelCatorDog: UILabel!
    override func viewDidLoad() {
            self.view.isUserInteractionEnabled = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true }
        @IBAction func btnPressed(_ sender: Any) {
            present(imagePicker, animated: true, completion: nil)
        };
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                  let image = info[.originalImage]
                  imageView.image = image as? UIImage
                  dismiss(animated: true, completion: nil)
            let ciimage = CIImage(image: image as! UIImage)
            detect(image: ciimage!)
        }; func detect(image: CIImage)  {
            do {
                guard let mod = try? VNCoreMLModel(for: CheckerForDOGorCAT().model) else { return }
                let request = VNCoreMLRequest(model:mod) { (request, e) in
                     if e != nil {
                         print(e!)}
                     else {
                         let results = request.results as! [VNClassificationObservation]
                         print(results)
                         if results.first?.identifier == "Cat" {
                            print("Cat")
                            self.labelCatorDog.text = "Cat"
                            let aler = UIAlertController(title: "Cat", message: "Yes its a cat if you couldn't see with your own eyes ;)", preferredStyle: .alert)
                            let act = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            aler.addAction(act)
                            self.present(aler, animated: true, completion: nil)
                         }
                        if results == request.results as! [VNClassificationObservation] {
                            print("Dog")
                            self.labelCatorDog.text = "Dog"
                            let alert = UIAlertController(title: "Dog", message: "It must be a dog", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)} } }
                 let handler = VNImageRequestHandler(ciImage: image)
                 do {
                     try handler.perform([request])
                 } catch {
                     print(error)
                 }
            }
        }
}

