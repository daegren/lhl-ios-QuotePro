//
//  Quote.swift
//  QuotePro
//
//  Created by David Mills on 2019-02-20.
//  Copyright © 2019 David Mills. All rights reserved.
//

import Foundation
import UIKit

// The Codable protocol allows us to use the JSONDecoder to create a quote object.
struct Quote: Codable {
  var text: String
  var author: String

  var image: UIImage?

  // This enum tells the Decoder how to map the keys in the JSON to properties on the struct
  enum CodingKeys: String, CodingKey {
    case text = "quoteText"
    case author = "quoteAuthor"
  }
}
