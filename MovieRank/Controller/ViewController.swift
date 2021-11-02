//
//  ViewController.swift
//  MovieRank
//
//  Created by 박연배 on 2021/11/02.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    
    //MARK: Property
    
    let localRealm = try! Realm()
    
    var results: Results<Movies>!
    var dataArray = List<Movie>()
    
    var movies: Movies? {
        didSet {
            tableView.reloadData()
            print("tableView Reload")
        }
    }
    
    var dateText: String? {
        didSet {
            fetchMoviesRank()
        }
    }
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = self.view.center
        
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        
        return indicator
    }()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        df.locale = Locale(identifier: "ko-KR")
        df.timeZone = TimeZone(identifier: "KST")
        return df
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    //MARK: Method
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        if searchTextField.text!.count != 8 {
            print("여덟글자 아님")
            makeAlert(title: "", message: "형식을 확인해주세요. \n예시) 20210801", buttonTitle1: "확인")
            return
        }
        self.dateText = self.searchTextField.text
    }
    
    func calculateDate() {
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        self.dateText = dateFormatter.string(from: yesterDay!)
    }
    
    
    func fetchMoviesRank() {
        guard let dateText = dateText else {
            return
        }
        
        // id가 일치하는 로컬 저장소의 값이 없을 경우
        if fetchLocalData(id: dateText) {
            print("LocalData중 id가 \(dateText)인 것이 없습니다. 네트워크 통신을 시작합니다.")
            
                
                
            DispatchQueue.main.async {
                self.indicator.startAnimating()
            }
            
            MovieAPIManager.shared.fetchMoviesRank(date: dateText) { json in
                let results = json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue
                
                results.forEach({
                    let data = Movie(openDt: $0["openDt"].stringValue,
                                     rank: $0["rank"].stringValue,
                                     movieNm: $0["movieNm"].stringValue)
                    
                    self.dataArray.append(data)
                })
                
                self.movies = Movies(movies: self.dataArray, id: dateText)
                
                try! self.localRealm.write {
                    self.localRealm.add(self.movies!)
                }
                
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
            }
            
        } else {
            print("LocalData중 id가 \(dateText)인 것이 있습니다. 네트워크 통신을 하지 않습니다.")
        }
    }
    
    func makeAlert(title: String?, message: String?, buttonTitle1: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle1, style: .default)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: MovieRankTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MovieRankTableViewCell.identifier)
    }
    
    func searchButtonConfig() {
        self.searchButton.backgroundColor = .lightGray
        self.searchButton.tintColor = .black
    }
    
    func textFieldConfig() {
        self.searchTextField.placeholder = "20210801"
        self.searchTextField.delegate = self
    }
    
    func fetchLocalData(id: String) -> Bool {
        // 로컬 저장소에 데이터가 있는지 확인
        self.movies = localRealm.object(ofType: Movies.self, forPrimaryKey: id)
        
        // 데이터가 없다면 true, 있다면 false 반환
        let bool = self.movies == nil ? true : false
        
        return bool
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateDate()
        self.results = localRealm.objects(Movies.self)
        self.view.addSubview(indicator)
        
        
        textFieldConfig()
        searchButtonConfig()
        tableViewConfig()
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.movies == nil ? 0 : self.movies!.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieRankTableViewCell.identifier) as? MovieRankTableViewCell else {
            return UITableViewCell()
        }
        
        guard let data = movies?.movies[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.rankLabel.text = data.rank
        cell.rankBackgroundView.backgroundColor = .lightGray
        cell.rankLabel.textColor = .black
        
        cell.titleLabel.text = data.movieNm
        cell.releaseDateLabel.text = data.openDt
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.count != 8 {
            print("여덟글자 아님")
            makeAlert(title: "", message: "형식을 확인해주세요. \n예시) 20210801", buttonTitle1: "확인")
            return false
        }
        searchButtonClicked(self.searchButton)
        return true
    }
}
