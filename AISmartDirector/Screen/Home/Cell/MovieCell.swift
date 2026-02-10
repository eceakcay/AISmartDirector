//
//  MovieCell.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 9.02.2026.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - MovieCell
class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        return iv
    }()
    
    private let gradientOverlay: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradient.locations = [0.5, 1.0]
        return gradient
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.2)
        view.layer.cornerRadius = 8
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
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientOverlay.frame = posterImageView.bounds
    }
    
    private func setupCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        posterImageView.layer.addSublayer(gradientOverlay)
        containerView.addSubview(titleLabel)
        containerView.addSubview(ratingContainer)
        ratingContainer.addSubview(starImageView)
        ratingContainer.addSubview(ratingLabel)
        
        // Shadow effect
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ratingContainer.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title

        if let rating = movie.voteAverage {
            ratingLabel.text = String(format: "%.1f", rating)
            ratingContainer.isHidden = false
        } else {
            ratingContainer.isHidden = true
        }

        posterImageView.kf.setImage(
            with: movie.posterURL,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
    }

}
