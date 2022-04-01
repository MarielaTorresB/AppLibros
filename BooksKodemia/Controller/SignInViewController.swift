//
//  SignInViewController.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    private lazy var contentStackView: UIStackView = UIStackView()
    private lazy var buttonStackView: UIStackView = UIStackView()
    private lazy var signUpTitle: UILabel = UILabel()
    //MARK: Textfields
    private lazy var userNameInputTextField: InputTextField = InputTextField(frame: CGRect(), placeHolder: Constants.userString)
    private lazy var userEmailInputTextField: InputTextField = InputTextField(frame: CGRect(), placeHolder: Constants.emailString)
    private lazy var passwordInputTextField: InputTextField = InputTextField(frame: CGRect(), placeHolder: Constants.passwordString)
    private lazy var confirmPasswordInputTextField: InputTextField = InputTextField(frame: CGRect(), placeHolder: Constants.confirmPasswordString)
    //MARK: UIButtons
    private lazy var confirmButton: FilledButton = FilledButton(title: Constants.acceptString, frame: CGRect())
    private lazy var cancelButton: UnfilledButton = UnfilledButton(title: Constants.cancelString, frame: CGRect())
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() //Conexión a la base de datos
        initUI()
    }
    
    
    func initUI() {
        view.backgroundColor = .systemBackground
        signUpTitle.text = "Registra tu información"
        userEmailInputTextField.keyboardType = .emailAddress
        passwordInputTextField.isSecureTextEntry = true
        confirmPasswordInputTextField.isSecureTextEntry = true
        view.addSubview(signUpTitle)
        let textfieldArray: [UITextField] = [userNameInputTextField,
                                            userEmailInputTextField,
                                            passwordInputTextField,
                                            confirmPasswordInputTextField]
        // configurar Stack view
        contentStackView.axis = .vertical
        contentStackView.spacing = Constants.padding
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        // Definimos un closure donde se itera cada elemento del arreglo
        // y textfieldElement va asumiendo cada valor del arreglo
        textfieldArray.forEach { textfieldElement in
            contentStackView.addArrangedSubview(textfieldElement)
        }
        // Es lo equivalente a hacer esto
//        for textField in textfieldArray {
//            contentStackView.addArrangedSubview(textField)
//        }
        // Configurar constraints del stack view
        self.view.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.widthProportion),
            signUpTitle.heightAnchor.constraint(equalToConstant: 250),
            signUpTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            signUpTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.widthProportion)
        ])
        textfieldArray.forEach { textFieldElement in
            textFieldElement.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
            textFieldElement.layer.borderWidth = 1
        }
        
        let buttonArray: [UIButton] = [ confirmButton, cancelButton]
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = Constants.padding
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        
        buttonArray.forEach { button in
            buttonStackView.addArrangedSubview(button)
        
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate( [
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.widthProportion)
        ])
        
        buttonArray.forEach { button in
            button.heightAnchor.constraint(equalToConstant: Constants.buttonSize).isActive = true
        }
        
        self.confirmButton.addTarget(self, action: #selector(onAcceptButtonTap), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(onCancelButtonTap), for: .touchUpInside)
        
    }

    //Función para crear al usuario en firebase
    @objc func onAcceptButtonTap() {
        if let nombre = userNameInputTextField.text {
            if let correo = userEmailInputTextField.text {
                if let pass = passwordInputTextField.text {
                    registroTerminado(nombre: nombre, correo: correo, pass: pass)
                }
            }
        }
    }
    
    
    // Función para crear al usuario en la BD de Firebase
    func registroTerminado(nombre: String, correo: String, pass: String){
        Auth.auth().createUser(withEmail: correo, password: pass) { [self] user, error in
            if user != nil{
                print("Usuario creado")
                let campos = ["nombre": nombre, "email": correo, "id": Auth.auth().currentUser?.uid]
                ref?.child("users").child(Auth.auth().currentUser!.uid).setValue(campos)
                dismissAndContinue()
                //self.dismiss(animated: true, completion: nil)
            }else{
                if let error = error?.localizedDescription{
                    print("Error en Firebase:", error)
                    let alert = UIAlertController(title: "Error :(", message: error, preferredStyle: .alert)
                    let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                    alert.addAction(aceptar)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Error :(", message: "Error en el código fuente", preferredStyle: .alert)
                    let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                    alert.addAction(aceptar)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }

    
    @objc func onCancelButtonTap() {
        dismiss(animated: true, completion: nil)
    }
    
    func dismissAndContinue() {
        let dashboardNavigationController: UINavigationController = UINavigationController()
        let dashboardViewController: DashboardViewController = DashboardViewController()
        dashboardNavigationController.setViewControllers([dashboardViewController], animated: true)
        dashboardNavigationController.modalPresentationStyle = .overFullScreen
        present(dashboardNavigationController, animated: true, completion: nil)
    }
}
