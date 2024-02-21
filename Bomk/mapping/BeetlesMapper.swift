import Foundation
import ObjectMapper

class Beetle: Mappable {
    var id: String?
    var name: String?
    var image: String?
    var species: String?
    var spread: String?
    var story: String?
    var fact: String?
    var rating: Float?
    var isSaved: Bool?
    var documentID: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        documentID <- map["documentID"]
        id <- map["id"]
        name <- map["name"]
        image <- map["image"]
        species <- map["species"]
        spread <- map["spread"]
        story <- map["story"]
        fact <- map["fact"]
        rating <- map["rating"]
        isSaved <- map["isSaved"]
    }
}
