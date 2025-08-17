//
//  ImageLoader.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import UIKit

final class ImageLoader {
  static let shared = ImageLoader(); private init() {}
  private let cache = NSCache<NSURL, UIImage>()

  func load(_ urlString: String?, into imageView: UIImageView) {
    imageView.image = nil
    guard let s = urlString, let url = URL(string: s) else { return }
    if let cached = cache.object(forKey: url as NSURL) { imageView.image = cached; return }
    URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
      guard let data = data, let img = UIImage(data: data) else { return }
      self?.cache.setObject(img, forKey: url as NSURL)
      DispatchQueue.main.async { imageView.image = img }
    }.resume()
  }
}
