//
//  SentMemesCollectionViewController.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 06/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var disposeBag = DisposeBag()
    
    var memesSaved: BehaviorRelay<[Meme]> {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    var section = BehaviorRelay<[SectionOfMeme]>(value: [])
    
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
extension SentMemesCollectionViewController {
    
    private func setupViews() {
        guard let `collectionView` = collectionView else { fatalError() }
        
        //configureFlowLayout
        let space: CGFloat = 3.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: dimensionWidth , height: dimensionHeight)
        
        collectionView.addSubview(emptyMemesLabel)
        
        emptyMemesLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        emptyMemesLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -55).isActive = true
    }
    
    private func bindViews() {
        
        guard let `collectionView` = collectionView else { fatalError() }
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMeme> (
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
                cell.sentMemeImageView?.image = item.meme
                return cell
        })
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .observeOn(MainScheduler.asyncInstance)
            .map { $0.row }
            .bind { [weak self] row in
                guard let strongSelf = self else { return }
                let detailController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
                detailController.meme = strongSelf.memesSaved.value[row]
                strongSelf.navigationController?.pushViewController(detailController, animated: true)
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
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
            self?.present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)

    }
    
}

