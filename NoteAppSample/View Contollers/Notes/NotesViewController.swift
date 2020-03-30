//
//  NotesViewController.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import UIKit

/// Notes View Controller.
final class NotesViewController: UITableViewController, NotesViewDelegate {
    
    // MARK: - Initializers
    
    required init(viewModel: NotesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.viewDidLoad()
    }
    
    // MARK: - ViewDelegate
    
    var viewModel: NotesViewModelProtocol
    
    func updateUI() {
        // Restart cache.
        viewModel.removeAllNoteImageCache()
        tableView.reloadData()
    }
    
    func scrollTableViewToBottom() {
        let section = 0
        let lastRow = (viewModel.numberOfRows(in: section) - 1)
        tableView.scrollToRow(at: IndexPath(row: lastRow, section: section),
                              at: .bottom,
                              animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func createNoteButtonTapped(_ sender: UINavigationItem) {
        viewModel.showCreateNoteView()
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        viewModel.refreshNotes()
        sender.endRefreshing()
    }
    
    // MARK: - Private Functions
    
    private func configureView() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        title = .navigationTitle
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(createNoteButtonTapped(_:)))
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: .pullToRefresh)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }
}

// MARK: - UITableViewDataSource

extension NotesViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        if let note = viewModel.getNote(at: indexPath.row) {
            let dotIndicatorState: NoteDotIndicatorState
            switch viewModel.viewState {
            case .view:
                dotIndicatorState = note.uploaded ? .created : .error
            case .loading:
                dotIndicatorState = note.uploaded ? .created : .loading
            }
            
            if !note.imagePath.isEmpty {
                let noteImageCache = viewModel.getNoteImageCache(at: indexPath.row, imagePath: note.imagePath)
                cell.update(image: noteImageCache.imageStoredLocally,
                            title: note.title,
                            dotIndicatorState: dotIndicatorState)
            } else {
                cell.update(imageURLString: note.image?.small,
                            title: note.title,
                            dotIndicatorState: dotIndicatorState)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.refreshNotes()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Localized Strings

private extension String {
    static let navigationTitle = NSLocalizedString("Notes", comment: "Used on the navigation title")
    static let pullToRefresh = NSLocalizedString("Pull to refresh", comment: "User refresh title")
}
