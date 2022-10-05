//
//  AVPlayerController.swift
//  testWorkLimex
//
//  Created by Никита Ананьев on 03.10.2022.
//

import UIKit
import AVKit
import AVFoundation
class AVPlayerViewController: UIViewController {
    
    var playerContainerView: UIView!
    var channel: Channel? {
        didSet {
            image.imageFromServerURL(channel!.image, placeHolder: image.image)
            channelTitle.text = channel?.current.title
            channelName.text = channel?.name_ru
        }
    }
    private var playerView: PlayerView!
    
    let header = UIView()
    let footer = UIView()
    
    let backButton = UIButton()
    
    
    let image = UIImageView()
    let channelName = UILabel()
    let channelTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrientationUtility.lockOrientation(.landscape)
    
        setUpPlayerContainerView()
        setUpPlayerContainerView()
        setUpPlayerView()
        setUpHeaderView()
        playVideo()
        
    }
    private func setUpPlayerContainerView() {
        playerContainerView = UIView()
        playerContainerView.backgroundColor = .black
        view.addSubview(playerContainerView)
        playerContainerView.translatesAutoresizingMaskIntoConstraints = false
        playerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    private func setUpPlayerView() {
        playerView = PlayerView()
        playerContainerView.addSubview(playerView)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.topAnchor.constraint(equalTo: playerContainerView.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor).isActive = true
        playerView.centerYAnchor.constraint(equalTo: playerContainerView.centerYAnchor).isActive = true
        
        
        
        
    }
    
    private func setUpHeaderView() {
        playerContainerView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leftAnchor.constraint(equalTo: playerContainerView.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: playerContainerView.rightAnchor).isActive = true
        header.topAnchor.constraint(equalTo: playerContainerView.topAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 76).isActive = true
        
        header.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 26).isActive = true
        backButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 23).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        backButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        header.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: header.topAnchor, constant: 12).isActive = true
        image.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 23).isActive = true
        image.widthAnchor.constraint(equalToConstant: 44).isActive = true
        image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
        
        header.addSubview(channelTitle)
        channelTitle.translatesAutoresizingMaskIntoConstraints = false
        channelTitle.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 24).isActive = true
        channelTitle.topAnchor.constraint(equalTo: header.topAnchor, constant: 12).isActive = true
        channelTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
        channelTitle.textColor = .white
        
        header.addSubview(channelName)
        channelName.translatesAutoresizingMaskIntoConstraints = false
        channelName.leftAnchor.constraint(equalTo: channelTitle.leftAnchor).isActive = true
        channelName.topAnchor.constraint(equalTo: channelTitle.bottomAnchor, constant: 2).isActive = true
        channelName.textColor = .white
        channelName.layer.opacity = 0.8
        
        
        
    }

    func playVideo() {
        guard let url = URL(string: channel!.url) else { return }
        playerView.play(with: url)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        header.addGradient()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        OrientationUtility.lockOrientation(.all)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}
