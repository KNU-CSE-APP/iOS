//
//  BoardModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

class Board:BaseObject{
    var image:String
    var boardId : Int
    var category : String
    var title : String
    var content : String
    var author : String
    var time : String
    var commentCnt:Int
    
    let categoryDict:[String:String] = ["FREE":"자유게시판", "QNA":"질의응답"]
    
    init(image:String, boardId:Int, category:String, title:String, content:String, author:String, time:String, commentCnt:Int) {
        self.image = image
        self.boardId = boardId
        self.category = category
        self.title = title
        self.content = content
        self.author = author
        self.time = time
        self.commentCnt = commentCnt
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.image = (try? container.decode(String.self, forKey: .image)) ?? ""
        self.image = ""
        self.boardId = (try? container.decode(Int.self, forKey: .boardId)) ?? 0
        self.category = (try? container.decode(String.self, forKey: .category)) ?? ""
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.author = (try? container.decode(String.self, forKey: .author)) ?? ""
        self.time = (try? container.decode(String.self, forKey: .time)) ?? ""
        self.commentCnt = (try? container.decode(Int.self, forKey: .commentCnt)) ?? 0
        super.init()
        
        self.category = categoryDict[category]!
    }
    
    enum CodingKeys: CodingKey {
       case image, boardId, category, title, content, author, time, commentCnt
     }
}

