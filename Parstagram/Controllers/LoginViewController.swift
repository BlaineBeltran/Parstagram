//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Blaine Beltran on 3/24/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        guard !isUsernameOrPasswordEmpty() else {
            displayEmptyTextFieldError()
            return
        }
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { [weak self ] user, error in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.displayLoginError(error: error)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
            }
        }
        
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard !isUsernameOrPasswordEmpty() else {
            displayEmptyTextFieldError()
            return
        }
        
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        newUser.signUpInBackground { [ weak self ] isSuccess, error in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.displaySignupError(error: error)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("signedUp"), object: nil)
            }
        }
        
        
    }
    
    private func isUsernameOrPasswordEmpty() -> Bool {
        
        return usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty
    }
    
    
    private func displayEmptyTextFieldError() {
        
        let title = NSLocalizedString("Error", comment: "Title for empty text field alert")
        let message = NSLocalizedString("Username and password field cannot be empty", comment: "Message for empty text field alert")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func displayLoginError(error: Error) {
        
        let title = NSLocalizedString("Login Error", comment: "Title for login failure alert")
        let message = NSLocalizedString("Oops! Something went wrong while logging in. Error: \(error.localizedDescription)", comment: "Message for login failure alert")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func displaySignupError(error: Error) {
        
        let title = NSLocalizedString("Sign-Up Error", comment: "Title for sign up failure alert")
        let message = NSLocalizedString("Oops! Something went wrong while signing in \(error.localizedDescription)", comment: "Message for sign up failure alert")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
        
    }

}
