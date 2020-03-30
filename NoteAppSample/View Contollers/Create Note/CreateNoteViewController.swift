//
//  CreateNoteViewController.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import UIKit

/// Create Note View Controller.
final class CreateNoteViewController: UIViewController, CreateNoteViewDelegate {
    
    // MARK: - UI
    
    private let cancelButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let containerStackView = UIStackView()
    private let noteTextView = UITextView()
    private let noteImageView = UIImageView()
    private let chooseImageButton = UIButton(type: .system)
    
    // MARK: - Properties
    
    private struct Constant {
        static let buttonsHeight: CGFloat = 44
        static let buttonsWidth: CGFloat = 125
        static let buttonsTop: CGFloat = 17
        static let buttonsLeadingOrTrailing: CGFloat = 16
        static let containerStackViewSpacing: CGFloat = 28
        static let containerStackViewLeadingOrTrailing: CGFloat = 16
        static let containerStackViewTop: CGFloat = 77
        static let noteImageViewHeightAndWidth: CGFloat = 82
        static let noteTextViewHeight: CGFloat = 47
        static let textFontSize: CGFloat = 17
        static let chooseImageButtonHeight: CGFloat = 46
    }
    
    // MARK: - Initializers
    
    required init(viewModel: CreateNoteViewModelProtocol) {
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
    
    var viewModel: CreateNoteViewModelProtocol
    
    func updateUI() {
        if let imageData = viewModel.imageSelectedData {
            noteImageView.image = UIImage(data: imageData)
        }
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        viewModel.didTapDismiss()
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        viewModel.createNote(with: noteTextView.text ?? "")
    }
    
    @objc private func chooseImageButtonTapped(_ sender: UIButton) {
        viewModel.didTapChooseImage()
    }
    
    // MARK: - Private Functions
    
    private func configureView() {
        view.backgroundColor = .white
        configureCancelButtons()
        configureDoneButtons()
        configureContainerStackView()
        configureNoteTextView()
        configureNoteImageView()
        configureChooseImageButton()
    }
    
    private func configureCancelButtons() {
        view.addSubview(cancelButton)
        cancelButton.setTitle(.cancel, for: .normal)
        cancelButton.contentHorizontalAlignment = .left;
        cancelButton.contentVerticalAlignment = .top;
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: Constant.buttonsHeight),
            cancelButton.widthAnchor.constraint(equalToConstant: Constant.buttonsWidth),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.buttonsTop),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.buttonsLeadingOrTrailing)])
    }
    
    private func configureDoneButtons() {
        view.addSubview(doneButton)
        doneButton.setTitle(.done, for: .normal)
        doneButton.contentHorizontalAlignment = .right;
        doneButton.contentVerticalAlignment = .top;
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: Constant.buttonsHeight),
            doneButton.widthAnchor.constraint(equalToConstant: Constant.buttonsWidth),
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.buttonsTop),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.buttonsLeadingOrTrailing)])
    }
    
    private func configureContainerStackView() {
        view.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        containerStackView.alignment = .center
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.containerStackViewTop),
            containerStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.containerStackViewLeadingOrTrailing),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.containerStackViewLeadingOrTrailing)])
    }
    
    private func configureNoteTextView() {
        containerStackView.addArrangedSubview(noteTextView)
        noteTextView.font = .systemFont(ofSize: Constant.textFontSize)
        noteTextView.textColor = .black
        noteTextView.textAlignment = .left
        noteTextView.becomeFirstResponder()
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTextView.heightAnchor.constraint(equalToConstant: Constant.noteTextViewHeight),
            noteTextView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor)])
    }
    
    private func configureNoteImageView() {
        containerStackView.addArrangedSubview(noteImageView)
        noteImageView.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        noteImageView.layer.masksToBounds = false
        noteImageView.clipsToBounds = true
        noteImageView.contentMode = .scaleAspectFill
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteImageView.heightAnchor.constraint(equalToConstant: Constant.noteImageViewHeightAndWidth),
            noteImageView.widthAnchor.constraint(equalToConstant: Constant.noteImageViewHeightAndWidth)])
    }
    
    private func configureChooseImageButton() {
        containerStackView.addArrangedSubview(chooseImageButton)
        chooseImageButton.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        chooseImageButton.setTitle(.chooseImage, for: .normal)
        chooseImageButton.setTitleColor(.black, for: .normal)
        chooseImageButton.titleLabel?.font = .systemFont(ofSize: Constant.textFontSize)
        chooseImageButton.addTarget(self, action: #selector(chooseImageButtonTapped(_:)), for: .touchUpInside)
        chooseImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chooseImageButton.heightAnchor.constraint(equalToConstant: Constant.chooseImageButtonHeight),
            chooseImageButton.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            chooseImageButton.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor)])
    }
}

// MARK: - Localized Strings

private extension String {
    static let cancel = NSLocalizedString("Cancel", comment: "Button title")
    static let done = NSLocalizedString("Done", comment: "Button title")
    static let chooseImage = NSLocalizedString("Choose Image", comment: "Button title")
}
