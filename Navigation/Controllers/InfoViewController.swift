//
//  InfoViewController.swift
//  Navigation

import UIKit

class InfoViewController: UIViewController {
    
    var residentsArray = [String]()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open", for: .normal)
        return button
       }()
    
    let jsonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    let planetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    // MARK: - table
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        tableView.backgroundColor = .systemTeal
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionHeaderTopPadding = 0
        
        JSONModel.request { [weak self ]result in
            DispatchQueue.main.async {
                switch result {
                case .success(let text):
                    self?.jsonLabel.text = text
                case .failure(_):
                    self?.jsonLabel.text = "Ошибка"
                }
            }
        }
       
        Planet.requestPlanets { [ weak self ] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let text):
                    self?.planetLabel.text = "Период обращения планеты Татуин вокруг своей звезды - \(text.orbitalPeriod)"
                case .failure(_):
                    self?.planetLabel.text = "Ошибка orbitalPeriod"
                }
            }
        }
        
        Planet.requestPlanets { [ weak self ] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    for residentURL in res.residents {
                        URLSession.shared.dataTask(with: residentURL) { data, response, error in
                            if error != nil {
                                print("Ошибка загрузки данных")
                                return
                            }
                            
                            if let data = data, let resident = try? JSONDecoder().decode(Residents.self, from: data) {
                                DispatchQueue.main.async {
                                    self?.residentsArray.append(resident.name)
                                    self?.tableView.reloadData()
                                }
                            }
                        } .resume()
                    }
                    
                case .failure(_):
                    self?.planetLabel.text = "Ошибка"
                }
            }
        }
    
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemTeal
        
        view.addSubview(actionButton)
        view.addSubview(jsonLabel)
        view.addSubview(planetLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            jsonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jsonLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            jsonLabel.widthAnchor.constraint(equalToConstant: 200),
    
            tableView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: planetLabel.topAnchor, constant: -30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            planetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetLabel.widthAnchor.constraint(equalToConstant: 200),
            planetLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
 
        actionButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    }
    
    @objc func showAlert() {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "action 1", style: .default) { _ in
            print("action 1 - done")
        }
        
        let action2 = UIAlertAction(title: "action 2", style: .default) { _ in
            print("action 2 - done")
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
}
extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Имена жителей планеты Татуин"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.contentView.frame.size.width = tableView.frame.width
        cell.backgroundColor = .systemTeal
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.text = residentsArray[indexPath.row]
        return cell
    }
    
    
}
