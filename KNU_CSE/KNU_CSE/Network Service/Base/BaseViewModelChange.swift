//
//  BaseViewModelChange.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/05.
//

enum BaseViewModelChange<T> {
    case loaderStart(T)
    case loaderEnd
    case updateDataModel
    case error
}
