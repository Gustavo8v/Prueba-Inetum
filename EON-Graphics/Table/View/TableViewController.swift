//
//  TableViewController.swift
//  Prueba-EON
//
//  Created by Gustavo on 23/12/21.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var informationTableView: UITableView!
    @IBOutlet weak var uploadImageButton: UIButton!
    
    var infoGraphics: GraphicsModel?
    var nameUser: String?
    var presenter = TablePresenter()
    var imageSelected: UIImage?
    var dataImage: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        configureNavBar()
        getGraphics()
        configureButton()
    }
    
    func configureButton(){
        uploadImageButton.layer.cornerRadius = 12
        validationButton()
    }
    
    func validationButton(){
        let validation = presenter.enabledButton(button: self.uploadImageButton, image: self.imageSelected, name: self.nameUser)
        uploadImageButton.isEnabled = validation
        uploadImageButton.backgroundColor = validation ? .systemBlue : .gray
    }
    
    func configureNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Prueba"
    }
    
    func configureTable() {
        informationTableView.dataSource = self
        informationTableView.delegate = self
        informationTableView.register(UINib(nibName: NameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NameTableViewCell.identifier)
        informationTableView.register(UINib(nibName: SelfieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SelfieTableViewCell.identifier)
        informationTableView.register(UINib(nibName: GraficasTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GraficasTableViewCell.identifier)
    }
    
    func getGraphics(){
        GraphicsPresenter.shared.getGraphics { response in
            self.infoGraphics = response
            DispatchQueue.main.sync {
                self.informationTableView.reloadData()
            }
        } errorHandler: { errpr in
            print("errpr")
        }
    }
    
    @IBAction func onClickUploadImageFirestore(_ sender: Any) {
        presenter.uploadPhoto(dataImage: dataImage, name: nameUser) { response in
            DispatchQueue.main.async {
                self.nameUser = nil
                self.imageSelected = nil
                self.dataImage = nil
                self.informationTableView.reloadData()
            }
            self.present(self.presenter.showAlertController(title: "¡Bien!", message: "Hemos subido la imagen"), animated: true)
        } errorsHandler: { error in
            print("error")
            self.present(self.presenter.showAlertController(title: "¡Ups!", message: "Hemos tenido un error al intentar subir la imagen, por favor intenta de nuevo"), animated: true)
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let switchIndex = TypeCellsInformation(rawValue: section)
        switch switchIndex {
        case .name, .selfie, .none:
            return 1
        case .graphics:
            return self.infoGraphics?.questions.count ?? .zero
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        guard let switchTable = TypeCellsInformation(rawValue: indexPath.section) else { return cell }
        switch switchTable {
        case .name:
            guard let cellName = tableView.dequeueReusableCell(withIdentifier: NameTableViewCell.identifier, for: indexPath) as? NameTableViewCell else { return cell }
            cellName.selectionStyle = .none
            cellName.delegate = self
            cellName.configureName(name: nameUser)
            cell = cellName
        case .selfie:
            guard let cellSelfie = tableView.dequeueReusableCell(withIdentifier: SelfieTableViewCell.identifier, for: indexPath) as? SelfieTableViewCell else { return cell }
            cellSelfie.selectionStyle = .none
            cellSelfie.configure(image: imageSelected)
            cell = cellSelfie
        case .graphics:
            guard let cellGraphics = tableView.dequeueReusableCell(withIdentifier: GraficasTableViewCell.identifier, for: indexPath) as? GraficasTableViewCell else { return cell }
            guard let dataIndex = infoGraphics?.questions[indexPath.row] else { return cell }
            cellGraphics.configure(data: dataIndex)
            cellGraphics.selectionStyle = .none
            cell = cellGraphics
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let switchHeader = TypeCellsInformation(rawValue: section)
        switch switchHeader {
        case .name, .selfie, .none:
            return nil
        case .graphics:
            return "Graficas"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let switchTable = TypeCellsInformation(rawValue: indexPath.section)
        switch switchTable {
        case .name:
            break
        case .selfie:
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.delegate = self
            picker.modalPresentationStyle = .formSheet
            present(picker, animated: true)
        case .graphics:
            let vc = GraphicsViewController()
            vc.modalPresentationStyle = .formSheet
            vc.indexGraph = indexPath.row
            vc.getInfoGraphics()
            present(vc, animated: true, completion: nil)
        case .none:
            break
        }
    }
}

extension TableViewController: NameTableViewCellDelegate {
    func saveName(name: String) {
        self.nameUser = name
        validationButton()
    }
}

extension TableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        validationButton()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        self.dataImage = imageData
        self.imageSelected = image
        validationButton()
        DispatchQueue.main.async {
            self.informationTableView.reloadData()
        }
    }
}
