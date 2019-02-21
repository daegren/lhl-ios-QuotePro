//
//  QuoteTableViewCell.swift
//  QuotePro
//
//  Created by David Mills on 2019-02-21.
//  Copyright © 2019 David Mills. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var quoteLabel: UILabel!

  var quote: Quote? {
    didSet {
      if let quote = quote {
        authorLabel.text = quote.author
        quoteLabel.text = quote.text
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
