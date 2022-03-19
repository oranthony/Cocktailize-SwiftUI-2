/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Items : Codable, Hashable, Identifiable {
    static func == (lhs: Items, rhs: Items) -> Bool {
        return lhs.key == rhs.key &&
            lhs.name == rhs.name
    }
    
    var hashValue: Int {
    return key.hashValue ^ name.hashValue
    }
    
    let id = UUID()
    
	let key : String?
	var name : String?
	let imageUrl : String?
	let backgroundUrl : String?
	let preparationSteps : PreparationSteps?
	let ingredients : Ingredients?
	//let tags : Tags?

	enum CodingKeys: String, CodingKey {

		case key = "key"
		case name = "name"
		case imageUrl = "imageUrl"
		case backgroundUrl = "backgroundUrl"
		case preparationSteps = "preparationSteps"
		case ingredients = "ingredients"
		//case tags = "tags"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		key = try values.decodeIfPresent(String.self, forKey: .key)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
		backgroundUrl = try values.decodeIfPresent(String.self, forKey: .backgroundUrl)
		preparationSteps = try values.decodeIfPresent(PreparationSteps.self, forKey: .preparationSteps)
		ingredients = try values.decodeIfPresent(Ingredients.self, forKey: .ingredients)
		//tags = try values.decodeIfPresent(Tags.self, forKey: .tags)
	}
    
    init() {
        key = ""
        name = ""
        imageUrl = "https://upload.wikimedia.org/wikipedia/commons/5/59/Empty.png"
        backgroundUrl = ""
        preparationSteps = nil
        ingredients = nil
    }
    
    init(name: String) {
        key = "xx"
        self.name = name
        imageUrl = "https://upload.wikimedia.org/wikipedia/commons/5/59/Empty.png"
        backgroundUrl = "https://upload.wikimedia.org/wikipedia/commons/5/59/Empty.png"
        preparationSteps = PreparationSteps()
        ingredients = Ingredients()
    }
}
