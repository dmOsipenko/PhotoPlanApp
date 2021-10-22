


import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageServices {
    static let shared = StorageServices()
    
    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        return storageRef.child("image")
    }
    
    
    //MARK: Загружает фото в Storage, потом дает возможность перенести ее в firebaseFirestore .

func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void ) {
    let uid = UUID().uuidString
    guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {return}
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"

    avatarsRef.child(uid).putData(imageData, metadata: metadata) { metadata, error in
        guard let _ = metadata else {
            completion(.failure(error!))
            return
        }
        self.avatarsRef.child(uid).downloadURL { url, error in
            guard let dowloadUrl = url else {
                completion(.failure(error!))
                return
            }
            completion(.success(dowloadUrl))
        }
    }
}
}
