//
//  CreateNote.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import UIKit

/// The coordinator for CreateNoteCoordinator.
final class CreateNoteCoordinator: NSObject, Coordinator {
    
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private lazy var imagePicker = UIImagePickerController()
    private var createNoteViewController: CreateNoteViewController?
    weak var delegate: CreateNoteCoordinatorDelegate?
    var rootViewController: UIViewController {
        return navigationController
    }
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Functions
    
    func start() {
        let vm = CreateNoteViewModel(coordinator: self)
        let vc = CreateNoteViewController(viewModel: vm)
        vm.viewDelegate = vc
        createNoteViewController = vc
        rootViewController.present(vc, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func alertAction(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let imagePicker = self?.imagePicker,
                let vc = self?.createNoteViewController else {
                    assertionFailure("imagePicker instance could not be nil")
                    return
            }
            imagePicker.sourceType = type
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            vc.present(imagePicker, animated: true)
        }
    }
    
    public func showChooseImageActionSheet() {
        let alertController = UIAlertController(title: .chooseImage, message: nil, preferredStyle: .actionSheet)
        if let action = alertAction(for: .camera, title: .takePhoto) {
            alertController.addAction(action)
        }
        if let action = alertAction(for: .savedPhotosAlbum, title: .cameraRoll) {
            alertController.addAction(action)
        }
        if let action = alertAction(for: .photoLibrary, title: .photoLibrary) {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: .cancel, style: .cancel))
        
        guard let vc = createNoteViewController else {
            assertionFailure("createNoteViewController instance could not be nil")
            return
        }
        vc.present(alertController, animated: true)
    }
}

// MARK: - NotesCoordinatorProtocol

extension CreateNoteCoordinator: CreateNoteCoordinatorProtocol {
    
    func createNoteDidFinish(_ vm: CreateNoteViewModelProtocol) {
        rootViewController.dismiss(animated: true)
        // Remove instance from memory.
        delegate?.createNoteCoordinatorDidFinish()
    }
    
    func createNoteChooseImage(_ vm: CreateNoteViewModelProtocol) {
        showChooseImageActionSheet()
    }
    
    func createNoteShowErrorAlert(_ vm: CreateNoteViewModelProtocol, message: String) {
        let alertController = UIAlertController(title: .errorTitle, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: .cancel, style: .cancel))
        
        guard let vc = createNoteViewController else {
            assertionFailure("createNoteViewController instance could not be nil")
            return
        }
        vc.present(alertController, animated: true)
    }
    
    func createNoteDidCreateNote(_ vm: CreateNoteViewModelProtocol) {
        rootViewController.dismiss(animated: true)
        delegate?.createNoteCoordinatorDidCreateNote()
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CreateNoteCoordinator: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage,
            let vc = createNoteViewController {
            // TODO: Move image size to a constant file.
            let imageScaleDownSize = CGSize(width: 240, height: 240)
            let imageScaledDown = image.scaledDown(into: imageScaleDownSize)
            let highJPEGQuality: CGFloat = 0.75
            vc.viewModel.imageSelectedData = imageScaledDown.jpegData(compressionQuality: highJPEGQuality)
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension CreateNoteCoordinator: UINavigationControllerDelegate {}

// MARK: - Localized Strings

private extension String {
    static let chooseImage = NSLocalizedString("Choose Image", comment: "Action sheet alert title")
    static let cancel = NSLocalizedString("Cancel", comment: "Button title")
    static let takePhoto = NSLocalizedString("Take photo", comment: "Button title")
    static let cameraRoll = NSLocalizedString("Camera roll", comment: "Button title")
    static let photoLibrary = NSLocalizedString("Photo library", comment: "Button title")
    static let errorTitle = NSLocalizedString("Oops!", comment: "Alert title")
}
