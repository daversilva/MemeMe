//
//  MemeEditorViewModel.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 09/03/19.
//  Copyright © 2019 David Rodrigues. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol MemeEditorViewModelType {
    var shareIsEnable: BehaviorRelay<Bool> { get }
    var cancelEditEvent: PublishSubject<Void> { get }
    var saveMemeEvent: PublishSubject<Meme> { get }
}

protocol MemeEditorDelegate {
    func didCancel()
}

class MemeEditorViewModel: MemeEditorViewModelType {
    
    let disposeBag = DisposeBag()
    var delegate: MemeEditorDelegate?
    
    var shareIsEnable = BehaviorRelay<Bool>(value: false)
    var cancelEditEvent = PublishSubject<Void>()
    var saveMemeEvent = PublishSubject<Meme>()
    
    init() {
        cancelEditEvent
            .bind { [weak self] in
                self?.delegate?.didCancel()
        }.disposed(by: disposeBag)
        
        saveMemeEvent
            .map { $0 }
            .unwrap()
            .bind { meme in
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.accept(appDelegate.memes.value + [meme])
            }.disposed(by: disposeBag)
    }
}
