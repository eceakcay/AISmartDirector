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

    }
}
