//
//  ExtensionPrintReceiveOnTests.swift
//  ClarityTests
//
//  Created by Lawrie Development on 23/06/2022.
//

import XCTest
import Combine
@testable import Clarity
 


final class ExtensionPrintReceiveOnTests: XCTestCase , ObservableObject{
    
    @Published var time = ""
    @Published var users = [User]()
    

    struct User: Decodable, Identifiable{
        let id: Int
        let name: String
    }

    func test_printoMethodOverloadPrefixCompilationAlignmentVisualConsoleCheck()  {
        var cancellables = Set<AnyCancellable>()
        let url = URL(string: "http://jsonplaceholder.typicode.com/users")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                // Handle error
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                    throw URLError(.badServerResponse)
                }
                return data
            }
            //decode returned data (as JSON)
            .decode(type: [User].self, decoder: JSONDecoder())
            //Ensure subscription on the main querue
            .receive(on: DispatchQueue.main).print(600, to: nil)?
            //Subscribe
            .sink(receiveCompletion: {_ in}) { users in
            }
            .store(in: &cancellables)
        //For alignment check
        print(2)
    }
    
    func test_printLogicReturnsCorrectPrefixForPublisherReceive()  {
        
        let prefix = printer.printLogic(600)
        XCTAssertEqual(prefix, "ZZYY       889    R-600   ⌚️  - Publisher info")
    }
    

    
    
    
}
