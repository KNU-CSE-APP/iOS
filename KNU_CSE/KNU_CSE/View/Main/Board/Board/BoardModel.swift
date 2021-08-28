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
    var time : String
    var profileImg: String
    var commentCnt:Int
    var images: [String]
    
    let categoryDict:[String:String] = ["FREE":"자유게시판", "QNA":"질의응답"]
    
    init(boardId:Int, category:String, title:String, content:String, author:String, time:String, profileImg:String, commentCnt:Int, images: [String]) {
        self.boardId = boardId
        self.category = category
        self.title = title
        self.content = content
        self.author = author
        self.time = time
        self.profileImg = profileImg
        self.commentCnt = commentCnt
        self.images = images
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.image = (try? container.decode(String.self, forKey: .image)) ?? ""
        self.boardId = (try? container.decode(Int.self, forKey: .boardId)) ?? 0
        self.category = (try? container.decode(String.self, forKey: .category)) ?? ""
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.author = (try? container.decode(String.self, forKey: .author)) ?? ""
        self.time = (try? container.decode(String.self, forKey: .time)) ?? ""
        self.profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        self.commentCnt = (try? container.decode(Int.self, forKey: .commentCnt)) ?? 0
        self.images = (try? container.decode([String].self, forKey: .images)) ?? []
        
        super.init()
        
        self.category = categoryDict[category] ?? categoryDict["FREE"]!
    }
    
    enum CodingKeys: CodingKey {
       case boardId, category, title, content, author, time, profileImg, commentCnt, images
     }
}

