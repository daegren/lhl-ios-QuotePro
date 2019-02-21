//
//  MainViewController.swift
//  QuotePro
//
//  This view controller handles showing the list of all the generated quotes.
//
//  Created by David Mills on 2019-02-21.
//  Copyright © 2019 David Mills. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  private var quotes = [Quote]()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the destination view controller
    let dvc = segue.destination as! QuoteBuilderViewController
    // Set the delegate of the destination view controller to self so that we can
    // get a quote from the QuoteBuilderViewController
    dvc.delegate = self
  }


}

// Extention for UITableViewDataSource methods
extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quotes.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath) as! QuoteTableViewCell

    let quote = quotes[indexPath.row]
    cell.quote = quote

    return cell
  }
}

/**
 Extention for the UITableViewDelegate methods

 Needed to handle tapping on the table view cells
 */
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Get the quote from the array
    let quote = quotes[indexPath.row]
    // Load the quote view
    if let quoteView = loadQuoteView(quote),
      // Take a snapshot of the quote view and create a UIImage from it
      let image = snapshot(view: quoteView) {
      // Create a UIActivityViewController
      let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

      // Present the activity controller
      present(activityViewController, animated: true, completion: nil)
    }
  }

  /**
   Helper function to handle taking a snapshot of an arbitrary view

   - Parameter view: The view to take a snapshot of

   - Returns: a `UIImage?` of the view
   */
  private func snapshot(view: UIView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }

  /**
   A Helper function to handle loading the `QuoteView` nib.

   - Parameter quote: The quote object to load into the view

   - Returns: `QuoteView`
   */
  private func loadQuoteView(_ quote: Quote) -> QuoteView? {
    if let objects = Bundle.main.loadNibNamed("QuoteView", owner: nil, options: nil),
      let view = objects.first as? QuoteView {
      view.quote = quote
      view.image = quote.image
      return view
    } else {
      return nil
    }
  }
}

/**
 This extention handles the `QuoteBuilderDelegate` functions

 This is called from the QuoteBuilderViewController to save the generated quote
 */
extension MainViewController: QuoteBuilderDelegate {
  func save(_ quote: Quote) {
    quotes.append(quote)
    tableView.reloadData()
  }
}
