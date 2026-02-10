//
//  MovieCell.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 9.02.2026.
//

import UIKit
import SnapKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell" // Tekrar kullanım için ID
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupCell() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        if let posterPath = movie.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            posterImageView.kf.setImage(with: URL(string: urlString))
            posterImageView.backgroundColor = .systemGray
        }
    }
}
