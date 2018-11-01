//
//  ViewController.swift
//  TestRX
//
//  Created by Daniel Freitas on 16/08/2018.
//  Copyright © 2018 Daniel Freitas. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var constfruits = [String]()
    var fruits = Variable(["String"])
    
    private var filter = Variable("String")
    var filterObserver:Observable<String> {
        return filter.asObservable().debounce(0.5, scheduler: MainScheduler.instance)
    }
    
    var fruitsObserver:Observable<[String]> {
        return fruits.asObservable()
    }
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        if let fruitCell = cell as? MyFruitCell {
            fruitCell.name.text = fruits.value[indexPath.row]
        }
        return cell
    }
    
    func setup() {
        constfruits = ["Apple", "Pineapple", "Orange", "Blackberry", "Banana", "Pear", "Kiwi", "Strawberry", "Mango", "Walnut", "Apricot", "Tomato", "Almond", "Date", "Melon", "Water Melon", "Lemon", "Coconut", "Fig", "Passionfruit", "Star Fruit", "Clementin", "Citron", "Cherry", "Cranberry"]
        self.fruits.value = self.constfruits
        self.myTable.reloadData()
        myTable.delegate = self
        myTable.dataSource = self
        searchBar.delegate = self
        self.filter.value = ""
    }
    
    func setupObservers() {
        self.filterObserver.subscribe(onNext: { [weak self] (filter) in
            self?.fruits.value = (self?.constfruits.filter({ (fruit) -> Bool in
                return (fruit.contains(filter) || filter == "")
            }))!
            self?.myTable.reloadData()
        })
        
    }
    
//    private func setupCellConfiguration() {
//        //1
//        self.fruitsObserver
//            .bind(myTable
//                .rx //2
//                .items(cellIdentifier: "myCell",
//                       cellType: MyFruitCell.self)) { // 3
//                        row, fruit, cell in
//                        cell.name.text = fruit //4
//            }
//            .addDisposableTo(self.disposeBag) //5
//    }

}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filter.value = searchText
    }
}


