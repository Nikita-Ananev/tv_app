//
//  ChannelTableViewCell.swift
//  testWorkLimex
//
//  Created by Никита Ананьев on 29.09.2022.
//

import UIKit

protocol ViewControllerButtonDelegate: AnyObject {
    func favoriteButtonPressed(id: String)
}
class ChannelTableViewCell: UITableViewCell {
    
    
    var isFavorite: Bool?
    var channel: Channel? {
        didSet {
            nameLabel.text = channel?.name_ru
            descriptionLabel.text = channel?.current.title
            image.imageFromServerURL(channel!.image, placeHolder: image.image)
        }
    }
    var delegate: ViewControllerButtonDelegate?
    
    let favoriteButton: UIButton = {
        let btn = UIButton()

        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        
        
        return label
    }()
    var image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 4
        return img
        
    }()
    var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 35/256, green: 36/256, blue: 39/256, alpha: 1)
        addSubview(cellView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(descriptionLabel)
        cellView.addSubview(image)
        cellView.addSubview(favoriteButton)
        
        contentView.heightAnchor.constraint(equalToConstant: 82).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: super.frame.width).isActive = true
        contentView.topAnchor.constraint(equalTo: super.topAnchor, constant: 0).isActive = true
        contentView.leftAnchor.constraint(equalTo: super.leftAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: super.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: super.bottomAnchor, constant: 0).isActive = true
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        cellView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        
        cellView.backgroundColor = UIColor(red: 49/256, green: 46/256, blue: 53/256, alpha: 1)
        
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8).isActive = true
        image.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 8).isActive = true
        image.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8).isActive = true
        
        nameLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        nameLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 14).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -60).isActive = true
        
        descriptionLabel.textColor = UIColor(red: 233/255, green: 234/255, blue: 239/255, alpha: 1)
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -60).isActive = true
        
        
        favoriteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 26).isActive = true
        favoriteButton.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -26).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -16).isActive = true
        favoriteButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        // MARK: костыль = contentView ячейки в иерархии выше и  не позвалает нажать на кнопку
        contentView.isHidden = true
        
    }
    @objc func didTapButton() {
        delegate?.favoriteButtonPressed(id: String(channel!.id))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        favoriteButton.setImage(self.isFavorite! ? UIImage(systemName: "star.fill"): UIImage(systemName: "star"), for: .normal)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
