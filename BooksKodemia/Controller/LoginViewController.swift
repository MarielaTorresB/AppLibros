//
//  ViewController.swift
//  BooksKodemia
//
//  Created by L Daniel De San Pedro on 20/02/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // Una variable lazy, se crea en el momento que
    // la invocamo por primera vez.
    private lazy var userInputTextField: InputTextField = InputTextField(frame: CGRect(), placeHolder: Constants.userString)
    
    private lazy var passwordInputTextField: InputTextField = InputTextField(frame: CGRect(), placeHolder: Constants.passwordString)
    
    private lazy var loginButton: FilledButton = FilledButton(title: Constants.logIn, frame: CGRect())
    
    private lazy var signInButton: UnfilledButton = UnfilledButton(title: Constants.signIn, frame: CGRect())
    
    private lazy var loginTitle: UILabel = UILabel()
    
    private lazy var textFieldsStackView: UIStackView = UIStackView()
    
    private lazy var buttonsStackView: UIStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        userInputTextField.text = ""
        passwordInputTextField.text = ""
        
        super.viewDidAppear(animated)
        
        sesionActiva()
        
    }
    
    // Crear la vista
    private func initUI() {
        self.view.backgroundColor = .systemBackground

        passwordInputTextField.isSecureTextEntry = true
        // Textfields array
        let textFields: [InputTextField] = [userInputTextField,passwordInputTextField]
        // TextFields Stack view
        view.addSubview(textFieldsStackView)
        view.addSubview(loginTitle)
        textFieldsStackView.axis = .vertical
        textFieldsStackView.spacing = Constants.padding
        textFieldsStackView.alignment = .fill
        textFieldsStackView.distribution = .fillProportionally
        
        loginTitle.text = Constants.kodemiaBooks
        loginTitle.font = Constants.headerFonts
        loginTitle.numberOfLines = 2
        loginTitle.lineBreakStrategy = .pushOut
        textFields.forEach { inputTextField in
            textFieldsStackView.addArrangedSubview(inputTextField)
        }
        
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        loginTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textFieldsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.widthProportion),
            loginTitle.heightAnchor.constraint(equalToConstant: 250),
            loginTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            loginTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.widthProportion)
        ])
        
        
        textFields.forEach { inputTextfield in
            inputTextfield.translatesAutoresizingMaskIntoConstraints = false
            inputTextfield.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
        }
        
        let buttons: [UIButton] = [loginButton,signInButton]
        
        view.addSubview(buttonsStackView)
        buttonsStackView.spacing = Constants.padding
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.widthProportion)
        ])
        
        buttons.forEach { button in
            buttonsStackView.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: Constants.buttonSize).isActive = true
        }
        
        signInButton.addTarget(self, action: #selector(onSignInButtonTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(onLoginButtonTap), for: .touchUpInside)
    }
    
    
    @objc func onSignInButtonTap() {
        goToSignIn()
    }
    
    
    func goToSignIn() {
        let signInViewController: SignInViewController = SignInViewController()
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    
    @objc func onLoginButtonTap() {
        if let mail = userInputTextField.text {
            if let contrasena = passwordInputTextField.text{
                iniciarSesion(correo: mail, pass: contrasena)
            }
        }
    }
    
    func goToDashboardView() {
        let dashboardNavigationController: UINavigationController = UINavigationController()
        let dashboardViewController: DashboardViewController = DashboardViewController()
        dashboardNavigationController.setViewControllers([dashboardViewController], animated: true)
        dashboardNavigationController.modalPresentationStyle = .fullScreen
        present(dashboardNavigationController, animated: true, completion: nil)
        
        
        
        //detailView.viewableResultFromDashboard = model
//        navigationController?.pushViewController(dashboardViewController, animated: true)
    }
    
    func iniciarSesion(correo: String, pass: String){
        Auth.auth().signIn(withEmail: correo, password: pass) { [self] user, error in
            if user != nil{
                  print("Logueando..")
                  goToDashboardView()
            } else {
                if let error = error?.localizedDescription{
                    print("Error en Firebase:", error)
                    let alert = UIAlertController(title: "Error :(", message: error, preferredStyle: .alert)
                    let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                    alert.addAction(aceptar)
                    present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Error :(", message: "Error en el código fuente", preferredStyle: .alert)
                    let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                    alert.addAction(aceptar)
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func sesionActiva(){
        Auth.auth().addStateDidChangeListener { [self] user, error in
            if error == nil{
                print("No hay usuarios logueados")
                
            }else{
                print("Ya hay un usuario logueado")
                goToDashboardView()
            }
        }
    }
    

}

