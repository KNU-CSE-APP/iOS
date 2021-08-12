//
//  BoardDetailModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import Foundation

class Comment:BaseObject{
    var boardId:Int!
    var commentId:Int
    var parentId:Int!
    var author:String!
    var content:String!
    var time:String!
    var replyList:[Comment]!
    
    var image:String!
    
    init(image:String, commentId:Int, content:String, time:String, author:String) {
        self.image = image
        self.commentId = commentId
        self.content = content
        self.time = time
        self.author = author
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.boardId = (try? container.decode(Int.self, forKey: .boardId)) ?? 0
        self.commentId = (try? container.decode(Int.self, forKey: .commentId)) ?? 0
        self.parentId = (try? container.decode(Int.self, forKey: .parentId))
        self.author = (try? container.decode(String.self, forKey: .author)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.time = (try? container.decode(String.self, forKey: .time)) ?? ""
        self.image = (try? container.decode(String.self, forKey: .image)) ?? ""
        self.replyList = (try? container.decode([Comment].self, forKey: .replyList)) ?? []
        super.init()
    }
    
    enum CodingKeys: CodingKey {
        case boardId, commentId, parentId, author, content, time, image, replyList
     }
    
}

class CommentTextModel:BaseObject{
    var boardId:Int!
    var content:String!
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(boardId, forKey: .boardId)
        try container.encode(content, forKey: .content)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
        case boardId,content
     }
}
