//
//  HomeViewController.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import UIKit

final class HomeViewController: UIViewController {
    lazy var interactor = BeersInteractorImpl()
    
    var yourDataArray: [Beer] = []
    var filteredDataArray: [String] = []
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Pesquisar"
        search.barTintColor = UIColor(cgColor: CGColor(red: 74, green: 144, blue: 226, alpha: 1))
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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beer List"
        view.backgroundColor = UIColor(cgColor: CGColor(red: 244, green: 244, blue: 244, alpha: 1.0))
        interactor.getBeers(page: 1) { [weak self] result in
            switch result {
            case .success(let beers):
                self?.yourDataArray.append(contentsOf: beers)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
                break
            }
        }
        
//        filteredDataArray = yourDataArray
        
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: "BeerCell")

        setupLayout()
        setupConstraint()

        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
//            filteredDataArray = yourDataArray
        } else {
//            filteredDataArray = yourDataArray.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if yourDataArray.isEmpty {
            tableView.backgroundView = emptyResultLabel
            return 0
        } else {
            tableView.backgroundView = nil
            return yourDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as! BeerTableViewCell
        cell.beer = yourDataArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = yourDataArray[indexPath.row]
        
        let details = DetailsViewController()
        details.selectedItem = selectedBeer
        
        self.navigationController?.pushViewController(details, animated: true)
    }
}

