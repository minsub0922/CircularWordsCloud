//
//  ViewController.swift
//  CircularWordsCloud
//
//  Created by minsub0922 on 01/17/2020.
//  Copyright (c) 2020 minsub0922. All rights reserved.
//

import UIKit
import CircularWordsCloud
class ViewController: UIViewController {
    
    fileprivate let dict = [
        "Friends": ["KElon", "Hanjoo", "Henry", "Kim", "Hwang", "Yosep", "Robert", "Chris"],
        "KElon": ["Doctor","Cool Guy", "Rinsa's Friend", "Male", "Live in Seoul"],
        "Hanjoo": ["Health Boy", "Handsome", "Kind", "Salariman"],
        "Cool Guy": ["Healthy", "Pretty Neat", "Funny", "Attractive", "Gentle", "Popular"]
    ]
    
    var words = ["John", "Henry", "KElon", "Hanjoo", "Yosep", "Jason", "Karen", "Rinsa"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circularWordsCloud = CircularWordsCloud(position: .top) // default
        circularWordsCloud.delegate = self
        view.addSubview(circularWordsCloud)
        
        circularWordsCloud.enableLongPressGesture = true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: CircularWorsCloudDelegate {
    var ranksForWords: [Int] {
        return [1,7,5,2,6,2,7,3]
    }
    
    var wordForAxis: String {
        //return "CenterWord"
        return "Friends"
    }
    
    var wordsForCloud: [String] {
        //return ["Words","That","You","Want","Show","Around", "The", "Central Word"]
        return words
    }
    // optional
    func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                            didSelectWord: String) {
        print("Cloud Did Select")
    }
       
    func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                            didDeselectWord: String) {
        print("Cloud Did Deselect")
    }
    func circularWordsCloudDidExpand() {
        print("Cloud Did Expand")
    }
       
    func circularWordsCloudDidCollapse() {
        print("Cloud Did Collapse")
    }
    
    func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                            newAxisWord: String,
                            depth: Int,
                            completion: @escaping ([String]) -> Void) {
        print("Cloud will be Changed !")
        completion(dict[newAxisWord] ?? [])
    }
}
