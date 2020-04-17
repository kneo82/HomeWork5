//
//  ContentView.swift
//  HomeWork5
//
//  Created by Vitaliy Voronok on 17.04.2020.
//  Copyright © 2020 Vitaliy Voronok. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 13.0, *)
public struct URLImage: View {
    @ObservedObject var imageURL: RemoteImageURL
    
    public init(imageUrl: String) {
        self.imageURL = RemoteImageURL(imageURL: imageUrl)
    }
    
    public var body: some View {
        if let image = imageURL.image {
            return Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            return Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

final class RemoteImageURL: ObservableObject {
    var didChange = PassthroughSubject<UIImage?, Never>()
    private var cancellable: AnyCancellable?
    
    @Published var image: UIImage? = nil {
        didSet {
            didChange.send(image)
        }
    }
    
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else {
            return
        }
        
        cancellable = ImageLoader.shared.loadImage(from: url).sink { [weak self] image in
            self?.image = image
        }
    }
}

public final class ImageLoader {
    public static let shared = ImageLoader()
    
    private let cache: ImageCacheType
    
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }
    
    public func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache[url] = image
            })
            .print("Image loading \(url):")
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

