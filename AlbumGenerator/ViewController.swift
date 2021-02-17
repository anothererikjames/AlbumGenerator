//
//  ViewController.swift
//  AlbumGenerator
//
//  Created by Erik James on 2/16/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var albumImage: UIImageView?
    @IBOutlet weak var bandName: UILabel!
    
    var testImageNumber:UInt = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        albumImage?.isHighlighted = false
        loadAlbumImage()
     }
    // https://en.wikipedia.org/wiki/Special:Random
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        loadAlbumImage()
    }
    
    func returnIndexOf(substring: String, forText: String, offsetBy:Int = 0) -> String.Index? {
        if let range: Range<String.Index> = forText.range(of: substring) {
            let index: Int = forText.distance(from: forText.startIndex, to: range.lowerBound)
            return String.Index(utf16Offset: index + offsetBy, in: forText)
        }
        return nil
    }
    
    func loadAlbumText() {
        
        if UIApplication.isRunningTest {
            bandName.text = String("This is a test")
            bandName.accessibilityIdentifier = "bandLabel"
            return
        }
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/Special:Random") {
            do {
                let contents = try String(contentsOf: url)
                if let startIndex = returnIndexOf(substring: "<title>", forText: contents, offsetBy: 7), let endIndex = returnIndexOf(substring: " - Wikipedia", forText: contents) {
                    let finalName = contents[startIndex..<endIndex]
                    bandName.text = String(finalName)
                }
                
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
    func loadAlbumImage() {
        guard let albumImage  = albumImage,!albumImage.isHighlighted else {
            return
        }
        
        if UIApplication.isRunningTest {
            albumImage.image = UIImage(named: "testingImage\(testImageNumber)")
            albumImage.isHighlighted = false
            testImageNumber = (testImageNumber % 2) + 1
            loadAlbumText()
            return
        }
        
        albumImage.isHighlighted = true
        
        let imageUrlString = "https://picsum.photos/500/"
        guard let imageUrl:URL = URL(string: imageUrlString) else {
            return
        }
        
        DispatchQueue.global().async { [weak self, weak weakImage = albumImage] in
            if let imageData = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        weakImage?.isHighlighted = false
                        weakImage?.image = nil
                        weakImage?.image = image
                        self?.loadAlbumText()
                    }
                }
            }
        }
    }

}

