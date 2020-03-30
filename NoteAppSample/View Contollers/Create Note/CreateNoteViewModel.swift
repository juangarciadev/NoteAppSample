//
//  CreateNoteViewModel.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation

/// Defines view model for CreateNoteViewController.
final class CreateNoteViewModel: CreateNoteViewModelProtocol {
    
    // MARK: - Properties
    
    weak var viewDelegate: CreateNoteViewDelegate?
    weak var coordinator: CreateNoteCoordinatorProtocol?
    var imageSelectedData: Data? {
        didSet {
            viewDelegate?.updateUI()
        }
    }
    
    // MARK: - Initializer
    
    required init(coordinator: CreateNoteCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public Functions
    
    func viewDidLoad() {
        viewDelegate?.updateUI()
    }
    
    func didTapDismiss() {
        coordinator?.createNoteDidFinish(self)
    }

    func createNote(with title: String) {
        guard !title.isEmpty else {
            coordinator?.createNoteShowErrorAlert(self, message: .enterATitle)
            return
        }
        guard let imageSelectedData = imageSelectedData else {
            coordinator?.createNoteShowErrorAlert(self, message: .chooseAnImage)
            return
        }
        
        do {
            try NoteStore.createNote(with: imageSelectedData, title: title)
            coordinator?.createNoteDidCreateNote(self)
        } catch {
            coordinator?.createNoteShowErrorAlert(self, message: .somethingWentWrong)
        }
    }
    
    func didTapChooseImage() {
        coordinator?.createNoteChooseImage(self)
    }
}

// MARK: - Localized Strings

private extension String {
    static let enterATitle = NSLocalizedString("Please enter a title.", comment: "Title error")
    static let chooseAnImage = NSLocalizedString("Please choose an image.", comment: "Image error")
    static let somethingWentWrong = NSLocalizedString("Something went wrong.", comment: "Message error")
}
