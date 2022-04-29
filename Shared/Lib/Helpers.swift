//
//  Helpers.swift
//  BookJournal
//
//  Created by Alex Seifert on 28.04.22.
//

import SwiftUI

func openURLInBrowser(_ url: URL) {
    #if os(iOS)
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
    #else
    NSWorkspace.shared.open(url)
    #endif
}

func getAmazonLink(withSearchParam: Bool = false) -> String {
    let locale = Locale.preferredLanguages[0]

    let links = [
        "de-DE": "https://www.amazon.de/s?tag=alexseifert0b-21",
        "fr-FR": "https://www.amazon.fr/s?tag=alexseifer0b6-21",
        "it-IT": "https://www.amazon.it/s?tag=alexseifer0eb-21",
        "es-ES": "https://www.amazon.es/s?tag=alexseifert06-21",
        "en-GB": "https://www.amazon.co.uk/s?tag=alexseifert05-21",
        "en-US": "https://www.amazon.com"  // TODO
    ]
    
    guard var link = links[locale] ?? links["en_US"] else {
        return ""
    }
    
    if withSearchParam {
        let searchParam = "&k="
        link = link + searchParam
    }
    
    return link
}
