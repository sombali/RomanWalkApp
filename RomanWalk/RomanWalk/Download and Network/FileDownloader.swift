//
//  ImageDownloader.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 16..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftEventBus

class FileDownloader {
    func save(url: URL?, name: String?, completion: @escaping (Result<String, DownloadError>) -> (Void)) {
        guard let url = url, let name = name else { return }
        
        let downloadTask = URLSession.shared.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in
            
            if let _ = errorOrNil {
                completion(.failure(DownloadError.imageDownloadError))
                return
            }
            
            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                var savedURL = documentsURL.appendingPathComponent(name)
                savedURL.appendPathExtension("png")
                if !FileManager.default.fileExists(atPath: savedURL.path) {
                    try FileManager.default.moveItem(at: fileURL, to: savedURL)
                } else {
                    try FileManager.default.removeItem(at: savedURL)
                    try FileManager.default.moveItem(at: fileURL, to: savedURL)
                }
                DispatchQueue.main.async {
                    completion(.success(savedURL.lastPathComponent))
                }
            } catch {
                completion(.failure(DownloadError.imageDownloadError))
                return
            }
        }
        downloadTask.resume()
    }
}
