//
//  NoteTableViewCell.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import UIKit
import SDWebImage

/// The cell to displaly note details.
final class NoteTableViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private let containerView = UIView()
    private let containerStackView = UIStackView()
    private let noteImageView = UIImageView()
    private let noteTitleLabel = UILabel()
    private let dotContainerView = UIView()
    private let dotIndicatorView = UIView()
    private let loadingIndicatorView = UIActivityIndicatorView()
    
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: self)
    private struct Constant {
        static let noteImageViewHeightAndWidth: CGFloat = 80
        static let dotContainerViewHeightAndWidth: CGFloat = 80
        static let dotIndicatorViewViewHeightAndWidth: CGFloat = 22
        static let noteTextLabelFontSize: CGFloat = 17
        static let containerStackViewSpacing: CGFloat = 15
        static let containerViewBottom: CGFloat = -2
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    // MARK: - Public Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        noteImageView.sd_cancelCurrentImageLoad()
    }
    
    func update(imageURLString: String?, title: String, dotIndicatorState state: NoteDotIndicatorState = .created) {
        if let imageURLString = imageURLString,
            let imageURL = URL(string: imageURLString) {
            // Resize the image due it is big to load as thumbnail on the table view.
            let heightAndWidth = Constant.noteImageViewHeightAndWidth
            let transformer = SDImageResizingTransformer(size: CGSize(width: heightAndWidth, height: heightAndWidth), scaleMode: .fill)
            // TODO: Add placeholder image.
            noteImageView.sd_setImage(with: imageURL, placeholderImage: nil, context: [.imageTransformer: transformer])
        } else {
            noteImageView.image = nil
        }
        update(title: title, dotIndicatorState: state)
    }
    
    func update(image: UIImage?, title: String, dotIndicatorState state: NoteDotIndicatorState = .created) {
        if let image = image {
            noteImageView.image = image
        } else {
            noteImageView.image = nil
        }
        update(title: title, dotIndicatorState: state)
    }
    
    // MARK: - Private Functions
    
    private func update(title: String, dotIndicatorState state: NoteDotIndicatorState = .created) {
        noteTitleLabel.text = title
        switch state {
        case .created, .error:
            loadingIndicatorView.stopAnimating()
            dotIndicatorView.backgroundColor = (state == .created) ? .greenDot : .redDot
            dotIndicatorView.isHidden = false
        case .loading:
            dotIndicatorView.isHidden = true
            loadingIndicatorView.startAnimating()
        }
    }
    
    private func configureView() {
        selectionStyle = .gray
        configureContainerView()
        configureContainerStackView()
        configureNoteImageView()
        configureNoteTitleLabel()
        configureDotContainerView()
        configureDotIndicatorView()
        configureLoadingIndicatorView()
    }
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constant.containerViewBottom),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)])
    }
    
    private func configureContainerStackView() {
        containerView.addSubview(containerStackView)
        containerStackView.axis = .horizontal
        containerStackView.distribution = .fill
        containerStackView.alignment = .fill
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)])
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
    
    private func configureNoteTitleLabel() {
        containerStackView.addArrangedSubview(noteTitleLabel)
        noteTitleLabel.textAlignment = .center
        noteTitleLabel.font = .boldSystemFont(ofSize: Constant.noteTextLabelFontSize)
        noteTitleLabel.textColor = .black
        noteTitleLabel.adjustsFontSizeToFitWidth = true
        noteTitleLabel.minimumScaleFactor = 0.5
        noteTitleLabel.numberOfLines = 0
    }
    
    private func configureDotContainerView() {
        containerStackView.addArrangedSubview(dotContainerView)
        dotContainerView.backgroundColor = UIColor(red: 0.858, green: 0.858, blue: 0.858, alpha: 1)
        dotContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dotContainerView.heightAnchor.constraint(equalToConstant: Constant.dotContainerViewHeightAndWidth),
            dotContainerView.widthAnchor.constraint(equalToConstant: Constant.dotContainerViewHeightAndWidth)])
    }
    
    private func configureDotIndicatorView() {
        dotContainerView.addSubview(dotIndicatorView)
        dotIndicatorView.backgroundColor = .redDot
        dotIndicatorView.layer.cornerRadius = Constant.dotIndicatorViewViewHeightAndWidth / 2;
        dotIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dotIndicatorView.heightAnchor.constraint(equalToConstant: Constant.dotIndicatorViewViewHeightAndWidth),
            dotIndicatorView.widthAnchor.constraint(equalToConstant: Constant.dotIndicatorViewViewHeightAndWidth),
            dotIndicatorView.centerYAnchor.constraint(equalTo: dotContainerView.centerYAnchor),
            dotIndicatorView.centerXAnchor.constraint(equalTo: dotContainerView.centerXAnchor)])
    }
    
    private func configureLoadingIndicatorView() {
        dotContainerView.addSubview(loadingIndicatorView)
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.stopAnimating()
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerYAnchor.constraint(equalTo: dotContainerView.centerYAnchor),
            loadingIndicatorView.centerXAnchor.constraint(equalTo: dotContainerView.centerXAnchor)])
    }
}

/// Not dot indicator view state.
enum NoteDotIndicatorState {
    case created
    case error
    case loading
}

// TODO: Implement a better approach to obtain colors.
private extension UIColor {
    static let redDot = UIColor(red: 0.918, green: 0.247, blue: 0.345, alpha: 1)
    static let greenDot = UIColor(red: 0.298, green: 0.851, blue: 0.392, alpha: 1)
}
