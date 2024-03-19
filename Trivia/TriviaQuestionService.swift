//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Brody Haar on 3/19/24.
//

import Foundation
import UIKit

class TriviaQuestionService {
    static func fetchQuestions(completion: (([TriviaQuestion]) -> Void)? = nil) {
        let url = URL(string: "https://opentdb.com/api.php?amount=5")!
        
        // Create a data task and pass in the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // This closure is fired when the response is received
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            
            // At this point, 'data' contains the data received from the response
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(TriviaAPIResponse.self, from: data)
                // This response will be used to change the UI, so it must happen on the main thread
                DispatchQueue.main.async {
                    completion?(response.triviaQuestion) // Call the completion closure and pass in the questions data model
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume() // Resume the task and fire the request
    }
}
