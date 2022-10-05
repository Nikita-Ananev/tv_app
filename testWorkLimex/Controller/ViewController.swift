//
//  ViewController.swift
//  testWorkLimex
//
//  Created by Никита Ананьев on 28.09.2022.
//


import Foundation
import UIKit
import AVFoundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerButtonDelegate, ChannelSegmentedControlDelegate {
    
    private enum TableViewSelection {
        case all, favorite
    }
    
    private var selection = TableViewSelection.all
    private var isSearchActive:Bool = false
    
    //models
    private var channels: [Channel]?
    private var favoriteChannels = [Channel]()
    private var searchChannels = [Channel]()
    
    //UI
    private var searchView = UIView()
    private var searchTextField = UITextField()
    private var tableView: UITableView!
    private let imageView = UIImageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        Task {
            do {
                channels = try await NetworkManager.fetchChannels()
                
                for channel in channels! as [Channel] {
                    if let favorite = UserDefaults.standard.object(forKey: String(channel.id)) as? Bool {
                        if favorite {
                            favoriteChannels.append(channel)
                        }
                    } else {
                        UserDefaults.standard.set(false, forKey: String(channel.id))
                    }
                }
                tableView.reloadData()
            } catch {
                print("Request failed with error: \(error)")
            }
        }
        self.view.backgroundColor = UIColor(red: 52/256, green: 52/256, blue: 56/256, alpha: 1)
        setSearchViewUI()
        setTableView()
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OrientationUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        OrientationUtility.lockOrientation(.all)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch selection {
        case .all:
            searchChannels = self.channels!.filter( {$0.name_ru.range(of: textField.text!, options: .caseInsensitive) != nil})
            
            if(textField.text!.count == 0){
                isSearchActive = false
            } else {
                isSearchActive = true
            }
            
        case .favorite:
            searchChannels = self.favoriteChannels.filter( {$0.name_ru.range(of: textField.text!, options: .caseInsensitive) != nil})
            
            if(textField.text!.count == 0){
                isSearchActive = false
            } else {
                isSearchActive = true
            }
        }
        self.tableView.reloadData()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func setSearchViewUI() {
        
        
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        searchView.layer.cornerRadius = 16
        searchView.backgroundColor = UIColor(red: 0.251, green: 0.259, blue: 0.278, alpha: 1)
        searchView.addSubview(searchTextField)
        
        searchView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "search")
        imageView.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 15).isActive = true
        imageView.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 15).isActive = true
        imageView.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -14.79).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 18.21).isActive = true
        
        view.addSubview(searchTextField)

        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.backgroundColor = .clear
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Напишите название телеканала",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.502, green: 0.506, blue: 0.522, alpha: 1)]
        )
        searchTextField.textColor = .white
        searchTextField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10.79).isActive = true
        searchTextField.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 12).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: -26).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -12).isActive = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selection {
        case .all:
            if isSearchActive {
                return searchChannels.count
            } else if channels != nil {
                return channels!.count
            } else {
                return 0
            }
        case .favorite:
            if isSearchActive {
                return searchChannels.count
            } else if favoriteChannels.count > 0{
                return favoriteChannels.count
            } else {
                return 0
            }
        }
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = AVPlayerViewController()
        player.modalPresentationStyle = .fullScreen
        let cellChannelArray: [Channel] = {
            switch selection{
            case .all:
                return channels!
            case .favorite:
                return favoriteChannels
            }
        }()
        if isSearchActive {
            player.channel = searchChannels[indexPath.row]
        } else {
            player.channel = cellChannelArray[indexPath.row]
        }
        present(player, animated: true)

        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChannelTableViewCell
        
        let cellChannelArray: [Channel] = {
            switch selection{
            case .all:
                return channels!
            case .favorite:
                return favoriteChannels
            }
        }()
        if isSearchActive {
            cell.channel = searchChannels[indexPath.row]
        } else {
            cell.channel = cellChannelArray[indexPath.row]
        }
        
        if let isFavorite = UserDefaults.standard.object(forKey: String(cell.channel!.id)) as? Bool {
            cell.isFavorite = isFavorite
        } else {
            cell.isFavorite = false
        }
        
        
        cell.delegate = self
        return cell
    }
    
    func favoriteButtonPressed(id: String) {
        if let isFavorite = UserDefaults.standard.object(forKey: id) as? Bool {
            UserDefaults.standard.set(!isFavorite, forKey: id)
            if !isFavorite == false {
                favoriteChannels = favoriteChannels.filter({$0.id != Int(id)})
            } else {
                favoriteChannels.append((channels?.first(where: {$0.id == Int(id)}))!)
                
            }
            tableView.reloadData()
        }
    }
    
    
    func setTableView() {
        let channelSegmentedView = ChannelSegmentedControl(frame: CGRect(x: 0, y: 106, width: view.frame.width / 2, height: 56), buttonTitles: ["Все","Избранное"])
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: channelSegmentedView.frame.size.height, width: view.frame.width, height: 1.0)
        bottomBorder.backgroundColor = CGColor(red: 74/255, green: 76/255, blue: 80/255, alpha: 1)
        channelSegmentedView.layer.addSublayer(bottomBorder)
        
        view.addSubview(channelSegmentedView)
        
        channelSegmentedView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        channelSegmentedView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 8).isActive = true
        channelSegmentedView.delegate = self

        self.tableView = UITableView()
        
        self.tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 76
        self.tableView.backgroundColor = UIColor(red: 35/256, green: 36/256, blue: 39/256, alpha: 1)
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: channelSegmentedView.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.contentInset.top = 12
    }
    
    
    func change(to index: Int) {
        switch index {
        case 0:
            selection = .all
        case 1:
            selection = .favorite
        default:
            selection = .all
        }
        tableView.reloadData()
    }
}
