//
//  QuoteView.swift
//  QuotePro
//
//  Created by David Mills on 2019-02-21.
//  Copyright © 2019 David Mills. All rights reserved.
//

import UIKit

class QuoteView: UIView {

  @IBOutlet weak var quoteLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  var quote: Quote? {
    didSet {
      if let quote = quote {
        quoteLabel.text = quote.text
        authorLabel.text = quote.author
      }
    }
  }

  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
}
