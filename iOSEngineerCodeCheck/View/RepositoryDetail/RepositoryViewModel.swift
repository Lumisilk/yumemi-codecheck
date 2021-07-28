//
//  RepositoryViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by ribilynn on 2021/07/27.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol RepositoryViewModelProtocol: ObservableObject {
    var repository: Repository? { get }
    var isLoading: Bool { get }
    var error: Error? { get set }
    func loadRepository()
}

final class RepositoryViewModel: RepositoryViewModelProtocol {
    let client: Client
    var cancellable: AnyCancellable?
    let ownerName: String
    let repositoryName: String
    
    @Published var repository: Repository?
    @Published var isLoading = false
    @Published var error: Error?
    
    init(client: Client, ownerName: String, repositoryName: String) {
        self.client = client
        self.ownerName = ownerName
        self.repositoryName = repositoryName
    }
    
    func loadRepository() {
        isLoading = true
        let request = RepositoryRequest(ownerName: ownerName, repositoryName: repositoryName)
        cancellable = client.send(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.error = error
                }
            }, receiveValue: { [weak self] repository in
                self?.repository = repository
            })
    }
}
