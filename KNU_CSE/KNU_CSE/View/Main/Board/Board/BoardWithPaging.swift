//
//  BoardWithPaging.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/13.
//

import Foundation

class BoardsWithPaging:BaseObject{
    
    var content:[Board]!
    var pageable:PageInfo
    var last:Bool
    var totalPages:Int
    var totalElements:Int
    var sort:SortInfo
    var first:Bool
    var number:Int
    var numberOfElements:Int
    var size:Int
    var empty:Bool
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = (try? container.decode([Board].self, forKey: .content)) ?? []
        self.pageable = (try container.decode(PageInfo.self, forKey: .pageable))
        self.last = (try container.decode(Bool.self, forKey: .last))
        self.totalPages = (try container.decode(Int.self, forKey: .totalPages))
        self.totalElements = (try container.decode(Int.self, forKey: .totalElements))
        self.sort = (try container.decode(SortInfo.self, forKey: .sort))
        self.first = (try container.decode(Bool.self, forKey: .first))
        self.number = (try container.decode(Int.self, forKey: .number))
        self.numberOfElements = (try container.decode(Int.self, forKey: .numberOfElements))
        self.size = (try container.decode(Int.self, forKey: .size))
        self.empty = (try container.decode(Bool.self, forKey: .empty))
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        
    }
    
    enum CodingKeys: CodingKey {
        case content, pageable, last, totalPages, totalElements, sort, first, number, numberOfElements, size, empty
     }
}

class PageInfo:BaseObject{
    
    var sort:SortInfo
    var pageNumber:Int
    var pageSize:Int
    var offset:Int
    var paged:Bool
    var unpaged:Bool
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sort = (try container.decode(SortInfo.self, forKey: .sort))
        self.pageNumber = (try container.decode(Int.self, forKey: .pageNumber))
        self.pageSize = (try container.decode(Int.self, forKey: .pageSize))
        self.offset = (try container.decode(Int.self, forKey: .offset))
        self.paged = (try container.decode(Bool.self, forKey: .paged))
        self.unpaged = (try container.decode(Bool.self, forKey: .unpaged))
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        
    }
    
    enum CodingKeys: CodingKey {
        case sort, pageNumber, pageSize, offset, paged, unpaged
     }
}

class SortInfo:BaseObject{
    var sorted:Bool
    var unsorted:Bool
    var empty:Bool
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sorted = (try container.decode(Bool.self, forKey: .sorted))
        self.unsorted = (try container.decode(Bool.self, forKey: .unsorted))
        self.empty = (try container.decode(Bool.self, forKey: .empty))
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        
    }
    
    enum CodingKeys: CodingKey {
        case sorted, unsorted, empty
     }
}
