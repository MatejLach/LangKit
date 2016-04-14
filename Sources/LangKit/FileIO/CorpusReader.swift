//
//  CorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/11/16.
//
//

import Foundation

public class CorpusReader {

    public typealias Sentence = [String]

    // Chunk size constant
    private let chunkSize = 4096

    private let path: String
    private let encoding: NSStringEncoding
    private let sentenceSeparator: String
    private let fileHandle: NSFileHandle
    private let buffer: NSMutableData
    private let delimiterData: NSData

    // Tokenization function
    private var tokenize: String -> [String]

    // EOF state
    private var eof: Bool

    /**
     Initialize a CorpusReader with configurations
     
     - parameter fromFile:          File path
     - parameter sentenceSeparator: Sentence separator (default: "\n")
     - parameter encoding:          File encoding (default: UTF8)
     - parameter tokenizingWith:    Tokenization function :: String -> [String] (default: String.tokenize)
     */
    public init?(fromFile path: String, sentenceSeparator: String = "\n",
                 encoding: NSStringEncoding = NSUTF8StringEncoding,
                 tokenizingWith tokenize: String -> [String] = {$0.tokenized()}) {
        guard let handle = NSFileHandle(forReadingAtPath: path),
              let delimiterData = sentenceSeparator.data(usingEncoding: encoding),
              let buffer = NSMutableData(capacity: chunkSize) else {
            return nil
        }
        self.path = path
        self.encoding = encoding
        self.sentenceSeparator = sentenceSeparator
        self.fileHandle = handle
        self.buffer = buffer
        self.eof = false
        self.delimiterData = delimiterData
        self.tokenize = tokenize
    }

    deinit {
        self.close()
    }

    /**
     Close file
     */
    private func close() {
        fileHandle.closeFile()
    }

    /**
     Go to the beginning of the file
     */
    public func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.length = 0
        eof = false
    }

}

extension CorpusReader : IteratorProtocol {

    public typealias Elememnt = Sentence

    /**
     Next tokenized sentence

     - returns: Tokenized sentence
     */
    public func next() -> [String]? {
        if eof {
            return nil
        }
        var range = buffer.range(of: delimiterData, options: [], range: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            let data = fileHandle.readData(ofLength: chunkSize)
            guard data.length > 0 else {
                eof = true
                return nil
            }
            buffer.append(data)
            range = buffer.range(of: delimiterData, options: [], range: NSMakeRange(0, buffer.length))
        }

        let maybeLine = String(data: buffer.subdata(with: NSMakeRange(0, range.location)), encoding: encoding)
        buffer.replaceBytes(in: NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)

        guard let line = maybeLine else {
            return nil
        }

        return tokenize(line)
    }

}

extension CorpusReader : Sequence {

    public typealias Iterator = CorpusReader

    /**
     Make corpus iterator

     - returns: Iterator
     */
    public func makeIterator() -> Iterator {
        self.rewind()
        return self
    }

}