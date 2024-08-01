//
//  SectionHeaderVIew.swift
//  NetflixClone
//
//  Created by bloom on 7/30/24.
//

import UIKit

//MARK: SectionHeaderView 셀위에 올라가는 타이틀 위치
class SectionHeaderVIew: UICollectionReusableView {
  static let id = "SectionHeaderVIew"
  
  let titleLabel = {
    let lb = UILabel()
    lb.font = UIFont.boldSystemFont(ofSize: 18)
    lb.textColor = .white
    return lb
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI(){ //1회성은 setup
    
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
    
  }
  
  func configure(with title: String) {
    titleLabel.text = title
  }
}
