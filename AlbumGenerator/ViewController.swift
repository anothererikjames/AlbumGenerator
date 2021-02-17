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
    @IBOutlet weak var albumName: UILabel!
    
    var testImageNumber:UInt = 1
    lazy var allFonts:[String] = {
        var fontArray = [String]()
        for family in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: family) {
                fontArray.append(font)
            }
        }
        return fontArray
    }()
    
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
            return
        }
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/Special:Random") {
            do {
                let contents = try String(contentsOf: url)
                if let startIndex = returnIndexOf(substring: "<title>", forText: contents, offsetBy: 7), let endIndex = returnIndexOf(substring: " - Wikipedia", forText: contents) {
                    let finalName = contents[startIndex..<endIndex]
                    bandName.text = String(finalName)
                    bandName.font = UIFont(name: returnRandomFont(), size: bandName.font.pointSize)
                }
                
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
    func loadAlbumName() {
        if let url = URL(string: "https://en.wikiquote.org/wiki/Special:Random") {
            do {
                let contents = try String(contentsOf: url)
                if let startIndex = returnIndexOf(substring: "<li>", forText: contents, offsetBy: 4), let endIndex = returnIndexOf(substring: "</li>", forText: contents), endIndex > startIndex {
                    let finalName = contents[startIndex..<endIndex]
                    let firstFourWords = finalName.split(separator: " ")[0..<4].joined(separator: " ") + "..."
                    print("firstFourWords = \(firstFourWords)")
                    albumName.text = String(firstFourWords)
                    albumName.font = UIFont(name: returnRandomFont(), size: albumName.font.pointSize)
                } else {
                    albumName.text = ""
                }
                
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
    func returnRandomFont() -> String {
        return allFonts.randomElement() ?? ""
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
                        self?.loadAlbumName()
                    }
                }
            }
        }
    }

}

