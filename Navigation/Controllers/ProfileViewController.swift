//
//  ProfileViewController.swift
//  Navigation
//
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    private let likeService: LikeService
    
    let profileTableHeaderView = ProfileTableHeaderView()
    
    
    enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
    
    private enum HeaderFooterReuseID: String {
        case base = "TableSelectionFooterHeaderView_ReuseID"
    }
   
    // MARK: - Data
    
    fileprivate let data = PostModel.make()
    
    // MARK: - table
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
       
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.base.rawValue
        )
        
        tableView.setAndLayout(headerView: profileTableHeaderView)
        
        tableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.custom.rawValue)
        
        tableView.register(
            ProfileTableHeaderView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.base.rawValue
        )
         
        tableView.delegate = self
        tableView.dataSource = self
        
        
        return tableView
    }()
    
    private lazy var fetchRezultController: NSFetchedResultsController<DataBaseModel> = {
        let request = DataBaseModel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "image", ascending: false)]
        let fetchRezultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: likeService.backgroundContext , sectionNameKeyPath: nil, cacheName: nil)
        fetchRezultController.delegate = self
        return fetchRezultController
    }()
    
    private func initialFetch() {
        try? fetchRezultController.performFetch()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        title = "Profile" 
        initialFetch()
        tableView.addSubview(profileTableHeaderView)
        view.addSubview(tableView)
        setupConstraints()
    }
    
    init(likeService: LikeService) {
        self.likeService = likeService
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func doubleTapClickAction(_ sender: UITapGestureRecognizer) {
        let message = "saved"
        if sender.state == .recognized {
            if sender.view is PostTableViewCell {
                if let indexPathRow = sender.view?.tag {
                    let info = data[indexPathRow]
                    let alertController = UIAlertController(title: info.image, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ok", style: .default)
                    alertController.addAction(okAction)
                    //получение данных домашка 9
                    if let allObjects = fetchRezultController.fetchedObjects {
                        for i in allObjects {
                            if i.image == info.image {
                                print("фото уже есть")
                                return
                            } else {
                                continue
                            }
                        }
                        self.present(alertController, animated: true)
                        
                        // сохранение домашка 9
                        self.likeService.newSaveObject(author: info.author, text: info.description, image: info.image, likes: String(describing: info.likes), views: String(describing: info.views))
                        
                        self.tableView.reloadData()
                    }
                    
                } else {
                    print("ошибка сохранения")
                }
            }
        }
    }

 
    func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        profileTableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

   
      
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor)
            
        ])
        
    }
     
}

extension UITableView {
    
    func setAndLayout(headerView: UIView) {
        tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return data.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.custom.rawValue,
                for: indexPath
            ) as? PhotosTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            //cell.update(data[indexPath.row])
            cell.contentView.frame.size.width = tableView.frame.width
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.base.rawValue,
                for: indexPath
            ) as? PostTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            
            cell.tag = indexPath.row
            let doubleTapClick = UITapGestureRecognizer(target: self, action: #selector(doubleTapClickAction(_:)))
            doubleTapClick.numberOfTapsRequired = 2
            cell.addGestureRecognizer(doubleTapClick)
            cell.update(data[indexPath.row])
            
            return cell
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        
        if section == 0 {
            
            return 250
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 190
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        
        if section == 0 {
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: HeaderFooterReuseID.base.rawValue
            ) as? ProfileTableHeaderView else {
                fatalError("could not dequeueReusableCell")
            }
            
            return headerView
            
        } else {
            
            return nil
            
        }
       
    }
    
}

extension ProfileViewController: NSFetchedResultsControllerDelegate {
    
}



