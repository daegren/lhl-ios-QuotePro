//
//  Quote.swift
//  QuotePro
//
//  Created by David Mills on 2019-02-20.
//  Copyright © 2019 David Mills. All rights reserved.
//

import Foundation
import UIKit

struct Quote: Codable {
  var text: String
  var author: String

  var image: UIImage?

  enum CodingKeys: String, CodingKey {
    case text = "quoteText"
    case author = "quoteAuthor"
  }
}
