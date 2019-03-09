//
//  MemesTableViewController.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 08/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

protocol MemesTableViewDelegate {
    func didShowMemeEditor()
    func didShowMemeDetail(for meme: Meme)
}

class MemesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: MemesTableViewDelegate?
    
    let addMemeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: nil)
    var section = BehaviorRelay<[SectionOfMeme]>(value: [])
    let disposeBag = DisposeBag()
    
    var memesSaved: BehaviorRelay<[Meme]> {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
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
extension MemesTableViewController {
    
    private func setupViews() {
        navigationItem.title = "Sent Memes"
        navigationItem.rightBarButtonItem = addMemeButton
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
        tableView.registerCellWithNib(MemeMeCell.self)
        
        tableView.addSubview(emptyMemesLabel)
        
        emptyMemesLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyMemesLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -55).isActive = true
    }
    
    private func bindViews() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfMeme> (
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(type: MemeMeCell.self, indexPath: indexPath)
                cell.labelMeme.text = item.top
                cell.imageMeme?.image = item.meme
                return cell
        })
        
        tableView.rx.itemSelected
            .observeOn(MainScheduler.asyncInstance)
            .map { $0.row }
            .bind { [weak self] row in
                guard let strongSelf = self else { return }
                strongSelf.delegate!.didShowMemeDetail(for: strongSelf.memesSaved.value[row])
            }.disposed(by: disposeBag)
        
        section
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        memesSaved
            .bind { [weak self] memes in
                self?.section.accept([SectionOfMeme(model: "", items: memes)])
                self?.emptyMemesLabel.isHidden = !(memes.count == 0)
                self?.tableView.separatorStyle = memes.count == 0 ? .none : .singleLine
        }.disposed(by: disposeBag)
        
        addMemeButton.rx.tap.bind { [weak self] in
            self?.delegate?.didShowMemeEditor()
        }.disposed(by: disposeBag)
        
    }
}
