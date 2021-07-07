
import Foundation

struct images: Codable {
    var image_name: String
    var id: Int
    var keypoints: [Float]
}

struct Coco: Codable {
    var images: [images]
}
