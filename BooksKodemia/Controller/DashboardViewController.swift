//
//  DashboardViewController.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DashboardViewController: UIViewController {
    
    enum DashboardSection:String, CaseIterable {
        case books = "Libros"
        case authors = "Autores"
        case categories = "Categories"
        
        var endpointAssigned: Endpoints {
            switch self {
            case .books: return .books
            case .authors: return .authors
            case .categories: return .categories
            }
        }
    }
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
//    private lazy var userStackView: UIStackView = UIStackView()
    
    var greetingsText: UILabel = UILabel()
    
    private lazy var sectionsButton: UISegmentedControl = UISegmentedControl(items: viewSections.map{ $0.rawValue })
    
    private lazy var contentTableView: UITableView = UITableView()
    
    private lazy var activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private let apiDataManager: APIDataManager = APIDataManager()
    
    private var dataSource: [ResultViewable] = [ResultViewable]()
    
    private var viewSections: [DashboardSection] = DashboardSection.allCases
    
    private var currentSection: DashboardSection = .books
    
    var ref: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Conexión a la base de datos
        ref = Database.database().reference()
        initUI()
        requestBooks()
    }
    
    func initUI() {
        view.backgroundColor = .systemBackground
        greetingsText.text = ""
        // Obteniendo el nombre del usuario
        let userId = (Auth.auth().currentUser?.uid)!
        print(userId)
        ref?.child("users").child(userId).observeSingleEvent(of: .value, with: { [self] (snatshop) in
            let value = snatshop.value as? NSDictionary
            let valueString = value!["nombre"] as? String
            navigationItem.title  = "¡Hola, \(valueString!)!"
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salir", style: .done, target: self, action: #selector(signOut))

//        view.addSubview(userStackView)
//        userStackView.axis = .horizontal
//        userStackView.spacing = 10
//        userStackView.distribution = .fillProportionally
//        userStackView.alignment = .top
//        userStackView.addArrangedSubview(greetingsText)
//        userStackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            userStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
//            userStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
//            userStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            userStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.widthProportion)
//        ])
    }
    
    func requestBooks() {
        createActivityIndicator()
        hideTableView()
        apiDataManager.performRequest(endpoint: .books) { [weak self] (response: BooksResponse) in
            self?.removeActivityIndicator()
            self?.dataSource = response.data
            // If falls into the if let statement, means
            // that the table has already be shown before
            // and it is hidden now
            if let _ = self?.contentTableView.superview {
                self?.showAndReloadTableView()
                return
            }
            self?.completeUI()
        } onError: { [weak self] error in
            self?.removeActivityIndicator()
            print(error)
        }
    }
    
    func requestAuthors() {
        createActivityIndicator()
        hideTableView()
        apiDataManager.performRequest(endpoint: .authors) { [weak self] (response: AuthorsResponse) in
            self?.removeActivityIndicator()
            self?.dataSource = response.data
            // If falls into the if let statement, means
            // that the table has already be shown before
            // and it is hidden now
            if let _ = self?.contentTableView.superview {
                self?.showAndReloadTableView()
                return
            }
            self?.completeUI()
        } onError: { [weak self] error in
            self?.removeActivityIndicator()
            print(error)
        }
    }
    
    func requestCategories() {
        createActivityIndicator()
        hideTableView()
        apiDataManager.performRequest(endpoint: .categories) { [weak self] (response: CategoriesResponse) in
            self?.removeActivityIndicator()
            self?.dataSource = response.data
            // If falls into the if let statement, means
            // that the table has already be shown before
            // and it is hidden now
            if let _ = self?.contentTableView.superview {
                self?.showAndReloadTableView()
                return
            }
            self?.completeUI()
        } onError: { [weak self] error in
            self?.removeActivityIndicator()
            print(error)
        }
    }
    
    func createActivityIndicator() {
        self.view.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        activityView.startAnimating()
    }
    
    func removeActivityIndicator() {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
    
    func hideTableView() {
        contentTableView.isHidden = true
    }
    
    func showAndReloadTableView() {
        contentTableView.isHidden = false
        contentTableView.reloadData()
    }
    
    func completeUI() {
        view.addSubview(sectionsButton)
        sectionsButton.selectedSegmentIndex = 0
        sectionsButton.translatesAutoresizingMaskIntoConstraints = false
        sectionsButton.backgroundColor = .black
        sectionsButton.selectedSegmentTintColor = .gray
        sectionsButton.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        sectionsButton.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        NSLayoutConstraint.activate([
            sectionsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            sectionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            sectionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            sectionsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        view.addSubview(contentTableView)
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.isHidden = false
        NSLayoutConstraint.activate([
            contentTableView.topAnchor.constraint(equalTo: sectionsButton.bottomAnchor, constant: Constants.padding),
            contentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            contentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            contentTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding)
        ])
        
        contentTableView.layer.borderColor = UIColor.clear.cgColor
        contentTableView.layer.borderWidth = Constants.borderWidth
        contentTableView.layer.cornerRadius = Constants.cornerRadius
        contentTableView.layer.masksToBounds = true
        sectionsButton.addTarget(self, action: #selector(sectionDidChanged(_:)), for: .valueChanged)
//        navigationItem.setRightBarButtonItems([UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.dismissView))], animated: true)
    }
    
    @objc func sectionDidChanged(_ sender: UISegmentedControl) {
        let indexSelection: Int = sender.selectedSegmentIndex
        currentSection = viewSections[indexSelection]
        switch indexSelection {
        case 0:
            requestBooks()
        case 1:
            requestAuthors()
        case 2:
            requestCategories()
        default:
            break
        }
    }
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func signOut(){
        print("boton apretado")
        let alerta = UIAlertController(title: "Cerrar sesión", message: "¿Seguro que desea cerrar sesión?", preferredStyle: .alert)
        let aceptar = UIAlertAction(title: "Aceptar", style: .default) { _ in
            try! Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alerta.addAction(aceptar)
        alerta.addAction(cancelar)
        present(alerta, animated: true, completion: nil)
    }
    
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Por el momento sólo los de la primera sección tienen que ir a detalle, los demás no.
        let selectedSection : Int = sectionsButton.selectedSegmentIndex
        switch selectedSection {
        case 0:
            let model: ResultViewable = dataSource[indexPath.row]
            let detailView: DetailViewController = DetailViewController()
            detailView.viewableResultFromDashboard = model
            navigationController?.pushViewController(detailView, animated: true)
        default:
            break
        }
    }
}

extension DashboardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedSection : Int = sectionsButton.selectedSegmentIndex
        switch selectedSection {
        case 4:
            let title: String = dataSource[indexPath.row].name ?? ""
            let content : String = dataSource[indexPath.row].content ?? ""
            let cell: UITableViewCell = UITableViewCell()
            cell.textLabel?.text = title
            let backgroundColorView: UIView = UIView()
            backgroundColorView.backgroundColor = .gray
            cell.selectedBackgroundView = backgroundColorView
            return cell
        default:
                let title: String = dataSource[indexPath.row].name
                let cell: UITableViewCell = UITableViewCell()
                cell.textLabel?.text = title
                let backgroundColorView: UIView = UIView()
                backgroundColorView.backgroundColor = .gray
                cell.selectedBackgroundView = backgroundColorView
                return cell
        }
        
    }
}
