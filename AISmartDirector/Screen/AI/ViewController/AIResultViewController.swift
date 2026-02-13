//
//  AIResultViewController.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 13.02.2026.
//

import UIKit
import SnapKit

final class AIResultViewController: UIViewController {

    // MARK: - Properties
    private let prompt: String // ✅ Ekledik
    private let movies: [Movie]
    weak var coordinator: AppCoordinator?
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return cv
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0).cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    // ✅ Prompt göster
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(white: 0.6, alpha: 1.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    init(prompt: String, movies: [Movie]) { // ✅ Düzelttik
        self.prompt = prompt
        self.movies = movies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        title = "AI Önerileri"
        
        // Navigation bar styling
        setupNavigationBar()
        
        view.addSubview(promptLabel)
        view.addSubview(collectionView)
        
        promptLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(promptLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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
    
    private func configure() {
        promptLabel.text = "💡 \"\(prompt)\""
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        let itemsPerRow: CGFloat = 2
        
        let totalSpacing = spacing * (itemsPerRow + 1)
        let width = (UIScreen.main.bounds.width - totalSpacing) / itemsPerRow
        let height = width * 1.5
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }
}

extension AIResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.identifier,
            for: indexPath
        ) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: movies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        coordinator?.showMovieDetail(movie: movie)
    }
}
