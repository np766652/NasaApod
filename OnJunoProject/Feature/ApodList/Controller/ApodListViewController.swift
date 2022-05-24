//
//  ViewController.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import UIKit

class ApodListViewController: UIViewController {
    
    @IBOutlet weak var apodListTableView: UITableView!
    private var apodList: [ApodResponse] = []
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getData()
    }
    
    func setupTableView() {
        apodListTableView.dataSource = self
        apodListTableView.backgroundView = UIImageView(image: ImageConstant.backgroundImage.image)
        apodListTableView.separatorStyle = .none
        apodListTableView.register(UINib.init(nibName: "ApodItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ApodItemTableViewCell")
    }

}

// MARK: - API Calls
extension ApodListViewController {
    
    func getData() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "NasaAPIKey") as? String else {
            return
        }
        let apodRequestParams = ApodRequestParams(count: "30", apiKey: apiKey)
        self.isLoading = true
        NetworkManager().getAPODList(queries: apodRequestParams.dictionary ?? [:]) { [weak self] response, error in
            guard let self = self else {return}
            self.isLoading = false
            if let response = response {
                self.apodList = response
            } else {
                self.apodList = []
                DispatchQueue.main.async {
                    self.apodListTableView.backgroundColor = .red
                }
            }
            DispatchQueue.main.async {
                self.apodListTableView.backgroundView = UIView()
                self.apodListTableView.reloadData()
            }
        }
    }
    
}

// MARK: - UITableViewDataSource Methods
extension ApodListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 0 : self.apodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !isLoading,
              indexPath.row < apodList.count,
                let cell = tableView.dequeueReusableCell(withIdentifier: "ApodItemTableViewCell", for: indexPath)
                as? ApodItemTableViewCell else {
            return  UITableViewCell()
        }
        cell.setupView(delegate: self, index: indexPath.row, apodResponse: apodList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
}

// MARK: - ApodItemTableViewCellDelegate Methods
extension ApodListViewController: ApodItemTableViewCellDelegate {
    
    func onLayoutChangeNeeded() {
        self.apodListTableView.beginUpdates()
        self.apodListTableView.endUpdates()
    }
    
    func thumbnailTappedAt(_ index: Int) {
        guard index < apodList.count,
              let urlString = apodList[index].url,
              let url = URL(string: urlString),
              let _mediaType = self.apodList[index].mediaType,
              let mediaType = MediaType(rawValue: _mediaType) else { return }
        
        switch mediaType {
        case .image:
            return
        case .video:
            UIApplication.shared.open(url)
        }
    }
}

