

import UIKit
import FirebaseFirestore

protocol PresentDelegate: AnyObject {
    func presentDelegate(pc: UIImagePickerController)
}

protocol PresentViewControllerDelegate: AnyObject {
    func presentViewControllerDelegate(vc: UIViewController)
}

protocol UpdateTextDelegate: AnyObject {
    func updateTextDelegate(text: String, id: String)
}

protocol UpdateImageDelegate: AnyObject {
    func updateImageDelegate(imageUrl: String, id: String)
}

class LocationViewController: UIViewController {
    var data: [LocationModel] = []
    var locationModel: LocationModel?
    var id: String?
    
    
    
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group 303")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ЛОКАЦИИ"
        label.textAlignment = .center
        label.textColor = .black
        label.font = label.font.withSize(29)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Group 159"), for: .normal)
        button.setShadowAndRadius()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.invalidateIntrinsicContentSize()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    
    //MARK: -  viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        setupTitleImageView()
        setupTitleLabel()
        setupTableView()
        setupPlusButton()
        
        FireStoreServices.shared.locationObserve(location: self.data) { result in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let error):
                print("ERROR::\(error.localizedDescription)")
            }
        }
    }
    

    
    
    
    //MARK: - SetupConstraints
    
    
    private func setupTitleImageView() {
        view.addSubview(titleImageView)
        let guide = view.safeAreaLayoutGuide
        titleImageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 44.5).isActive = true
        titleImageView.heightAnchor.constraint(equalToConstant: 62.5).isActive = true
        titleImageView.widthAnchor.constraint(equalToConstant: 242.5).isActive = true
        titleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        let guide = view.safeAreaLayoutGuide
        titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 44.5).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 42.5).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 232.5).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: LocationCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        let guide = view.safeAreaLayoutGuide
        tableView.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    private func setupPlusButton() {
        view.addSubview(plusButton)
        plusButton.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        plusButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        plusButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height / 5)).isActive = true
    }
    
    @objc func addLocation() {
        locationModel = LocationModel(name: "", imageUrlString: [], id: UUID().uuidString)
        FireStoreServices.shared.createLocation(locationModel: locationModel) { result in
            switch result {
            case .success():
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationCell.self), for: indexPath)
        guard let locationCell = cell as? LocationCell else {return cell}
        locationCell.delegate = self
        locationCell.imageDelegate = self
        locationCell.textDelegate = self
        locationCell.pesentViewControllerDelegate = self
        locationCell.backgroundColor = .white
        locationCell.selectionStyle = .none
        let locationData = data[indexPath.row]
        locationCell.setupCell(location: locationData)
        return locationCell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
return 250
    }

    
    //MARK: - trailingSwipeActionsConfigurationForRowAt
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func deleteAction (at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let idData = self.data[indexPath.row].id
            self.id = idData
            FireStoreServices.shared.deleteLocation(id: idData) { result in
                switch result {
                case .success():
                    print("delete \(indexPath.row)")
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "delete.left.fill")
        action.title = "Удалить"
        return action
    }


}

//MARK: - protocol PresentDelegate

extension LocationViewController: PresentDelegate, UpdateTextDelegate, UpdateImageDelegate, PresentViewControllerDelegate {
    func presentViewControllerDelegate(vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    func updateTextDelegate(text: String, id: String) {
        FireStoreServices.shared.updateNameData(title: text, id: id)
        self.tableView.reloadData()
    }
    
    func updateImageDelegate(imageUrl: String, id: String) {
        FireStoreServices.shared.updatePhotoData(photo: imageUrl, id: id)
        self.tableView.reloadData()
    }
    
    func presentDelegate(pc: UIImagePickerController) {
        present(pc, animated: true, completion: nil)
    }
}






