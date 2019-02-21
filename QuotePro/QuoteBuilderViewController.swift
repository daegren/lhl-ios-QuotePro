//
//  QuoteBuilderViewController.swift
//  QuotePro
//
//  Created by David Mills on 2019-02-20.
//  Copyright © 2019 David Mills. All rights reserved.
//

import UIKit

protocol QuoteBuilderDelegate {
  func save(_ quote: Quote)
}

class QuoteBuilderViewController: UIViewController {

  var quoteView: QuoteView!
  let quoteURL = URL(string: "http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json")!
  let imageURL = URL(string: "http://lorempixel.com/900/600")!

  var delegate: QuoteBuilderDelegate?

  var quote: Quote? {
    didSet {
      quoteView.quote = quote
    }
  }

  var image: UIImage? {
    didSet {
      quoteView.image = image
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    loadQuoteView()
    fetchQuote()
    fetchImage()
  }

  @IBAction func newQuoteTapped(_ sender: UIButton) {
    fetchQuote()
  }

  @IBAction func newImageTapped(_ sender: UIButton) {
    fetchImage()
  }

  @IBAction func saveQuote(_ sender: UIButton) {
    if let delegate = delegate,
      var quote = quote {
      quote.image = image
      delegate.save(quote)
    }

    navigationController?.popViewController(animated: true)
  }

  private func loadQuoteView() {
    if let objects = Bundle.main.loadNibNamed("QuoteView", owner: nil, options: nil),
      let quoteView = objects.first as? QuoteView {
      self.quoteView = quoteView
      quoteView.translatesAutoresizingMaskIntoConstraints = false

      self.view.addSubview(quoteView)

      NSLayoutConstraint(item: quoteView,
                         attribute: .centerX,
                         relatedBy: .equal,
                         toItem: self.view,
                         attribute: .centerX,
                         multiplier: 1,
                         constant: 0).isActive = true

      NSLayoutConstraint(item: quoteView,
                         attribute: .top,
                         relatedBy: .equal,
                         toItem: self.view,
                         attribute: .topMargin,
                         multiplier: 1,
                         constant: 20).isActive = true

      NSLayoutConstraint(item: quoteView,
                         attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         multiplier: 1,
                         constant: 200).isActive = true

      NSLayoutConstraint(item: quoteView,
                         attribute: .width,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         multiplier: 1,
                         constant: 300).isActive = true
    }
  }

  private func fetchQuote() {
    let task = URLSession.shared.dataTask(with: quoteURL) { (data, response, error) in
      if let error = error {
        print("Error fetching quote:", error)
        return
      }

      guard let data = data else { return }

      let decoder = JSONDecoder()
      do {
        let quote = try decoder.decode(Quote.self, from: data)

        OperationQueue.main.addOperation {
          self.quote = quote
        }
      } catch let error {
        var jsonString = String(data: data, encoding: .utf8)!
        print("Got an error decoding JSON:", error, jsonString)

        jsonString = jsonString.replacingOccurrences(of: "\\'", with: "'")
        let sanitizedJsonData = jsonString.data(using: .utf8)!

        do {
          let quote = try decoder.decode(Quote.self, from: sanitizedJsonData)

          OperationQueue.main.addOperation {
            self.quote = quote
          }
        } catch let error {
          print("Error decoding sanitized JSON:", error)
        }
      }
    }

    task.resume()
  }

  private func fetchImage() {
    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
      if let error = error {
        print("Error fetching image:", error)
        return
      }

      guard let imageData = data else { return }
      guard let image = UIImage.init(data: imageData) else { return }

      OperationQueue.main.addOperation {
        self.image = image
      }
    }

    task.resume()
  }
}

