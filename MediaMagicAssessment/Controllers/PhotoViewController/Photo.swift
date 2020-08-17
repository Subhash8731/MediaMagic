
import Foundation
 
public class Photo {
	public var format : String?
	public var width : Int?
	public var height : Int?
	public var filename : String?
	public var id : Int?
	public var author : String?
	public var author_url : String?
	public var post_url : String?


    public class func modelsFromDictionaryArray(array:Array<Dictionary<String,Any>>) -> [Photo]
    {
        var models:[Photo] = []
        for item in array
        {
            models.append(Photo(dictionary: item)!)
        }
        return models
    }


	required public init?(dictionary: Dictionary<String,Any>) {

		format = dictionary["format"] as? String
		width = dictionary["width"] as? Int
		height = dictionary["height"] as? Int
		filename = dictionary["filename"] as? String
		id = dictionary["id"] as? Int
		author = dictionary["author"] as? String
		author_url = dictionary["author_url"] as? String
		post_url = dictionary["post_url"] as? String
	}

	public func dictionaryRepresentation() -> Dictionary<String,Any> {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.format, forKey: "format")
		dictionary.setValue(self.width, forKey: "width")
		dictionary.setValue(self.height, forKey: "height")
		dictionary.setValue(self.filename, forKey: "filename")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.author, forKey: "author")
		dictionary.setValue(self.author_url, forKey: "author_url")
		dictionary.setValue(self.post_url, forKey: "post_url")

		return dictionary as! Dictionary<String,Any>
	}

}
