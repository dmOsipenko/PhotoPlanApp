

import UIKit
import FirebaseFirestore
import UISliderView



class LocationCell: UITableViewCell {
    
    let sliderView = UISliderView()
    
    static var reuseId = "LocationCell"
    weak var delegate: PresentDelegate?
    weak var imageDelegate: UpdateImageDelegate?
    weak var textDelegate: UpdateTextDelegate?
    weak var pesentViewControllerDelegate: PresentViewControllerDelegate?
    
    var data: [String] = []
    var selectedImages: [UIImage] = []
    var id: String?

        
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setupShadowAndRadius()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let frontView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 237/255, green: 243/255, blue: 244/255, alpha: 1)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "Введите название"
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Group 159"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        contentView.addSubview(backView)
        backView.addSubview(frontView)
        frontView.addSubview(textField)
        frontView.addSubview(plusButton)
        frontView.addSubview(collectionView)
        
        setupBackView()
        setupFrontView()
        setupTextField()
        setupPlusButton()
        setupCollectionView()
    }
    

    
    private func setupBackView() {
        backView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        backView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func setupFrontView() {
        frontView.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 15).isActive = true
        frontView.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -15).isActive = true
        frontView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 15).isActive = true
        frontView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -15).isActive = true
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 15).isActive = true
        textField.rightAnchor.constraint(equalTo: plusButton.leftAnchor, constant: -15).isActive = true
        textField.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func setupPlusButton() {
        plusButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        plusButton.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -10).isActive = true
        plusButton.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 10).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 45).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -17).isActive = true
        collectionView.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 15).isActive = true
        collectionView.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -15).isActive = true

    }
    
    
    func setupCell(location: LocationModel) {
        textField.text = location.locationName
        self.data = location.imageUrlString
        self.id = location.id
        self.collectionView.reloadData()
    }
    
    @objc func addPhoto() {
        presentPhotoPicker()
    }

}

//MARK: - UICollectionViewDataSource

extension LocationCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath)
        guard let photoCell = cell as? PhotoCell else {return cell}
        let data = data[indexPath.row]
        photoCell.setupCell(photo: data)
        photoCell.layer.cornerRadius = 15
        photoCell.layer.masksToBounds = true
        return photoCell
    }
}

//MARK: - UICollectionViewDelegate
extension LocationCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.imageUrl = data[indexPath.row]
        self.pesentViewControllerDelegate?.presentViewControllerDelegate(vc: vc)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension LocationCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let numberOfColumns: CGFloat = 3
        let cellWidth = (collectionView.layer.frame.width - (2 * spacing)) / numberOfColumns
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}


//MARK: - UITextFieldDelegate
extension LocationCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let id = self.id else {return }
        self.textDelegate?.updateTextDelegate(text: text, id: id)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension LocationCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        delegate?.presentDelegate(pc: vc)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        StorageServices.shared.upload(photo: selectedImage) { result in
            switch result {
            case .success(let url):
                guard let id = self.id else {return }
                self.imageDelegate?.updateImageDelegate(imageUrl: url.absoluteString, id: id)
                print("Фото загруженно!")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



