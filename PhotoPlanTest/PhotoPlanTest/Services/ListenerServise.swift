




import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerServices {
    
    static let shared = ListenerServices()
    
    private let db = Firestore.firestore()
    
    private var locationReff: CollectionReference {
        return db.collection("location")
    }
    
    func usersObserve(location: [LocationModel], completion: @escaping (Result<[LocationModel], Error>) -> Void)-> ListenerRegistration?  {
        let observer = locationReff.addSnapshotListener { (querySnapshot, error) in
            var localName = location
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                let localData = document.data()
                guard let title = localData["title"] as? String,
                      let imageUrl = localData["imageUrl"] as? String,
                      let id = localData["id"] as? String else {return}
                let locationModel = LocationModel(name: title, imageUrlString: imageUrl, id: id)
                localName.append(locationModel)
            }
            completion(.success(localName))
        }
        return observer
    }    
}
