//
//  GraphicsViewController.swift
//  Prueba-EON
//

import UIKit
import Charts

class GraphicsViewController: UIViewController, ChartViewDelegate  {
    
    @IBOutlet weak var questionGraphs: UILabel!
    
    var lineChart = PieChartView()
    var dataGraphics = [Int]()
    var dataLabel = [String]()
    var indexGraph = 0
    var data: [ChartDataModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
    }
    
    func setTitle(title: String) {
        questionGraphs.text = title
    }
    
    func valueGraphics(data: Int) {
        indexGraph = data
    }
    
    func getInfoGraphics() {
        GraphicsPresenter.shared.getGraphics { response in
            self.data = response.questions[self.indexGraph].chartData
            DispatchQueue.main.async {
                self.questionGraphs.text = response.questions[self.indexGraph].text
            }
            self.data?.forEach { graphic in
                self.dataGraphics.append(graphic.percetnage ?? .zero)
                self.dataLabel.append(graphic.text ?? "")
            }
        } errorHandler: { error in
            print("error")
        }

    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            super.viewWillLayoutSubviews()
            self.lineChart.frame = CGRect(x: 0,
                                    y: 0,
                                          width: self.view.frame.size.width * 0.70,
                                          height: self.view.frame.size.height * 0.70)
            self.lineChart.center = self.view.center
            self.view.addSubview(self.lineChart)
            var indexData = 0
            var entries: [PieChartDataEntry] = []
            for x in self.dataGraphics {
                let dataEntry = PieChartDataEntry(value: Double(x), label: self.dataLabel[indexData])
                entries.append(dataEntry)
                indexData += 1
            }
            
            let set = PieChartDataSet(entries: entries)
            set.colors = ChartColorTemplates.colorful()
            let data = PieChartData(dataSet: set)
            self.lineChart.data = data
        }
    }
}
