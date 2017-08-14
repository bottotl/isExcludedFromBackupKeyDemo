//
//  ViewController.swift
//  isExcludedFromBackupKeyDemo
//
//  Created by 於林涛 on 7/12/16.
//  Copyright © 2016 於林涛. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(documentsDirectoryPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func firstSituation(_ sender: AnyObject) {
        creatCage(cageNumber: 1)
        saveFileToCage(cageNumber: 1,fileName: "A1")
        
    }
    @IBAction func secondSituation(_ sender: AnyObject) {
        creatCage(cageNumber: 2)
        saveFileToCage(cageNumber: 2,fileName: "A1")
        saveFileToCage(cageNumber: 2,fileName: "A2")
        addSkipBackupAttributeToFile(withCageNumber: 2, fileName: "A1", isNeedSkip: false)
        addSkipBackupAttributeToFile(withCageNumber: 2, fileName: "A2", isNeedSkip: true)
    }
    @IBAction func thirdSituation(_ sender: AnyObject) {
        creatCage(cageNumber: 3)
        saveFileToCage(cageNumber: 3,fileName: "A1")
        saveFileToCage(cageNumber: 3,fileName: "A2")
        addSkipBackupAttributeToCage(cageNumber: 3, isNeedSkip: true)
        addSkipBackupAttributeToFile(withCageNumber: 3, fileName: "A1", isNeedSkip: false)
        addSkipBackupAttributeToFile(withCageNumber: 3, fileName: "A2", isNeedSkip: true)
    }
    
    func saveFileToCage(cageNumber:Int, fileName:String) {
        let packagePathPrefix = cagePath(cageNumber: cageNumber)
        let path = packagePathPrefix.appendingFormat("/%@.txt",fileName)
        do {
            try fileName.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print(error)
        }
        
        
    }
    func creatCage(cageNumber:Int) {
        let packagePathPrefix = cagePath(cageNumber: cageNumber)
        if !FileManager.default.fileExists(atPath: packagePathPrefix) {
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: packagePathPrefix), withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func addSkipBackupAttributeToCage(cageNumber:Int, isNeedSkip:Bool) {
        let path = cagePath(cageNumber: cageNumber)
        addSkipBackupAttribute(atPath: path, isNeedSkip: isNeedSkip)
    }
    func addSkipBackupAttribute(atPath filePath: String, isNeedSkip:Bool) {
        let URL:NSURL = NSURL.fileURL(withPath: filePath)
        
        assert(FileManager.default.fileExists(atPath: filePath), "File \(filePath) does not exist")
        
        do {
            try URL.setResourceValue(isNeedSkip, forKey:URLResourceKey.isExcludedFromBackupKey)
        } catch let error as NSError {
            print("Error excluding \(URL.lastPathComponent) from backup \(error)");
        }
    }
    func addSkipBackupAttributeToFile(withCageNumber cageNum:Int, fileName:String, isNeedSkip:Bool)
    {
        let filePath = cagePath(cageNumber: cageNum).appendingFormat("/%@.txt",fileName)
        addSkipBackupAttribute(atPath: filePath, isNeedSkip: isNeedSkip)
    }
    
    func cagePath(cageNumber: Int) -> String {
        return documentsDirectoryPath.appendingFormat("/cage%d",cageNumber)
    }

}

