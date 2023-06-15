//
//  MainTextField.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.02.2023.
//

import UIKit
import CombineCocoa
import Combine

final class MainTextField: UITextField {
    // MARK: - Internal properties
    var showToolbar: Bool = false
    
    // MARK: - Private properties
    private let type: TextFieldType
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subjects
    private(set) lazy var deleteTextActionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<String?, Never>()
    
    private(set) lazy var doneButtonActionPublisher = doneButtonSubject.eraseToAnyPublisher()
    private let doneButtonSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Subviews
    private lazy var flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private lazy var doneToolbar = UIToolbar(frame: .init(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: Constants.toolBarHeight))
    private lazy var doneButton = UIBarButtonItem(title: Constants.buttonTitle, style: .done, target: nil, action: nil)
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onRightImageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gestureRecognizer)
        return imageView
    }()
    
    // MARK: - Init
    init(type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        configureTextField()
        setupBindings()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrided methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var inset = UIEdgeInsets(top: .zero, left: 36, bottom: .zero, right: .zero)
        if type == .editable || type == .plain {
            inset = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: .zero)
        }
        return bounds.inset(by: inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var inset = UIEdgeInsets(top: .zero, left: 36, bottom: .zero, right: .zero)
        if type == .editable || type == .plain {
            inset = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: .zero)
        }
        return bounds.inset(by: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        switch type {
        case .nickname, .password, .confirmPassword, .name, .email:
            return bounds.inset(by: .init(top: .zero, left: 36, bottom: .zero, right: .zero))
        case .editable:
            return bounds.inset(by: .init(top: .zero, left: 12, bottom: .zero, right: .zero))
        case .plain:
            return bounds.inset(by: .init(top: .zero, left: 12, bottom: .zero, right: .zero))
        }
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: 32))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: .zero))
    }
}

// MARK: - Private extension
private extension MainTextField {
    func configureTextField() {
        keyboardType = type.keyboardType
        isSecureTextEntry = type.needsSecureTextEntry
        attributedPlaceholder = type.placeholder
        font = FontFamily.Montserrat.regular.font(size: 14)
        autocorrectionType = .no
        smartQuotesType = .no
        addRightImageToTextField()
        addLeftImageToTextField()
        
        DispatchQueue.main.async {
            if self.showToolbar {
                self.doneToolbar.items = [self.flexSpace, self.doneButton]
                self.doneToolbar.sizeToFit()
                self.inputAccessoryView = self.doneToolbar
            }
        }
    }
    
    func addRightImageToTextField() {
        guard let image = type.rightImage else {
            return
        }
        rightImageView.tintColor = UIColor.black
        rightImageView.contentMode = .center
        rightImageView.image = image
        rightViewMode = .always
        rightView = rightImageView
    }
    
    func addLeftImageToTextField() {
        let imageView = UIImageView(image: type.leftImage)
        imageView.tintColor = UIColor.systemGray2
        imageView.contentMode = .center
        leftViewMode = .always
        leftView = imageView
    }
    
    func setupBindings() {
        DispatchQueue.main.async {
            if self.showToolbar {
                self.doneButton.tapPublisher
                    .sink { [unowned self] in
                        self.doneButtonSubject.send()
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
}

// MARK: - Actions
private extension MainTextField {
    @objc
    func onRightImageViewTapped() {
        switch type {
        case .password, .confirmPassword:
            isSecureTextEntry.toggle()
            rightImageView.image = isSecureTextEntry ? type.rightImage : UIImage(systemName: "eye")
        case .name, .email, .nickname:
            text = ""
            actionSubject.send(text)
        case .editable:
            self.becomeFirstResponder()
        case .plain:
            break
        }
    }
}

// MARK: - Constants
private struct Constants {
    static let toolBarHeight: CGFloat = 50
    static let buttonTitle: String = "Done"
}
