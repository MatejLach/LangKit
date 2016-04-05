//
//  LanguageModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public protocol LanguageModel {
    
    associatedtype ItemType : Sequence

    func train()

    func probability(item: ItemType) -> Float

}
