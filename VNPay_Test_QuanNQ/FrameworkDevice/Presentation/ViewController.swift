//
//  ViewController.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var photoTableView: UITableView!
    private var photos = [PhotoModel]()
    private let searchBar = UISearchBar()
    private let photoCellID = "PhotoTableViewCell"
    private var viewModel: PhotoViewModel?
    private var currentPage = 0
    private let limit = 100
    private let pageCount = 10
    private var allowLoadmore = true
    private var allowRefesh = true
    private let refreshControll = UIRefreshControl()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingIndicator.center = view.center
    }

    private func configure() {
        let remote = RemotePhotoDataSource()
        let repo = PhotoRepository(remoteDataSource: remote)
        let usecase = PhotoUseCase(repository: repo)
        viewModel = PhotoViewModel(photoUseCase: usecase)
    }
    
    private func setupUI() {
        self.setupSearchBar()
        self.setupTableView()
        self.setupRefreshControll()
        self.bindingViewModel()
        self.dismissKeyBoard()
        self.setupLoading()
    }
    
    private func setupRefreshControll() {
        refreshControll.tintColor = .red
        refreshControll.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControll.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        photoTableView.refreshControl = refreshControll
    }
    
    private func bindingViewModel() {
        viewModel?.fetchPhotos()
        viewModel?.onPhotoUpdated = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.photoTableView.tableFooterView = nil
                self?.refreshControll.endRefreshing()
                self?.photoTableView.reloadData()
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
    
    private func setupSearchBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.searchBar.placeholder = "Tìm kiếm..."
        self.searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.7)
        self.searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor
        self.searchBar.searchTextField.layer.borderWidth = 1
        self.searchBar.searchTextField.layer.cornerRadius = 8
        self.searchBar.searchTextField.clearButtonMode = .always
        self.searchBar.tintColor = .red
        self.searchBar.delegate = self
        self.searchBar.enableSimpleInputValidation()
    }
    
    private func setupLoading() {
        self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = true
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.color = .red
        self.view.insertSubview(loadingIndicator, aboveSubview: photoTableView)
        self.loadingIndicator.startAnimating()
    }

    private func setupTableView() {
        self.photoTableView.delegate = self
        self.photoTableView.dataSource = self
        self.photoTableView.prefetchDataSource = self
        self.photoTableView.estimatedRowHeight = 250
        self.photoTableView.rowHeight = UITableView.automaticDimension
        self.photoTableView.register(UINib(nibName: photoCellID, bundle: nil),forCellReuseIdentifier: photoCellID)
    }
    
    private func loadPhoto(url: URL, completion: ((UIImage?) -> Void)?) {
        viewModel?.downloadPhoto(url: url, completion: { data in
            guard let data = data, let photo = UIImage(data: data) else {
                completion?(nil)
                return
            }
            DispatchQueue.global().async {
                let resizedImage = photo.resizedToWidth(ratio: Float(photo.size.width / photo.size.height))
                ImageCacheManager.shared.save(resizedImage, for: url)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    completion?(resizedImage)
                }
            }
            
        })
    }
    
    @objc
    private func refreshData() {
        if allowRefesh {
            viewModel?.refreshPhotos()
        } else {
            refreshControll.endRefreshing()
        }
    }
    
    private func createLoadMoreView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .red
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    private func dismissKeyBoard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func hideKeyBoard() {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    // download trước ảnh trước khi các cell xuất hiện
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let viewModel = viewModel {
            for indexPath in indexPaths {
                let urlString = viewModel.photos[indexPath.row].downloadURL
                guard let url = URL(string: urlString ?? ""),
                    ImageCacheManager.shared.getImage(for: url) == nil
                else { continue }
                loadPhoto(url: url, completion: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: photoCellID) as? PhotoTableViewCell {
            if let viewModel = viewModel {
                cell.configuration(photo: viewModel.photos[indexPath.row])
                if let urlString = viewModel.photos[indexPath.row].downloadURL, let url = URL(string: urlString) {
                    cell.currentImageURL = url
                    // Check nếu có ảnh trong cache thì dùng luôn
                    if let cachedImage = ImageCacheManager.shared.getImage(for: url) {
                        cell.setImage(image: cachedImage)
                    } else {
                        cell.startLoading()
                        cell.photoImg.image = nil
                        self.loadPhoto(url: url) { [weak self] image in
                            DispatchQueue.main.async {
                                if cell.currentImageURL == url {
                                    cell.setImage(image: image)
//                                    self?.photoTableView.beginUpdates()
//                                    self?.photoTableView.endUpdates()
                                }
                            }
                        }
                    }
                }}
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let viewModel = self.viewModel {
            // Load more khi lastIndex Path  == độ dài của list data
            let lastIndex = viewModel.photos.count - 1
            if indexPath.row == lastIndex {
                if allowLoadmore && currentPage < pageCount {
                    tableView.tableFooterView = createLoadMoreView()
                    currentPage += 1
                    viewModel.loadMore(page: currentPage)
                }
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Xử lý khi search thì không cho load more và refresh
        if searchText.isEmpty {
            allowLoadmore = true
            allowRefesh = true
        } else {
            allowLoadmore = false
            allowRefesh = false
        }
        viewModel?.searchPhoto(query: searchText)
    }
}
