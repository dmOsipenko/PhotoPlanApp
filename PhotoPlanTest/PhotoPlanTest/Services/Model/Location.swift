

import UIKit
import FirebaseFirestore



class LocationModel: Equatable {
    
    var locationName: String
    var imageUrlString: [String]
    var id: String
    
    init(name: String, imageUrlString: [String], id: String) {
        self.locationName = name
        self.imageUrlString = imageUrlString
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else {return nil}
        guard let nameLocation = data["title"] as? String,
        let imageUrl = data["imageUrl"] as? [String],
        let id = data["id"] as? String else { return nil }
        
        self.locationName = nameLocation
        self.imageUrlString = imageUrl
        self.id = id
    }
    
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}






