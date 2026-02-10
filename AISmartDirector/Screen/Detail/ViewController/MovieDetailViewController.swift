//
//  MovieDetailViewController.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 10.02.2026.
//

import UIKit
import SnapKit

final class MovieDetailViewController: UIViewController {
    
    //MARK: - Properties
    private let movie: Movie
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    //MARK: - İnit
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Movie Detail"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(330)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    // MARK: - Configure
    private func configure() {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview ?? "Açıklama bulunamadı."
        
        if let url = movie.posterURL {
            loadImage(from: url)
        }
    }
    
    // MARK: - Image Loading (Basit)
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self,
                let data,
                let image = UIImage(data: data)
            else { return }

            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }.resume()
    }
}
