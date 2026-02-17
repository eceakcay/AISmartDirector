//
//  MovieDetailViewController.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 10.02.2026.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: MovieDetailViewModelProtocol
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0).cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    private let backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.alpha = 0.3
        return iv
    }()
    
    private let posterContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 16
        return view
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let ratingContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.15)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.3).cgColor
        return view
    }()
    
    private let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        return label
    }()
    
    private let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(white: 0.6, alpha: 1.0)
        label.text = "/10"
        return label
    }()
    
    private let overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📖 Özet"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0.85, alpha: 1.0)
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    // MARK: - Init
    init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        backdropImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 400)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        updateFavoriteUI()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteTapped() {
        viewModel.toggleFavorite()
        updateFavoriteUI()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    private func updateFavoriteUI() {
        let isFav = viewModel.isFavorite
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isFav ? "heart.fill" : "heart")
        navigationItem.rightBarButtonItem?.tintColor = isFav ? .systemPink : .white
    }
    
    private func setupUI() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(backdropImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [posterContainerView, titleLabel, releaseDateLabel, ratingContainer, dividerView, overviewTitleLabel, overviewLabel].forEach {
            contentView.addSubview($0)
        }
        
        posterContainerView.addSubview(posterImageView)
        [starImageView, ratingLabel, ratingCountLabel].forEach {
            ratingContainer.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        posterContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(360)
        }

        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        ratingContainer.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        ratingCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(ratingLabel.snp.trailing).offset(2)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(ratingLabel.snp.bottom)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(ratingContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        overviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func configure() {
        titleLabel.text = viewModel.movieTitle
        overviewLabel.text = viewModel.overview
        releaseDateLabel.text = viewModel.releaseDate
        ratingLabel.text = viewModel.rating
        
        posterImageView.kf.setImage(with: viewModel.posterURL, options: [.transition(.fade(0.4))])
        backdropImageView.kf.setImage(with: viewModel.posterURL, options: [.transition(.fade(0.4)), .processor(BlurImageProcessor(blurRadius: 8))])
    }
}
