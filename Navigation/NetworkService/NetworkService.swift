//
//  NetworkService.swift
//  Navigation


import UIKit



enum ApiError: Error {
    
    case networkError
    case notFound
    case invalidInput
    
}

final class NetworkService {

    var photosViewController: PhotosViewController

    
    init(photosViewController: PhotosViewController) {
        self.photosViewController = photosViewController
    }
    
    // массив с фото
    func getPhotos(arrayPhotos: [UIImage]) throws {
        if arrayPhotos == photosViewController.photos {
            print("фото загружены")
        } else if arrayPhotos .isEmpty {
            throw ApiError.notFound
        } else if arrayPhotos != photosViewController.photos {
            throw ApiError.invalidInput
        } else {
            throw ApiError.networkError
        }
    }
    // массив с обработтанными фото
    func chanchedPhoto(array: [UIImage], completion: @escaping (Result<[UIImage], ApiError>) -> Void) {
        if array == photosViewController.processedPhotos {
            completion(.success(array))
        } else {
            completion(.failure(.invalidInput))
        }
    }
}

