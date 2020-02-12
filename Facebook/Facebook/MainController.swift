//
//  MainController.swift
//  Facebook
//
//  Created by André Miranda on 11/02/20.
//  Copyright © 2020 Miranda. All rights reserved.
//

import UIKit
import LBTATools


class PostCell: LBTAListCell<String> {
    
    let imageView = UIImageView(image: UIImage(named: "avatar2"), contentMode: .scaleAspectFill )
    let nameLabel = UILabel(text: "Jon Snow")
    let dateLabel = UILabel(text: "Fryday at 11:11AM", textColor: .lightGray)
    let postTextLabel = UILabel(text: "Here is my post text")
   
    let imageViewGrid = UIView(backgroundColor: .yellow)
    
    let photosGridController = PhotosGridController()
    
    override func setupViews() {
        backgroundColor = .white
        imageView.layer.cornerRadius = 20
        
        stack(hstack(imageView.withHeight(40).withWidth(40),
            stack(nameLabel, dateLabel),
            spacing: 8).padLeft(12).padRight(12).padTop(12),
              postTextLabel, UIView().withWidth(12),
              photosGridController.view,
              spacing: 8)
        
    }
}

class StoryHeader: UICollectionReusableView {
    
    let storiesController = StoriesController(scrollDirection: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        stack(storiesController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

class StoryPhotoCell: LBTAListCell<String> {
    
    override var item: String!{
        didSet {
            imageView.image = UIImage(named: item)
        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "avatar2"), contentMode: .scaleAspectFill )
    
    
    
//    let avatarImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
   let avatarImageView = CircularImageView(width: 32, image: UIImage(named: "avatar2"))
    
    let nameLabel = UILabel(text:"Jon Snow", font: .boldSystemFont(ofSize: 14) , textColor: .white)
    
    override func setupViews() {
        
        
        imageView.layer.cornerRadius = 12
        
        
        stack(imageView)
        
        avatarImageView.backgroundColor = .blue
        avatarImageView.layer.cornerRadius = 13
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        
        addSubview(avatarImageView)
        
        stack(UIView(), avatarImageView).withMargins(.init(top: 8, left: 8, bottom: 140, right: 64))
        
        setupGradientLayer()
        
        stack(UIView(), nameLabel).withMargins(.allSides(8))
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor ]
        gradientLayer.locations = [0.7, 1.2]
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        
    }
    
}

class StoriesController: LBTAListController<StoryPhotoCell, String>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height - 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = ["avatar1", "story_photo1", "story_photo2","avatar1","avatar1", "avatar1"]
        
    }
    
}


class MainController: LBTAListHeaderController<PostCell, String, StoryHeader>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1)
        
        self.items = ["hello","world","1","2"]
        
        setupNavBar()
        
    }
    
    let facebooklogoImageView = UIImageView(image: UIImage(named: "facebooklogo"), contentMode: .scaleAspectFit)
    
    let searchButton = UIButton(title: "Search", titleColor: .black)
    
    fileprivate func setupNavBar() {
        
        let width = view.frame.width - 120 - 16 - 60
        
        let titleView = UIView(backgroundColor: .clear)
        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)
        
        
        
//        titleView.addSubview(facebooklogoImageView)
        
        titleView.hstack(facebooklogoImageView.withWidth(120), UIView(backgroundColor: .clear).withWidth(width),searchButton.withWidth(60))
        
        
        navigationItem.titleView = titleView
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        
        let magicalSafeAreaTop: CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        
        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
        
        let alpha: CGFloat = 1 - ((scrollView.contentOffset.y + magicalSafeAreaTop ) / magicalSafeAreaTop)
       
        [facebooklogoImageView, searchButton].forEach {$0.alpha = alpha}
        facebooklogoImageView.alpha = alpha
        
//        print(scrollView.contentOffset.y)
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset) )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 400)
    }
    
}

import SwiftUI
struct MainPreview: PreviewProvider {
    static var previews: some View {
        //Text("main preview123")
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return UINavigationController(rootViewController: MainController())
        }
        
        
        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
    }
    
}
