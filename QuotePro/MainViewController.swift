//
//  MainViewController.swift
//  QuotePro
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
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    let dvc = segue.destination as! QuoteBuilderViewController
    dvc.delegate = self
  }


}

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

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let quote = quotes[indexPath.row]
    if let quoteView = loadQuoteView(quote),
      let image = snapshot(view: quoteView) {
      // Create a UIActivityViewController
      let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

      // Present it
      present(activityViewController, animated: true, completion: nil)
    }
  }

  private func snapshot(view: UIView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }

  private func loadQuoteView(_ quote: Quote) -> QuoteView? {
    if let objects = Bundle.main.loadNibNamed("QuoteView", owner: nil, options: nil),
      let view = objects.first as? QuoteView {
      view.quote = quote
      view.image = quote.image
      view.layoutIfNeeded()
      return view
    } else {
      return nil
    }
  }
}

extension MainViewController: QuoteBuilderDelegate {
  func save(_ quote: Quote) {
    quotes.append(quote)
    tableView.reloadData()
  }
}
