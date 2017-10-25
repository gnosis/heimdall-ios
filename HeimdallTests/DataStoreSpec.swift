//
//  DataStoreSpec.swift
//  HeimdallTests
//
//  Created by Luis Reisewitz on 25.10.17.
//  Copyright © 2017 Gnosis. All rights reserved.
//

@testable import Heimdall
import Nimble
import Quick

struct TestData: Codable {
    let field1: String
    let field2: Int
}

extension TestData: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.field1 == rhs.field1 && lhs.field2 == rhs.field2
    }
}

class DataStoreSpec: QuickSpec {
    let key = "testKey1"
    
    override func spec() {
        describe("DocumentsDataStore") {
            beforeEach {
                // Clear Documents directory before tests
                
            }
            it("should be able to retrieve and store test data") {
                let data = TestData(field1: "testString1", field2: 234_567_890)
                let store = DocumentsDataStore()
                expect { try store.store(data, for: self.key) }.toNot(throwError())
                expect {
                    let data: TestData = try store.fetch(key: self.key)
                    return data
                }.to(equal(data))
            }
        }
    }
}
