//
//  LoginVC.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 9/7/22.
//

import UIKit

final class LoginVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var bu_login: UIButton!
    @IBOutlet weak var tf_user: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Avoid login when reopening the app
        guard LocalDataModel.getToken() != nil else { return }
        navigateToTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fade in allowing user interaction
        UIView.animate(withDuration: 1, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {self.view.alpha = 1}, completion: nil)

    }



    @IBAction func onTap_bu_login() {
        
        // Get user and password, check not empty
        let user = tf_user.text ?? ""
        let password = tf_password.text ?? ""
        guard !user.isEmpty, !password.isEmpty else {
            showOkAlert(withTitle: "Error en autenticación", andMessage: "Complete todos los campos para entrar", completion: nil)
            return
        }
        
        
        activityIndicator.startAnimating()
        login(withUser: user, andPassword: password)
    }
    

    
}


extension LoginVC {
    
    private func navigateToTabBar() {
        // Set tab bar and tab bar items for the heroes list and collection views
        let tabCon = TabBarC()
        // Navigate to the tab bar
//        navigationController?.setViewControllers([tabCon], animated: true)
        navigationController?.pushViewController(tabCon, animated: true)
    }
    
     func login(withUser user: String, andPassword password: String) {
        // Get token and login
        let networkModel = NetworkModel()
        networkModel.login(withUser: user, andPassword: password) { [weak self] token, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    guard let error = error else { return }
                    switch error {
                    case .decoding, .malformedURL, .noData, .other, .tokenFormat:
                        self?.showOkAlert(withTitle: "Error durante la autenticación") { _ in
                            self?.activityIndicator.stopAnimating()
                        }
                    default:
                        self?.showOkAlert(withTitle: "Error \(error) durante la autenticación") { _ in
                            self?.activityIndicator.stopAnimating()
                        }
                    }
                    
                    return
                }
                guard let token = token, !token.isEmpty else { return }
                
                LocalDataModel.save(token: token)
                
                self?.activityIndicator.stopAnimating()
                self?.tf_password.text = ""
                // Navigate to next view
                self?.navigateToTabBar()
            }
        }
    }
}
