//
//  NotesCoordinator.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import UIKit

/// The coordinator for NotesCoordinator.
final class NotesCoordinator: Coordinator {
    
    // MARK: - Properties

    private let window: UIWindow
    private var notesViewController: NotesViewController?
    private var createNoteCoordinator: CreateNoteCoordinator?
    private let navigationController = UINavigationController()
    weak var delegate: NotesCoordinatorDelegate?
    var rootViewController: UIViewController {
        return navigationController
    }

    // MARK: - Initializers

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Public Functions

    func start() {
        let vm = NotesViewModel(coordinator: self)
        let vc = NotesViewController(viewModel: vm)
        vm.viewDelegate = vc
        notesViewController = vc
        navigationController.viewControllers = [vc]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

// MARK: - NotesCoordinatorProtocol

extension NotesCoordinator: NotesCoordinatorProtocol {
    
    func notesShowCreateNoteView(_ vm: NotesViewModelProtocol) {
        createNoteCoordinator = CreateNoteCoordinator(navigationController: navigationController)
        createNoteCoordinator?.delegate = self
        createNoteCoordinator?.start()
    }
}

// MARK: - CreateNoteCoordinatorDelegate

extension NotesCoordinator: CreateNoteCoordinatorDelegate {
    
    func createNoteCoordinatorDidFinish() {
        createNoteCoordinator = nil
    }
    
    func createNoteCoordinatorDidCreateNote() {
        createNoteCoordinator = nil
        guard let notesViewController = notesViewController else {
            assertionFailure("notesViewController instance could not be nil")
            return
        }
        notesViewController.viewModel.noteCreated()
    }
}
