//
//  MemesCollectionViewController.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 08/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

typealias SectionOfMeme = AnimatableSectionModel<String, Meme>

protocol MemesCollectionViewDelegate {
    func didShowMemeEditor()
    func didShowMemeDetail(for meme: Meme)
}

class MemesCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let addMemeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: nil)
    var section = BehaviorRelay<[SectionOfMeme]>(value: [])
    var delegate: MemesCollectionViewDelegate?
    var disposeBag = DisposeBag()
    
    var memesSaved: BehaviorRelay<[Meme]> {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    let emptyMemesLabel: UILabel = {
        let label = UILabel()
        label.text = "🤔 no memes yet!"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
}

// MARK: - Setups
extension MemesCollectionViewController {
    
    private func setupViews() {
        navigationItem.title = "Sent Memes"
        navigationItem.rightBarButtonItem = addMemeButton
        
        //configureFlowLayout
        let space: CGFloat = 3.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: dimensionWidth , height: dimensionHeight)
        
        collectionView.registerCellWithNib(MemeMeCollectionCell.self)
        collectionView.addSubview(emptyMemesLabel)
        
        emptyMemesLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        emptyMemesLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -10).isActive = true
    }
    
    private func bindViews() {
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMeme> (
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(type: MemeMeCollectionCell.self, indexPath: indexPath)
                cell.sentMemeImageView?.image = item.meme
                return cell
        })
        
        collectionView.rx.itemSelected
            .observeOn(MainScheduler.asyncInstance)
            .map { $0.row }
            .bind { [weak self] row in
                guard let strongSelf = self else { return }
                strongSelf.delegate!.didShowMemeDetail(for: strongSelf.memesSaved.value[row])
            }.disposed(by: disposeBag)
        
        section
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: self.collectionView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        memesSaved
            .bind { [weak self] memes in
                self?.section.accept([SectionOfMeme(model: "", items: memes)])
                self?.emptyMemesLabel.isHidden = !(memes.count == 0)
            }
            .disposed(by: disposeBag)
        
        addMemeButton.rx.tap.bind { [weak self] in
            self?.delegate?.didShowMemeEditor()
            }.disposed(by: disposeBag)
        
    }
    
}
