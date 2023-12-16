//
//  PostTableViewCell.swift
//  Navigation

import UIKit

class PostTableViewCell: UITableViewCell {
    
    let profileTableHeaderView = ProfileTableHeaderView()
    
    
    // MARK: -
    
    lazy var autorLabel: UILabel = {
        let label = UILabel()
        //label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var imagePost: UIImageView = {
        let image = UIImageView()
        let screenWidth = UIScreen.main.bounds.width
        //image.backgroundColor = .black
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
      /*
        image.transform = CGAffineTransform(scaleX: UIScreen.main.bounds.width/image.bounds.width, y: UIScreen.main.bounds.width/image.bounds.width)
       */
        return image
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        //label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        //label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var viewsLabel: UILabel = {
        let label = UILabel()
        //label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let stackForLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 250
        
        return stackView
    }()
    
    
    // MARK: - Lifecycle
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .subtitle,
            reuseIdentifier: reuseIdentifier
        )
        
        stackForLabels.addArrangedSubview(likesLabel)
        stackForLabels.addArrangedSubview(viewsLabel)
     
        addSubviewInCell()
        
        consraintInCell()


      //  tuneView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isHidden = false
        isSelected = false
        isHighlighted = false
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let view = selectedBackgroundView else {
            return
        }
        
        contentView.insertSubview(view, at: 0)
        selectedBackgroundView?.isHidden = !selected
    }
    
    func addSubviewInCell() {
        
        let subviews = [autorLabel, imagePost, stackForLabels, descriptionLabel]
        for subview in subviews {
            addSubview(subview)
        }
        
    }

    func update(_ model: PostModel) {
        
        autorLabel.text = model.author
        imagePost.image = UIImage(named: model.image)
        descriptionLabel.text = model.description
        
        //множественные формы, реализация
        let likes = model.likes
        let views = model.views
        
        var tableName = ""
        
        if SceneDelegate.language == "english" {
            tableName = "Plurals(English)"
        } else if SceneDelegate.language == "русский" {
            tableName = "Plurals(Russian)"
        }
        
        let localizedViews = NSLocalizedString("Views", tableName: tableName, comment: "-")
        let localizedLikes = NSLocalizedString("Likes", tableName: tableName, comment: "-")
        
        let formattedViews = String(format: localizedViews, views)
        let formattedLikes = String(format: localizedLikes, likes)
        likesLabel.text = formattedLikes
        viewsLabel.text = formattedViews
        }
    

    
    func consraintInCell() {
        
        autorLabel.translatesAutoresizingMaskIntoConstraints = false
        imagePost.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackForLabels.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            autorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            autorLabel.bottomAnchor.constraint(equalTo: imagePost.topAnchor, constant: 12),
            autorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            autorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            autorLabel.widthAnchor.constraint(equalTo: widthAnchor),
            autorLabel.heightAnchor.constraint(equalToConstant: 50),
            
            imagePost.topAnchor.constraint(equalTo: autorLabel.bottomAnchor),
            imagePost.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            imagePost.leadingAnchor.constraint(equalTo: leadingAnchor),
            imagePost.centerXAnchor.constraint(equalTo: centerXAnchor),
            imagePost.trailingAnchor.constraint(equalTo: trailingAnchor),
            imagePost.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imagePost.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            descriptionLabel.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: stackForLabels.topAnchor),
            
            stackForLabels.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: -16),
            stackForLabels.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackForLabels.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackForLabels.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackForLabels.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackForLabels.widthAnchor.constraint(equalTo: widthAnchor),
            
            likesLabel.topAnchor.constraint(equalTo: stackForLabels.topAnchor),
            likesLabel.trailingAnchor.constraint(equalTo: viewsLabel.leadingAnchor, constant: -100),
            likesLabel.leadingAnchor.constraint(equalTo: stackForLabels.leadingAnchor),
            //likesLabel.leftAnchor.constraint(equalTo: leftAnchor),
            likesLabel.bottomAnchor.constraint(equalTo: stackForLabels.bottomAnchor),
            
            viewsLabel.topAnchor.constraint(equalTo: stackForLabels.topAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: stackForLabels.trailingAnchor, constant: 10),
            //viewsLabel.rightAnchor.constraint(equalTo: rightAnchor),
            viewsLabel.bottomAnchor.constraint(equalTo: stackForLabels.bottomAnchor),
            viewsLabel.widthAnchor.constraint(equalToConstant: 250),
    

        

      
        ])
        
    }
        
        
    
}
