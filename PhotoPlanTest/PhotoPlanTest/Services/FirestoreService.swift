

import Foundation
import Firebase
import FirebaseFirestore

class FireStoreServices {
    static let shared = FireStoreServices()
    
    let db = Firestore.firestore()
    
    private var locationRef: CollectionReference {
        return db.collection("locations")
    }
    
    
    

    
    //MARK: - создаем локацию в firebase
    func createLocation(locationModel: LocationModel?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let name = locationModel?.locationName, let imageUrl = locationModel?.imageUrlString, let id = locationModel?.id else {return}
        locationRef.document(id).setData(["title":name, "imageUrl":imageUrl, "id":id]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Void()))
        }
    }
    
    
    
    //MARK: - обновление данных
    
    
    func updateNameData(title: String, id: String?) {
        guard let id = id else {return}
        locationRef.document(id).updateData(["title":title])
    }
    
    
    func updatePhotoData(photo: String, id: String?) {
        guard let id = id else {return}
        locationRef.document(id).updateData(["imageUrl": FieldValue.arrayUnion([photo])])
    }
    

    
    //MARK: - удаление ячейки
    func deleteLocation(id: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = id else {return}
        locationRef.document(id).delete { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
        }
    }
        
    
    
    //MARK: - SnapshotListener

    func locationObserve(location: [LocationModel], completion: @escaping (Result<[LocationModel], Error>) -> Void){
        locationRef.addSnapshotListener { (querySnapshot, error) in
            var localName = location
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                let localData = document.data()
                guard let title = localData["title"] as? String,
                      let imageUrl = localData["imageUrl"] as? [String],
                      let id = localData["id"] as? String else {return}
                let locationModel = LocationModel(name: title, imageUrlString: imageUrl, id: id)
                localName.append(locationModel)
            }
            completion(.success(localName))
        }
    }
    
//    func locationObserve(completion: @escaping (Result<LocationModel, Error>) -> Void){
//        locationRef.addSnapshotListener { (querySnapshot, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            for document in querySnapshot!.documents {
//                let localData = document.data()
//                guard let title = localData["title"] as? String,
//                      let imageUrl = localData["imageUrl"] as? [String],
//                      let id = localData["id"] as? String else {return}
//                let locationModel = LocationModel(name: title, imageUrlString: imageUrl, id: id)
//                completion(.success(locationModel))
//            }
//        }
//    }
    
}




