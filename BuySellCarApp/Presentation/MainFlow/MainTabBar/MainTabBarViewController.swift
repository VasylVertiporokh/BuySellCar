//
//  MainTabBarViewController.swift
//  MVVMSkeleton
//
//

import UIKit
import Combine

final class MainTabBarViewController: UITabBarController {
    // MARK: - Private properties
    private var viewModel: MainTabBarViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: MainTabBarViewModel, viewControllers: [UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinit
    deinit {
        print("Deinit of \(String(describing: self))")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.onViewDidLoad()
        setupBindings()
        viewControllers?.enumerated().reversed().forEach({ [unowned self] (ind, _) in
            selectedIndex = ind
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Setup MainTabBarViewController
private extension MainTabBarViewController {
    func setupUI() {
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .clear
        tabBar.tintColor = Colors.buttonDarkGray.color
        tabBar.bageViewHorisontalPosition(-5)
    }
    
    func setObjectCountForItem(_ count: Int, tabItem: TabBarItems) {
        tabBar.items?[tabItem.rawValue].badgeValue = count.isZero ? nil : "\(count)"
    }
    
    func setupBindings() {
        viewModel.eventPublisher
            .sink { [unowned self] event in
                switch event {
                case .numberOfFavorite(let count):
                    setObjectCountForItem(count, tabItem: .favorite)
                    
                case .numberOfOwnAds(let count):
                    setObjectCountForItem(count, tabItem: .selling)
                }
            }
            .store(in: &cancellables)
    }
}

private extension MainTabBarViewController {
    enum TabBarItems: Int, CaseIterable {
        case search
        case selling
        case favorite
        case settings
    }
}
