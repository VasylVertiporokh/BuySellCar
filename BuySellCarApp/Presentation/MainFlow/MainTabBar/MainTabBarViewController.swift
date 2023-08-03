//
//  MainTabBarViewController.swift
//  MVVMSkeleton
//
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    private var viewModel: MainTabBarViewModel

    init(viewModel: MainTabBarViewModel, viewControllers: [UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinit of \(String(describing: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        tabBar.tintColor = Colors.buttonDarkGray.color
    }
}
