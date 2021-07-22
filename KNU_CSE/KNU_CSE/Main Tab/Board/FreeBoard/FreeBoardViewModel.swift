//
//  BoardViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

struct FreeBoardViewModel{
    var boards : [Board] = []
    
    init(){
        self.setUpBoards()
    }
    
    mutating func setUpBoards(){
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판1", content: "테스트 게시판1", author: "노준석", date: "2021 07.24 23:11",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판2", content: "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss\nsssssss\nssssssssssss\nsssssssssssss\nsssssssssssss\nsssssssssssaazzzzzzzzzzㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋsssssssㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋsssssssssㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋsssstqtqtqt\nqtqtqtqtqt\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\ntqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqt", author: "노준석", date: "2021 07.24 23:12",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판3", content: "테스트 게시판3", author: "노준석", date: "2021 07.24 23:13",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판4", content: "테스트 게시판4", author: "노준석", date: "2021 07.24 23:14",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판5", content: "테스트 게시판5", author: "노준석", date: "2021 07.24 23:15",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판6", content: "테스트 게시판6", author: "노준석", date: "2021 07.24 23:16",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
        boards.append(Board(boardId: 1, category: 0, title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", date: "2021 07.24 23:17",numberOfcomment: 1))
    }
}
