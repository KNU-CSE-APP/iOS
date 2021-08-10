//
//  BoardViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

struct BoardViewModel{
    var boards : [Board] = []
    var category:String = ""
    var boardListener: BaseAction<[Board], errorHandler> = BaseAction()
    
    init(){
       // self.setUpBoards()
    }

    func getBoards(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getBoard(self.category))
        request.sendRequest(request: request, responseType: [Board].self, errorType: errorHandler.self, action:self.boardListener)
    }
}


//    mutating func setUpBoards(){
//        boards.append(Board(image:"https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판1", content: "테스트 게시판1", author: "노준석", time: "2021 07.24 23:11",commentCnt: 1))
//        boards.append(Board(image:"https://cdn.clien.net/web/api/file/F01/11667958/aa1c97ac908314.jpg?w=780&h=30000", boardId: 1, category: "자유게시판", title: "테스트 게시판2", content: "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss\nsssssss\nssssssssssss\nsssssssssssss\nsssssssssssss\nsssssssssssaazzzzzzzzzzㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋsssssssㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋsssssssssㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋsssstqtqtqt\nqtqtqtqtqt\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\ntqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqttqtqtqtqt", author: "노준석", time: "2021 07.24 23:12",commentCnt: 1))
//        boards.append(Board(image:"https://lh3.googleusercontent.com/proxy/uiYWh7QLrbpeG0Jqw-c--eROOfSMVehnnjwplGvUgBx36Nv61sgfeJd9MXITwASKRgLCshQDFmwMw9L9O4Nr13feai-xKlUAJeT7MaVwKlh-ZffQ1g9hiUx2uh7x9fnb4_vNGwTOXq1dZzbG83pHsWIi", boardId: 1, category: "자유게시판", title: "테스트 게시판3", content: "테스트 게시판3", author: "노준석", time: "2021 07.24 23:13",commentCnt: 1))
//        boards.append(Board(image:"https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판4", content: "테스트 게시판4", author: "노준석", time: "2021 07.24 23:14",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판5", content: "테스트 게시판5", author: "노준석", time: "2021 07.24 23:15",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판6", content: "테스트 게시판6", author: "노준석", time: "2021 07.24 23:16",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판7", content: "테스트 게시판7", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판8", content: "테스트 게시판8", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판9", content: "테스트 게시판9", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판10", content: "테스트 게시판10", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판11", content: "테스트 게시판11", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판12", content: "테스트 게시판12", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판13", content: "테스트 게시판13", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판14", content: "테스트 게시판14", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판15", content: "테스트 게시판15", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//        boards.append(Board(image:"http://www.sisa-news.com/data/photos/20201043/art_160342063801_d66300.jpg", boardId: 1, category: "자유게시판", title: "테스트 게시판16", content: "테스트 게시판16", author: "노준석", time: "2021 07.24 23:17",commentCnt: 1))
//    }
