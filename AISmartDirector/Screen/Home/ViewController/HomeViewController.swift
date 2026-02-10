//
//  HomeViewController.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: HomeViewModelProtocol
    private var movies: [Movie] = []
    weak var coordinator: AppCoordinator?

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black  // Siyah arka plan
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return cv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white  // Beyaz spinner
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // Gradient background için
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0).cgColor,  // Koyu mavi-siyah
            UIColor.black.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    // MARK: - Init
    init(viewModel: HomeViewModelProtocol) {
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
        bindViewModel()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - setupUI
    private func setupUI() {
        // Gradient arka plan
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Navigation bar styling
        setupNavigationBar()
        
        title = "AI Smart Director"
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        // Koyu tema navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 0.95)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // Ekran genişliğine göre dinamik boyutlandırma
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 16
        let itemsPerRow: CGFloat = 2
        let totalSpacing = spacing * (itemsPerRow + 1)
        let itemWidth = (screenWidth - totalSpacing) / itemsPerRow
        let itemHeight = itemWidth * 1.5  // 2:3 aspect ratio
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleState(state)
            }
        }
    }
    
    private func loadData() {
        Task {
            await viewModel.loadMovies()
        }
    }
}

// MARK: - State Handling
extension HomeViewController {
    private func handleState(_ state: HomeViewState) {
        switch state {
        case .idle: break
        case .loading:
            activityIndicator.startAnimating()
            collectionView.isHidden = true
        case .loaded(let loadedMovies):
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
            self.movies = loadedMovies
            collectionView.reloadData()
        case .error(let message):
            activityIndicator.stopAnimating()
            showErrorAlert(message)
        }
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 0.8, green: 0.2, blue: 0.3, alpha: 1.0)  // Kırmızı tema
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - DataSource - ViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.identifier,
            for: indexPath
        ) as? MovieCell else { return UICollectionViewCell() }
        
        cell.configure(with: movies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        coordinator?.showMovieDetail(movie: movie)
    }
}
