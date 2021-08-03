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
    var comment:CommentTextModel = CommentTextModel()
    var listener:((String)->Void)?
    
    init(){
        self.setComment()
    }
    
    mutating func bind(listener:((String)->Void)?) {
        self.listener = listener
    }
    
    mutating func setComment(){
        self.comments.append(Comment(image:"https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg",commentId: 123, content: "케인의 이적이야기에  맨체스터 시티(이하 맨시티),첼시 등 최전방 공격수 영입이 필요한 팀들이 케인을 품기 위해 적극적으로 움직였다. 하지만 토트넘의 다니엘 레비(59) 회장은 케인의 매각하지 않을 것이라며 그를 품고 싶다면 1억 5000만 파운드(2371억 원)의 현금 거래만 받겠다는입장을 고수했다.", date: "2021 07.24 23:16", author: "IYNONE"))
        var replys:[Reply] = []
        replys.append(Reply(image:"https://image.fmkorea.com/files/attach/new/20201120/2063168106/2498862386/3210609455/51ed1aeab1ac2e6d498a3ee68ce748b8.jpg",replyId: 1, content: "ㅋㅋㅋㅋ ", date: "2021 07.24 23:16", author: "대댓글test1"))
        replys.append(Reply(image:"https://file.mk.co.kr/meet/neds/2021/04/image_r16177500644599916.jpg",replyId: 1, content: "한편 토트넘 다니엘 레비 회장은 지난달 \"이적시장은 열려있지만, 우리가 원하는 것과 다른 구단이 원하는 게 언제나 맞아떨어지지는 않는다\"며 원하는 조건이 맞지 않으면 그를 다른 구단에 보낼 수 없다는 입장을 밝힌 바 있다.", date: "2021 07.24 23:17", author: "대댓글test2"))
        replys.append(Reply(image:"https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg",replyId: 1, content: "더 선은 갑자기 분위기를 바꿨다. 토트넘이 원하는 이적료를 지불하기 어려울 것이라고 전망했다. 신종 코로나바이러스감염증(코로나19) 팬더믹으로 어려운 상황에서 맨시티가 지불할 수 있는 금액은 적다는 이야기였다. ", date: "2021 07.24 23:18", author: "대댓글test3"))
        replys.append(Reply(image:"https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg",replyId: 1, content: "하하하하하", date: "2021 07.24 23:19", author: "대댓글test4"))
        self.comments[0].setReplyList(replyList: replys)
        
        self.comments.append(Comment(image:"https://file.mk.co.kr/meet/neds/2021/04/.jpg",commentId: 124, content: "hihi zz", date: "2021 07.24 23:17", author: "댓글2"))
        var replys2:[Reply] = []
        replys2.append(Reply(image:"https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg",replyId: 1, content: "ㅎㅇㅎㅇㅎㅇㅎㅇ", date: "2021 07.24 23:16", author: "대댓글2"))
        replys2.append(Reply(image:"https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg",replyId: 1, content: "안녕하세용", date: "2021 07.24 23:16", author: "대댓글2"))
        self.comments[1].setReplyList(replyList: replys2)
    }
    
    func sendComment(){
        self.comment.email = "zz"
        self.comment.boardId = self.board.boardId
        print(comment.email, comment.boardId, comment.content)
    }
}

class CommentTextModel:BaseObject{
    var email:String!
    var boardId:Int!
    var content:String!
}
