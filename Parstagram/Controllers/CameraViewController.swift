//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Blaine Beltran on 3/25/22.
//

import UIKit
import PhotosUI
import Parse
import AlamofireImage

class CameraViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.takePicture))
        imagePreview.isUserInteractionEnabled = true
        imagePreview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentTextField.text
        post["author"] = PFUser.current()!
        
        let imageData = imagePreview.image?.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { [ weak self ] success, error in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.displayPostSubmitError(error: error)
            }
            
            if success {
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    private func displayPictureSelectionError(error: Error) {
        
        let title = NSLocalizedString("Selection Error", comment: "Title for picture selection error alert")
        let message = NSLocalizedString("Oops! There was a problem selecting the photo. Error: \(error.localizedDescription)", comment: "Messege for picture selection error alert")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func displayPostSubmitError(error: Error) {
        
        let title = NSLocalizedString("Post Error", comment: "Title for post error alert")
        let message = NSLocalizedString("Oops! There was a posting the photo. Error: \(error.localizedDescription)", comment: "Messege for post error alert")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}

// Show Camera
extension CameraViewController: PHPickerViewControllerDelegate {
    
    @objc func takePicture() {
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = imagePreview.image
            itemProvider.loadObject(ofClass: UIImage.self) { [ weak self ] image, error in
                
                guard let strongSelf = self else { return }
                
                if let error = error {
                    strongSelf.displayPictureSelectionError(error: error)
                } else {
                    DispatchQueue.main.async {
                        guard let image = image as? UIImage, strongSelf.imagePreview.image == previousImage else { return }
                        strongSelf.imagePreview.image = image
                    }
                }
            }
        }
    }
}
