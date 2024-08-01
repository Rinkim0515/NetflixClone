//
//  PosterCell.swift
//  NetflixClone
//
//  Created by bloom on 7/30/24.
//


import UIKit
//MARK: UICollectionView에 들어갈 Cell의 정의

class PosterCell: UICollectionViewCell {
  static let id = "PosterCell"
  
  let imageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true //image의 모서리를 깍는 것
    iv.backgroundColor = .darkGray
    iv.layer.cornerRadius = 10
    return iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    imageView.frame = contentView.bounds
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: 셀은 재사용되기때문에 버벅임을 줄여주는 메서드
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
  
  
  func configure(with movie: Movie) {
    guard let posterPath = movie.posterPath else { return }
    
    let urlString = "https://image.tmdb.org/t/p/w500/\(posterPath)"
    guard let url = URL(string: urlString) else { return }
    // DispatchQueue.global -> 백그라운드로 처리
    DispatchQueue.global().async{ [weak self] in //여기서의 약한참조의 역할 ?
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async{
            self?.imageView.image = image
          }
        }
            
      }
      
    }
  }
  
  
}
