//
//  GraphicsModel.swift
//  Prueba-EON
//
//  Created by Gustavo on 23/12/21.
//

import Foundation

struct GraphicsModel: Codable {
    var colors: [String] = []
    var questions: [QuestionsModel] = []
}

struct QuestionsModel: Codable {
    var total: Int? = nil
    var text: String? = nil
    var chartData: [ChartDataModel] = []
}

struct ChartDataModel: Codable {
    var text: String? = nil
    var percetnage: Int? = nil
}
