//
//  BoardViewDetailViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import Foundation

struct BoardDetailViewModel{
    var board:Board!
    var comments:[Comment] = []
    
    init(){
        self.setComment()
    }
    
    mutating func setComment(){
        self.comments.append(Comment(commentId: 123, content: "hihi zz", date: "2021 07.24 23:16", author: "노준석"))
        var replys:[Reply] = []
        replys.append(Reply(replyId: 1, content: "ㅅㅂ", date: "2021 07.24 23:16", author: "ㅅㅂ롬"))
        replys.append(Reply(replyId: 1, content: "ㅅㅂ", date: "2021 07.24 23:16", author: "ㅅㅂ롬"))
        replys.append(Reply(replyId: 1, content: "ㅅㅂ", date: "2021 07.24 23:16", author: "ㅅㅂ롬"))
        replys.append(Reply(replyId: 1, content: "ㅅㅂ", date: "2021 07.24 23:16", author: "ㅅㅂ롬"))
        self.comments[0].setReplyList(replyList: replys)
    }
}
