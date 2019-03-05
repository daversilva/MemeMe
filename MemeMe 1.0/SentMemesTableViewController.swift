//
//  SentMemesTableViewController.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 06/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

struct SectionOfMeme {
    var header: String
    var items: [Item]
}

extension SectionOfMeme: SectionModelType {
    typealias Item = Meme
    
    init(original: SectionOfMeme, items: [Item]) {
        self = original
        self.items = items
    }
}

class SentMemesTableViewController: UITableViewController {
    
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    var memesSaved: BehaviorRelay<[Meme]> {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    var section = BehaviorRelay<[SectionOfMeme]>(value: [])
    
    /// custom
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
        tableView.reloadData()
    }

}

// MARK: - Setups
extension SentMemesTableViewController {
    
    private func setupViews() {
        tableView.addSubview(emptyMemesLabel)

        emptyMemesLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyMemesLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -55).isActive = true
    }
    
    private func bindViews() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfMeme> (
            configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
            cell.labelMeme.text = item.top
            cell.imageMeme?.image = item.meme
            return cell
        })
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observeOn(MainScheduler.asyncInstance)
            .map { $0.row }
            .bind { [weak self] row in
                guard let strongSelf = self else { return }
                let detailController = self?.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
                detailController.meme = strongSelf.memesSaved.value[row]
                self?.navigationController?.pushViewController(detailController, animated: true)
            }.disposed(by: disposeBag)
        
        section
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        memesSaved
            .bind { [weak self] memes in
                self?.section.accept([SectionOfMeme(header: "", items: memes)])
                self?.emptyMemesLabel.isHidden = !(memes.count == 0)
                self?.tableView.separatorStyle = memes.count == 0 ? .none : .singleLine
            }
            .disposed(by: disposeBag)
        
        addMemeButton.rx.tap.bind { [weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
            self?.present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
    }
}


