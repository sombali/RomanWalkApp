//
//  ImageDownloader.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 17..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation

protocol DownloadedImageData {
    var image: URL? { get }
    var name: String? { get }
    var fileName: String? { get set}
}
