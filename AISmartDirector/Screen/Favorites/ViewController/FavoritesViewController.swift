//
//  FavoritesViewController.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 12.02.2026.
//

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    private var favoriteMovies: [Movie] = []
    private var viewModel: FavoritesViewModelProtocol = FavoritesViewModel()
    weak var coordinator: AppCoordinator?
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return cv
    }()
    
    private let emptyStateView = UIView()
    
    private let emptyImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart.slash"))
        iv.tintColor = UIColor(white: 0.3, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz favori filminiz yok"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(white: 0.4, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Beğendiğiniz filmleri favorilere ekleyin"
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.3, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0).cgColor,
            UIColor.black.cgColor
        ]
        return gradient
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyLabel)
        emptyStateView.addSubview(emptySubtitleLabel)
        
        collectionView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        emptySubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = "Favorilerim"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch state {
                    
                case .idle:
                    break
                    
                case .loading:
                    break
                    
                case .empty:
                    self.favoriteMovies = []
                    self.updateEmptyState()
                    self.collectionView.reloadData()
                    
                case .loaded(let movies):
                    self.favoriteMovies = movies
                    self.updateEmptyState()
                    self.collectionView.reloadData()
                    
                case .error(let message):
                    print("Favorites Error:", message)
                }
            }
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = favoriteMovies.isEmpty
        emptyStateView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
}


// MARK: - CollectionView DataSource & Delegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.identifier,
            for: indexPath
        ) as? MovieCell else { return UICollectionViewCell() }
        
        cell.configure(with: favoriteMovies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = favoriteMovies[indexPath.item]
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        coordinator?.showMovieDetail(movie: movie)
    }
}
