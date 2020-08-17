

import UIKit
import Foundation

public enum Method: Int {
    case post,get,put,delete
}

extension Method {
    
    var name:String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .put:
            return "PUT"
        default:
            return "DELETE"
        }
    }
}

extension String {
    var nsdata: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}

struct File {
    let name: String?
    let filename: String?
    let data: Data?
    init(name: String?,filename: String?, data: Data?) {
        self.name = name
        self.filename = filename
        self.data = data
    }
}

enum Result <T>{
    case Success(T)
    case Error(String)
}



public class APIService: NSObject {
    func startService(with method:Method,path:String,maptype:Bool,parameters:Dictionary<String,Any>?,files:Array<File>?, completion: @escaping (Result<Array<Dictionary<String,Any>>>) -> Void) {
        print(parameters ?? [:])
        guard let url = URL(string:(maptype ? path : Config.apiUrl+path)) else { return completion(.Error("Invalid URL, we can't proceed.")) }
        
        let request = self.buildRequest(with: method, url: url, parameters: parameters, files: files)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "Data not found."))
            }
            do {
                let strForData = String(data: data, encoding: .utf8)
                print("Json String :--  \(strForData)")
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? Array<Dictionary<String,AnyObject>> {
                    print(json)
                   
                    if let res = json as? Array<Dictionary<String,AnyObject>> {
                        completion(.Success(json))
                       
                    } else {
                        completion(.Error("Error message"))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }
        task.resume()
    }
    
    //MARK:- Map Service
    
    func startMapService(with method:Method,path:String,parameters:Dictionary<String,Any>?,files:Array<File>?, completion: @escaping (Result<Dictionary<String,Any>>) -> Void) {
        print(parameters ?? [:])
        guard let url = URL(string:path) else { return completion(.Error("Invalid URL, we can't proceed.")) }
        
        let request = self.buildRequest(with: method, url: url, parameters: parameters, files: files)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "Data not found."))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? Dictionary<String,AnyObject> {
                    print(json)
                    completion(.Success(json))
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }
        
        task.resume()
        
    }
    
}

extension APIService {
    
    func buildRequest(with method:Method,url:URL,parameters:Dictionary<String,Any>?,files:Array<File>?) -> URLRequest {
        
        var request:URLRequest? = nil
        switch method {
        case .get:
            if let params = parameters,params.count > 0 {
                let queryUrl = url.appendingPathComponent("?"+buildParams(parameters: params))
                request = URLRequest(url: queryUrl)
            } else {
                request = URLRequest(url: url)
                
            }
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .post:
            request = URLRequest(url: url)
            if let images = files,images.count > 0{
                
                let boundary = "Boundary-\(UUID().uuidString)"
                let boundaryPrefix = "--\(boundary)\r\n"
                let boundarySuffix = "--\(boundary)--\r\n"
               request?.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
                let data = NSMutableData()
                if let params = parameters,params.count > 0{
                    for (key, value) in params {
                        data.append("--\(boundary)\r\n".nsdata)
                        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                        data.append("\((value as! String))\r\n".nsdata)
                    }
                }
                for file in images {
                    data.append(boundaryPrefix.nsdata)
                    data.append("Content-Disposition: form-data; name=\"\(file.name!)\"; filename=\"\(NSString(string: file.filename!))\"\r\n\r\n".nsdata)
                    if let a = file.data {
                        data.append(a)
                        data.append("\r\n".nsdata)
                        
                    } else {
                        print("Could not read file data")
                    }
                }
                data.append(boundarySuffix.nsdata)
                request?.httpBody = data as Data
            } else if let params = parameters,params.count > 0 {
                request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let  jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request?.httpBody = jsonData
            }
        default:
            request = URLRequest(url: url)
            break
        }
        
//        request?.httpMethod = method.name
        var req = request ?? URLRequest(url: url)
        // pass your authorisation token here.
//        if let token = AppInstance.shared.authToken {
//            req.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
//        }
        req.httpMethod = method.name
        print(req)
        return req
    }
    
    func buildParams(parameters: Dictionary<String,Any>) -> String {
        var components: [(String, String)] = []
        for (key,value) in parameters {
            components += self.queryComponents(key, value)
        }
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    
    func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? Dictionary<String,Any> {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append(contentsOf: [(escape(string: key), escape(string: "\(value)"))])
        }
        
        return components
    }
    func escape(string: String) -> String {
        if let encodedString = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
            return encodedString
        }
        return ""
    }
}
