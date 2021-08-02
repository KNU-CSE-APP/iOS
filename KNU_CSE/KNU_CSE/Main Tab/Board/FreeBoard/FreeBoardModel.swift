//
//  BoardModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

class Board:BaseObject{
    var boardId : Int
    var category : String
    var title : String
    var content : String
    var author : String
    var date : String
    var numberOfcomment:Int
    
    init(boardId:Int, category:String, title:String, content:String, author:String, date:String, numberOfcomment:Int) {
        self.boardId = boardId
        self.category = category
        self.title = title
        self.content = content
        self.author = author
        self.date = date
        self.numberOfcomment = numberOfcomment
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
