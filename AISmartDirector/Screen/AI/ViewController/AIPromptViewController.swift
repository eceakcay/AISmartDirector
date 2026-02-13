//
//  AIPromptViewController.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 13.02.2026.
//

import UIKit
import SnapKit

final class AIPromptViewController: UIViewController {
    
    weak var coordinator: AppCoordinator?
    
    // MARK: - UI
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0).cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "sparkles")
        iv.tintColor = .systemPink
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AI Film Asistanı"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ne tür filmler izlemek istersiniz?"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(white: 0.6, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0.15, alpha: 1)
        tf.textColor = .white
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(white: 0.3, alpha: 1.0).cgColor
        tf.attributedPlaceholder = NSAttributedString(
            string: "Örn: Romantik komedi, aksiyon dolu...",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        tf.setLeftPaddingPoints(16)
        tf.setRightPaddingPoints(16)
        return tf
    }()
    
    private let generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✨ Öneri Oluştur", for: .normal)
        button.backgroundColor = .systemPink
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
        // Shadow
        button.layer.shadowColor = UIColor.systemPink.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismiss()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        title = "AI Asistan"
        
        // Navigation bar
        setupNavigationBar()
        
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(textField)
        view.addSubview(generateButton)
        view.addSubview(activityIndicator)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        generateButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(generateButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        generateButton.addTarget(self, action: #selector(generateTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 0.95)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @objc private func generateTapped() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            showEmptyAlert()
            return
        }
        
        activityIndicator.startAnimating()
        generateButton.isEnabled = false
        textField.isEnabled = false
        
        coordinator?.generateAIRecommendation(prompt: text)
    }
    
    private func showEmptyAlert() {
        let alert = UIAlertController(
            title: "Boş Alan",
            message: "Lütfen ne tür filmler izlemek istediğinizi yazın",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
        rightView = paddingView
        rightViewMode = .always
    }
}
