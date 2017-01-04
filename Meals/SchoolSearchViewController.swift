
import UIKit
import Alamofire

class SchoolSearchViewController: UIViewController, UISearchBarDelegate,
    UITableViewDelegate, UITableViewDataSource {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    var didSelectSchool: ((School) -> Void)?
    var schools: [School] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.searchBar)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset.top = 44
        self.tableView.scrollIndicatorInsets.top = 44
        
        self.searchBar.delegate = self
        self.searchBar.placeholdr = "학교 이름"
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchBar.frame = CGRect(
            x: 0,
            y: 64,
            width: self.view.frame.size.width,
            height: 44
        )
        self.tableView.frame = self.view.bounds
    }
    
    func searchSchools(query: String) {
        let urlString = "https://schoool.herokuapp.com/school/search"
        let parameters: [String: Any] = [
            "query": query,
        ]
        Alamofire.request(urlString, parameters: parameters)
            .responseJSON { response in
                guard let json = response.result.value as? [String: [[String: Any]]],
                    let dicts = json["data"]
                    else { return }
                self.schools = dicts.flatMap {
                    return School(dictionary: $0)
                }
                self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.searchSchools(query: query)
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            return self.schools.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:
            indexPath)
        let school = self.schools[indexPath.row]
        cell.textLabel?.text = school.name
        
        switch school.type {
            case "초등학교":
                cell.imageView?.image = UIImage(named: "icon_elementary")
            case "중학교":
                cell.imageView?.image = UIImage(named: "icon_middle")
            case "고등학교":
                cell.imageView?.image = UIImage(named: "icon_high")
        default:
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = self.schools[indexPath.row]
        self.didSelectSchool?(school)
        self.dismiss(animated: true, completion: nil)
    }
}
