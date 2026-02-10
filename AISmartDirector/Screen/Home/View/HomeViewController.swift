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
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return cv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
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
    
    // MARK: - setupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
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
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 140, height: 220)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
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
        coordinator?.showMovieDetail(movie: movie)
    }
}

