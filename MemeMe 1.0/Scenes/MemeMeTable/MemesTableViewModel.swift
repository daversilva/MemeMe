//
//  MemesTableViewModel.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 09/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol MemeTableViewModelType {
    var memesSaved: BehaviorRelay<[Meme]> { get }
    var section: BehaviorRelay<[SectionOfMeme]> { get }
    var selectMemeEvent: PublishSubject<Int> { get }
    var showMemeEditorEvent: PublishSubject<Void> { get }
}

protocol MemesTableViewDelegate {
    func didShowMemeEditor()
    func didShowMemeDetail(for meme: Meme)
}

class MemesTableViewModel: MemeTableViewModelType {
    
    var disposeBag = DisposeBag()
    var delegate: MemesTableViewDelegate?
    
    var memesSaved: BehaviorRelay<[Meme]> {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    var section = BehaviorRelay<[SectionOfMeme]>(value: [])
    
    var selectMemeEvent = PublishSubject<Int>()
    var showMemeEditorEvent = PublishSubject<Void>()
    
    init() {
        memesSaved
            .bind { [weak self] memes in
                self?.section.accept([SectionOfMeme(model: "", items: memes)])
            }.disposed(by: disposeBag)
        
        selectMemeEvent
            .map { [unowned self] row -> Meme in return self.memesSaved.value[row] }
            .bind { [weak self] meme in self?.delegate?.didShowMemeDetail(for: meme) }
            .disposed(by: disposeBag)
        
        showMemeEditorEvent
            .bind { [weak self] in self?.delegate?.didShowMemeEditor() }
            .disposed(by: disposeBag)
    }
}
