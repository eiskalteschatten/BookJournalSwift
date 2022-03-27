//
//  Languages.swift
//  BookJournal
//
//  Created by Alex Seifert on 27.03.22.
//

import Foundation

struct Language: Decodable, Hashable {
    let name: String
    let nativeName: String
    let code: String
    
    enum CodingKeys: CodingKey {
        case name
        case nativeName
    }
    
    init(from decoder: Decoder) throws {
        let locale = NSLocale(localeIdentifier: NSLocale.current.languageCode ?? "en_US")
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = container.codingPath.first!.stringValue
        name = locale.displayName(forKey: NSLocale.Key.identifier, value: code)!
        nativeName = try container.decode(String.self, forKey: CodingKeys.nativeName)
    }
}

struct DecodedLanguageArray: Decodable {
    var array: [Language]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            // The language keys are strings, so return nil
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray = [Language]()

        for key in container.allKeys {
            let decodedObject = try container.decode(Language.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }

        array = tempArray.sorted {
            return $0.name < $1.name
        }
    }
}
