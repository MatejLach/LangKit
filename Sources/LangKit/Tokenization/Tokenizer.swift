//
//  Tokenizer.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public extension String {
    
    public func tokenize() -> [String] {
        return characters.split(separator: " ").map(String.init)
    }
    
}

public class Tokenizer {
    
    public init() {
        
    }
    
}
