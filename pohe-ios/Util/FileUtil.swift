//
//  FileUtil.swift
//  pohe-ios
//
import Foundation
public class FileUtil: NSObject {
    // MARK: - Plist
    /**
     plistファイルから配列を読み込む
     
     - parameter plistFileName: ファイル名
     
     - returns: NSArray
     */
    public class func loadPlistArray(plistFileName: String, inBundleFor aClass: Swift.AnyClass? = nil) -> NSArray {
        let bundle = aClass != nil ? Bundle(for: aClass!) : Bundle.main
        if
            let filePath = bundle.path(forResource: plistFileName, ofType: "plist"),
            let source = NSArray(contentsOfFile: filePath) {
            return source
        }
        
        return []
    }
    
    public class func loadPlistData(plistFileName: String, inBundleFor aClass: Swift.AnyClass? = nil) -> Data? {
        if
            let filePath = Bundle.main.url(forResource: plistFileName, withExtension: "plist"),
            let source = try? Data(contentsOf: filePath){
            return source
        }
        return nil
    }
    
    /**
     plistファイルから辞書を読み込む
     
     - parameter plistFileName: ファイル名
     
     - returns: NSDictionary
     */
    public class func loadPlistDictionary(plistFileName: String, inBundleFor aClass: Swift.AnyClass? = nil) -> NSDictionary {
        let bundle = aClass != nil ? Bundle(for: aClass!) : Bundle.main
        if
            let filePath = bundle.path(forResource: plistFileName, ofType: "plist"),
            let source = NSDictionary(contentsOfFile: filePath) {
            return source
        }
        
        return [:]
    }
    
    public class func loadJsonString(fromResourceFileName fileName: String, inBundleFor aClass: Swift.AnyClass? = nil) -> String {
        let bundle = aClass != nil ? Bundle(for: aClass!) : Bundle.main
        if let filePath = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let json = try String(contentsOfFile: filePath, encoding: .utf8)
                return json
            } catch {
//                log.debug("Read Json from Resource Failed: " + error.localizedDescription)
                return ""
            }
        }
        return ""
    }
}
