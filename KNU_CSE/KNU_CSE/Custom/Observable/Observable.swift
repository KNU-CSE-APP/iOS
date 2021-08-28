//
//  Observable.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/12.
//

class Observable<T> {
    private var listener: ((T) -> Void)?
    private var secondlistener : ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
            secondlistener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
    
    func secondBind(_ closure: @escaping (T) -> Void) {
        secondlistener = closure
    }
}
