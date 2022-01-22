//
//  GraphicsPresenter.swift
//  Prueba-EON
//
//  Created by Gustavo on 23/12/21.
//

import Foundation

class GraphicsPresenter {
    
    static let shared: GraphicsPresenter = GraphicsPresenter()
    
    func getGraphics(completionHandler: @escaping(GraphicsModel) -> Void, errorHandler: @escaping(Error) -> Void){
            let url = URL(string: "https://us-central1-bibliotecadecontenido.cloudfunctions.net/helloWorld")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                do{
                    if let jData = data {
                        let decodedData = try JSONDecoder().decode(GraphicsModel.self,from: jData)
                        completionHandler(decodedData)
                        print("jason: \(decodedData)")
                    }
                }catch{
                    errorHandler(error)
                    print("Error: \(error)")
                }
            }.resume()
        }
}
