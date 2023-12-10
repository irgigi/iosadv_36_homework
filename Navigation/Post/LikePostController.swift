//
//  LikePostController.swift
//  Navigation

import CoreData
import UIKit

final class LikePostController: UIViewController {
    
    private let likeService = LikeService()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            LikeTableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return tableView
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonTupped))
        return button
    }()
    
    private lazy var clearfilterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearFilterButtonTupped))
        return button
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
        initialFetch()
        view.backgroundColor = .lightGray
        title = "Избранное"
        layout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        self.tableView.reloadData()
    }
    
    @objc func filterButtonTupped() {
        let alertController = UIAlertController(title: "filter by author", message: "enter author's name", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "author's name"
        }
        
        let applyAction = UIAlertAction(title: "apply", style: .default) { [weak self, weak alertController] (_) in
            if let authorName = alertController?.textFields?.first?.text {
                
                // домашка 9
                self?.fetchRezultController.fetchRequest.predicate = NSPredicate(format: "author CONTAINS %@", authorName)
                do {
                    try self?.fetchRezultController.performFetch()
                    self?.tableView.reloadData()
                } catch {
                    print("fetch error")
                }
                
                // домашка 8
                /*
                self?.likeService.fetchItems(authorName: authorName) { [weak self] list in
                    self?.data = list
                    self?.tableView.reloadData()
                }
                 */
            }
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(applyAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func clearFilterButtonTupped() {
        fetchRezultController.fetchRequest.predicate = nil
        do {
            try fetchRezultController.performFetch()
            tableView.reloadData()
        } catch {
            print("clear error")
        }

    }
        
    private func layout() {
        navigationItem.rightBarButtonItems = [clearfilterButton, filterButton]
        view.addSubview(tableView)
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
        
}

extension LikePostController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //data.count
        fetchRezultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? LikeTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        cell.autorLabel.text = fetchRezultController.object(at: indexPath).author
        cell.descriptionLabel.text = fetchRezultController.object(at: indexPath).text
        if let image = UIImage(named: fetchRezultController.object(at: indexPath).image!) {
            cell.imagePost.image = image
        }
        cell.likesLabel.text = ("Likes: " + fetchRezultController.object(at: indexPath).likes!)
        cell.viewsLabel.text = ("Views: " + fetchRezultController.object(at: indexPath).views!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            likeService.newDeliteObject(fetchRezultController.object(at: indexPath))
        }

    }
}

extension LikePostController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async { [weak self] in
            switch type {
            case .insert:
                guard let newIndexPath else { return }
                self?.tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .delete:
                guard let indexPath else { return }
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            case .move:
                guard let indexPath, let newIndexPath else { return }
                self?.tableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath else { return }
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            @unknown default:
                break
            }
        }
    }
}
