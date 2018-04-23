//
//  File.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/23.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

extension Session: ReactiveCompatible {
    
}

extension Reactive where Base: Session {
    
    func response<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create { [weak base] observer in
            let task = base?.send(request) { result in
                switch result {
                case .success(let response):
                    observer.on(.next(response))
                    observer.on(.completed)
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
}
