//
//  ViewController.swift
//  NetflixClone
//
//  Created by bloom on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import AVKit
import AVFoundation


class MainViewController: UIViewController {
  
  private let viewModel = MainViewModel()
  /// observable을 담는 변수
  private let disposeBag = DisposeBag()
  
  /// Movie타입의 정보들이 변수에 배열식으로 차례대로 담긴다.
  private var popularMovies = [Movie]()
  private var topRatedMovies = [Movie]()
  private var upcomingMovies = [Movie]()
  
  
  
  
  
  private let logoLabel = {
    let lb = UILabel()
    lb.text = "NETFLIX"
    lb.textColor = UIColor(red: 229/255, green: 9/255, blue: 20/255, alpha: 1.0)
    lb.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
    return lb
  }()
  
  lazy var collectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    cv.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.id)
    cv.register(SectionHeaderVIew.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderVIew.id)
    cv.delegate = self
    cv.dataSource = self
    cv.backgroundColor = .black
    return cv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
    view.backgroundColor = .black
    // Do any additional setup after loading the view.
  }
  
  private func bind() { ///RX로 구독하는 작업
    viewModel.popularMovieSubject
      .observe(on: MainScheduler.instance) /// MainThread에서 동작하기위함
      .subscribe(onNext: {[weak self] movies in
        self?.popularMovies = movies
        self?.collectionView.reloadData() /// ui로직
      }, onError: { error in
        print("popularMovie errors:\(error)")
      }).disposed(by: disposeBag)
    
    viewModel.topRatedMovieSubject
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: {[weak self] movies in
        self?.topRatedMovies = movies
        self?.collectionView.reloadData()
      }, onError: { error in
        print("topRatedMovie errors:\(error)")
      }).disposed(by: disposeBag)
    
    viewModel.upcomingMovieSubject
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: {[weak self] movies in
        self?.upcomingMovies = movies
        self?.collectionView.reloadData()
      }, onError: { error in
        print("upcomingMovie errors:\(error)")
      }).disposed(by:disposeBag)
  }

  
  private func createLayout()-> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.25),
      heightDimension: .fractionalWidth(0.4)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.interGroupSpacing = 10
    section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
    /// 헤더의 영역
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(44)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]
    
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  
  
  private func configureUI(){
    view.backgroundColor = .black
    [
      logoLabel,
      collectionView
    ].forEach{ view.addSubview($0) }
    
    logoLabel.snp.makeConstraints{
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
      $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
    }
    collectionView.snp.makeConstraints{
      $0.top.equalTo(logoLabel.snp.bottom).offset(20)
      $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
/// 유튜브는 정책상 동영상자체의 url을 제공하지 않음
  
  private func playVideoUrl() {
    let url = URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!
    let player = AVPlayer(url: url)
///player 에 url을 담은 AVPlayer 를 넣어준후
    let playerViewController = AVPlayerViewController()
///동영상을 재생할수있는 ViewController 생성
    playerViewController.player = player
///playerViewController에 있는 player변수에 방금 url을 담은 player를 할당
    present(playerViewController, animated: true) {
      player.play()
  ///player의 변수를 .play로 실행함 (재생)
    }
    
  }
  
  enum Section: Int, CaseIterable {
    case popularMovies //CaseItrerable로 인해서 rawvalue가 차례대로 0, 1, 2 로 들어감
    case topRatedMovies
    case upcomingMovies
    
    var title: String {
      switch self {
      case .popularMovies: return "이시간 핫한 영화"
      case .topRatedMovies: return "가장 평점이 높은 영화"
      case .upcomingMovies: return "곧 개봉되는 영화"
      }
    }
  }
  
  
  

}


extension MainViewController: UICollectionViewDelegate{
/// 셀 클릭시 터치 이벤트
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    switch Section(rawValue: indexPath.section) {
      
    case .popularMovies:
      viewModel.fetchTrailerKey(movie: popularMovies[indexPath.row])
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] key in
          self?.playVideoUrl()
        }, onFailure: { error in
          print(#function,"동영상재생에러: \(error)")
        }).disposed(by: disposeBag)
      
    case .topRatedMovies:
      viewModel.fetchTrailerKey(movie: topRatedMovies[indexPath.row])
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: {[weak self] key in
          self?.playVideoUrl()
        }, onFailure: { error in
          print(#function,"동영상 재생 에라: \(error)")
        }).disposed(by: disposeBag)
    case .upcomingMovies:
      viewModel.fetchTrailerKey(movie: upcomingMovies[indexPath.row])
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: {[weak self] key in
          self?.playVideoUrl()
        }, onFailure: { error in
          print(#function,"동영상 재생 에러: \(error)")
        }).disposed(by: disposeBag)
    default: return
    }
  }

  
}

extension MainViewController: UICollectionViewDataSource {
  

  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.id, for: indexPath) as? PosterCell else {
      return UICollectionViewCell()
    }
    
    switch Section(rawValue: indexPath.section){
    case .popularMovies: cell.configure(with: popularMovies[indexPath.row])
    case .topRatedMovies: cell.configure(with: topRatedMovies[indexPath.row])
    case .upcomingMovies: cell.configure(with: upcomingMovies[indexPath.row])
    default: return UICollectionViewCell()
    }
    
    return cell
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    guard kind == UICollectionView.elementKindSectionHeader else {
      return UICollectionReusableView()
    }
    
    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderVIew.id, for: indexPath) as? SectionHeaderVIew else { return UICollectionReusableView()}
    
    let sectionType = Section.allCases[indexPath.section]
    headerView.configure(with: sectionType.title)
    return headerView
  }
  
  
  
  //MARK: CollectionViewCell 안에 들어가는 섹션에 몇개가 들어가는지 설정하는 메서드
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch Section(rawValue: section) {
    case .popularMovies: return popularMovies.count
    case .topRatedMovies: return topRatedMovies.count
    case .upcomingMovies: return upcomingMovies.count
    default: return 0
    }
  }
  
  //MARK: CollectionView의 섹션이 몇개인지 설정하는 메서드
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Section.allCases.count
  }

  
}
