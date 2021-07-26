//
//  ExerciseService.swift
//  carousel
//
//  Created by Mahvish Syed on 22/07/21.
//

import Foundation

class ExerciseService {
    
    private let URL_STRING = "https://jsonblob.com/api/jsonBlob/d92ee4cd-dff6-11eb-a8ab-05b78a9f1668"

    typealias CompletionHandler = (_ exerciseDataModel : [ExerciseDataModel]?) -> Void
    
    func requestDataforExercise(completionHandler : @escaping CompletionHandler) {
        
        let urlOriginalString = URL_STRING
        let urlString = urlOriginalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let validurlString = urlString
            else{
                return
        }
        
        guard let validUrl = URL(string:validurlString)
            else{
                print("Invalid Url")
                return
        }
        
        URLSession.shared.dataTask(with: validUrl, completionHandler: { data, response, error in
            
            // Validation
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            
            // Convert data to models/some object
            
            var json: [ExerciseDataModel]?
            do {
                json = try JSONDecoder().decode([ExerciseDataModel].self, from: data)
            }
            catch {
                completionHandler(nil)
                print("Found Error: \(error)")
            }
            
            guard let result = json else {
                completionHandler(nil)
                return
            }
            
            completionHandler(result)
            
        }).resume()
    }
}
