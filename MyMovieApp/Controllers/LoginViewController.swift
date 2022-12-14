//
//  LoginViewController.swift
//  MyMovieApp
//
//  Created by Simon LE on 20/09/2022.
//

import UIKit
import Firebase
import FirebaseAuth
import Combine




class LoginViewController: UIViewController {
    
    
    enum LoginStatus {
        case create
        case signIn
    }
    
    @IBOutlet var loginCard: CustomView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var primaryButton: UIButton!
    @IBOutlet var accessoryButton: UIButton!
    @IBOutlet var background: UIImageView!
    
    var emailIsEmpty = true
    var passwordIsEmpty = true
    private var tokens: Set<AnyCancellable> = []
    
    var loginStatus: LoginStatus = .create {
        didSet {
            self.titleLabel.text = (loginStatus == .create) ? "Welcome" : "Welcome Back"
            self.primaryButton.setTitle((loginStatus == .create) ? "Create account" : "Sign in", for: .normal)
            self.accessoryButton.setTitle((loginStatus == .create) ? "Already have an account ?" : "Don't have an account ?", for: .normal)
            self.passwordTextField.textContentType = (loginStatus == .create) ? .newPassword : .password
        }
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        
        if emailIsEmpty == true || passwordIsEmpty == true {
            let alert = UIAlertController(title: "Missing Information", message: "Invalid email address or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if loginStatus  == .create {
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                    authResult, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    self.goToHomeScreen()
                }
            } else {
                
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                    authResult, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    self.goToHomeScreen()
                }
            }
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
        if self.loginStatus == .create {
            self.loginStatus = .signIn
        } else {
            self.loginStatus = .create
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTapAround()
        
        primaryButton.titleLabel?.textAlignment = .center
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut) {
            self.loginCard.alpha = 1
            self.loginCard.frame = self.loginCard.frame.offsetBy(dx: 0, dy: -400)
            
        }
        
        UIView.animate(withDuration: 20.0, delay: 0.5, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.background.frame = CGRect(x: 120, y: 220, width: 100, height: 100)
        })
        
        emailTextField.publisher(for: \.text)
            .sink  { newValue in
                self.emailIsEmpty = (newValue == "" || newValue == nil)
            }
            .store(in: &tokens)
        
        passwordTextField.publisher(for: \.text)
            .sink  { newValue in
                self.passwordIsEmpty = (newValue == "" || newValue == nil)
            }
            .store(in: &tokens)
    }
    
    
    func goToHomeScreen() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        vc.accountSignIn = emailTextField.text
        self.present(vc, animated: true, completion: nil)
    }
}


extension UIViewController {
    func hideKeyboardWhenTapAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
