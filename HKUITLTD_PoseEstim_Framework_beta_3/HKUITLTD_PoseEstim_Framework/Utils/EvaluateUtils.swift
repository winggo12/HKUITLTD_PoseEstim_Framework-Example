
import Foundation

public class EvaluateUtils {
    
    var imageData: [images] = []
    
    public init() {
    }
    
    public func genJson() -> URL {
        let outputJson = Coco(images: self.imageData)
        let encoder = JSONEncoder()
        let data: Data
        data = try! encoder.encode(outputJson)
        print(data)
        
        let fmanager = FileManager.default
        let docPath = fmanager.urls(for: .documentDirectory, in: .userDomainMask)
        let date = Date()
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let filePath = docPath[0].appendingPathComponent("tfliteResult_\(dateF.string(from: date)).json")
        do {
//            print(outputJson)
            try data.write(to: filePath)
            print(filePath)
            return filePath
        } catch {
            print("json error!")
            return filePath
        }
    }
    
    public func addImageData(data: Result, name: String, cnt: Int){
        var kps: [Float] = []
        for dot in data.dots {
            kps.append(Float(dot.x))
            kps.append(Float(dot.y))
        }
        self.imageData.append(images(image_name: name, id: cnt, keypoints: kps))
    }
    
    public func clearImageData() {
        self.imageData.removeAll()
    }
}
