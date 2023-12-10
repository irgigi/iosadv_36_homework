//
//  ProfileTableHeaderView.swift
//  Navigation

//

import UIKit

class ProfileTableHeaderView: UIView {
    
    
    // MARK: - Data
    
  //  fileprivate let data = PostModel.make()
    
    // MARK: - Subviews
  /*
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    private enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
   */
    
    // MARK: -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let profileHeaderView = ProfileHeaderView()
        self.addSubview(profileHeaderView)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let safeAreaGuide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        
        ])
    }
    
}



