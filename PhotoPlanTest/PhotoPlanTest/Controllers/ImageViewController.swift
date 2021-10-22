//
//  ImageViewController.swift
//  PhotoPlanTest
//
//  Created by Дмитрий Осипенко on 22.10.21.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {
    
    var imageUrl: String? = nil
    var swipe: UITapGestureRecognizer!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let cancelButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "Group 159"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupButton()
        setupGesture()
        guard let url = imageUrl else {return}
        imageView.sd_setImage(with: URL(string: url), completed: nil)
    }
    

    func setupImageView() {
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupButton() {
        view.addSubview(cancelButton)
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    func setupGesture() {
        swipe = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(swipe)
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func tapAction() {
        if swipe.numberOfTapsRequired == 1 {
            cancelButton.alpha = 1
            print("1")
    }

}
}
