//
//  ImageUploadManager.swift
//  BCrumbly
//
//  Created by Ritik on 29/05/23.
//

import UIKit
import Foundation
import Alamofire

struct UploadTask {
    let id: String
    let title: String
    var progress: Float
}

class ImageUploadManager: NSObject {
    static let shared = ImageUploadManager()
    var tasks = [UploadTask]()
    static let updateNotification = Notification.Name("ImageUploadManager.updateNotification")
    
    private override init() {}
    
    func uploadImages(image: UIImage, title: String, completion: @escaping (_ error: Error?) -> Void) {
        
        let uploadTask = UploadTask(id: UUID().uuidString, title: title, progress: 0.0)
        tasks.append(uploadTask)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            let error = NSError(domain: "Corrupt Image", code: 401, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
            completion(error)
            return
        }

        guard let requestURL = URL(string: "https://httpbin.org/anything") else {
            let error = NSError(domain: "URL Unavailable", code: 401, userInfo: [NSLocalizedDescriptionKey: "URL not found"])
            completion(error)
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: requestURL).uploadProgress(queue: .main) { (progress) in
            print(progress.fractionCompleted)
            self.updateTask(id: uploadTask.id, progress: Float(progress.fractionCompleted))
        }.response { (dataResp) in
            switch dataResp.result{
            case .failure(let error):
                self.completeTask(id: uploadTask.id)
                completion(error)
            case .success:
                self.completeTask(id: uploadTask.id)
                completion(nil)
            }
        }
    }
    
    private func updateTask(id: String, progress: Float) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].progress = progress
            NotificationCenter.default.post(name: ImageUploadManager.updateNotification, object: nil)
        }
    }
    
    private func completeTask(id: String) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks.remove(at: index)
            NotificationCenter.default.post(name: ImageUploadManager.updateNotification, object: nil)
        }
    }
}
