//
//  UIImageView+NatureAway.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/19/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation

extension UIImageView {
    func asyncLoadWithUrl(url: NSURL) {
        let request = NSURLRequest(URL: url)
        asyncLoadWithUrlRequest(request)
    }
    
    func asyncLoadWithUrlRequest(request: NSURLRequest) {
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            let image = UIImage(data: data)
            self.image = image
        }
    }
}