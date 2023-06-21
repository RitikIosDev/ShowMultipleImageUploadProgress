//
//  ViewController.swift
//  ShowMultipleImageUploadProgress
//
//  Created by Ritik on 29/05/23.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        uploadImages()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionView), name: ImageUploadManager.updateNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func uploadImages() {
        var images = [UIImage]()
        let firstImage = UIImage(named: "GatewayImage") ?? UIImage()
        images.append(firstImage)
        let secondImage = UIImage(named: "HillsImage") ?? UIImage()
        images.append(secondImage)
        let thirdImage = UIImage(named: "LakeViewImage") ?? UIImage()
        images.append(thirdImage)
        let fourthImage = UIImage(named: "MonkPlaceImage") ?? UIImage()
        images.append(fourthImage)
        let fifthImage = UIImage(named: "TreesImage") ?? UIImage()
        images.append(fifthImage)

        for image in images {
            ImageUploadManager.shared.uploadImages(image: image, title: "Uploading Image") { error in
                if let error = error {
                    print(error.localizedDescription)
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                     })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageUploadManager.shared.tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.model = ImageUploadManager.shared.tasks[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
