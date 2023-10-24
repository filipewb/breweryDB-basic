//
//  HomeViewController.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import UIKit

import UIKit

final class HomeViewController: UIViewController, UIScrollViewDelegate {
    lazy var interactor: BeersInteractor = BeersInteractorImpl()
    
    var yourDataArray: [Beer] = []
    var filteredDataArray: [Beer] = []
    var pagedDataArray: [Beer] = []
    
    private var currentPage = 1
    private var isLoading = false
    private var showFavoritesOnly = false
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search"
        search.barTintColor = .white
        search.delegate = self
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyResultLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum resultado encontrado"
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(filterButtonTapped))
        button.tintColor = .white
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDataAndReloadTable()
        
        filterButton.title = "All"
        showFavoritesOnly = false
    }
    
    func setupUI() {
        title = "Beer List"
        view.backgroundColor = .lightGray
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = filterButton
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: "BeerCell")
        tableView.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.bottomAnchor),
        ])
    }
    
    func fetchInitialData() {
        interactor.getBeers(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let beers):
                self.yourDataArray = beers
                self.updateFavoriteStates()
                self.pagedDataArray = beers // Atualiza pagedDataArray com os dados da primeira página
                self.filteredDataArray = self.yourDataArray
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateFavoriteStates() {
        for (index, beer) in yourDataArray.enumerated() {
            yourDataArray[index].isFavorite = isBeerFavorite(item: beer)
        }
        tableView.reloadData()
    }
    
    func isBeerFavorite(item: Beer) -> Bool {
        if let favoriteBeerIds = UserDefaults.standard.array(forKey: "favoriteBeerIds") as? [Int] {
            return favoriteBeerIds.contains(item.id)
        }
        return false
    }
    
    func updateDataAndReloadTable() {
        interactor.getBeers(page: 1) { [weak self] result in
            switch result {
            case .success(let beers):
                self?.yourDataArray = beers
                self?.updateFavoriteStates()
                self?.filteredDataArray = self?.yourDataArray ?? []
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func filterButtonTapped() {
        showFavoritesOnly.toggle()
        if showFavoritesOnly {
            filteredDataArray = yourDataArray.filter { $0.isFavorite }
            filterButton.title = "Favorites"
        } else {
            filteredDataArray = yourDataArray
            filterButton.title = "All"
        }
        tableView.reloadData()
    }
    
    func loadMoreData() {
        if !isLoading {
            isLoading = true
            currentPage += 1
            interactor.getBeers(page: currentPage) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let beers):
                    if !beers.isEmpty {
                        self.pagedDataArray = beers // Atualiza pagedDataArray com os novos dados paginados
                        self.yourDataArray.append(contentsOf: beers)
                        self.updateFavoriteStates()
                        if self.showFavoritesOnly {
                            self.filteredDataArray = self.yourDataArray.filter { $0.isFavorite }
                        } else {
                            self.filteredDataArray = self.yourDataArray
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
                self.isLoading = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredDataArray = yourDataArray
        } else {
            filteredDataArray = yourDataArray.filter { beer in
                return beer.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredDataArray.isEmpty {
            tableView.backgroundView = emptyResultLabel
            return 0
        } else {
            tableView.backgroundView = nil
            return filteredDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as! BeerTableViewCell
        cell.beer = filteredDataArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = filteredDataArray[indexPath.row]
        let details = DetailsViewController()
        details.selectedItem = selectedBeer
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        if offsetY + screenHeight > contentHeight {
            if !isLoading {
                activityIndicator.startAnimating()
                loadMoreData()
            }
        }
    }
}

