
import UIKit
import Alamofire

class MealListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let schoolSelectButton = UIBarButtonItem(
        title: "학교 선택",
        style: .plain,
        target: nil,
        action: #selector(schoolSelectButtonItemDidSelect)
    )
    
    let tableView = UITableView()
    let toolbar = UIToolbar()
    let prevMonthButtonItem = UIBarButtonItem(
        title: "이전달",
        style: .plain,
        target: nil,
        action: nil
    )
    let nextMonthButtonItem = UIBarButtonItem(
        title: "다음달",
        style: .plain,
        target: nil,
        action: nil
    )
    
    var school: School?
    var date: (year: Int, month: Int)
    var meals: [Meal] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let today = Date()
        let year = Calendar.current.component(Calendar.Component.year, from: today)
        let month = Calendar.current.component(Calendar.Component.month, from: today)
        self.date = (year: year, month: month)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolSelectButton.target = self
        self.schoolSelectButton.action =
         #selector(schoolSelectButtonItemDidSelect)
        self.prevMonthButtonItem.target = self
        self.prevMonthButtonItem.action = #selector(prevMonthButtonItemDidSelect)
        self.nextMonthButtonItem.target = self
        self.nextMonthButtonItem.action = #selector(nextMonthButtonItemDidSelect)
        
        self.tableView.register(MealCell.self, forCellReuseIdentifier:
            "mealCell")
        self.navigationItem.rightBarButtonItem = self.schoolSelectButton
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset.bottom = 100
        self.toolbar.items = [
            self.prevMonthButtonItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil,
            action: nil),
            self.nextMonthButtonItem,
        ]
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.toolbar)
        self.loadMeals()
    }
    
    override func viewDidLayoutSubviews() { ///화면이 변환되도 프레임이 자동 변환됨
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
        self.toolbar.frame = CGRect(
            x: 0,
            y: self.view.frame.size.height - 44,
            width: self.view.frame.size.width,
            height: 44
        )
    }
    
    func loadMeals() {
        guard let schoolCode = self.school?.code else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let baseURLString = "https://schoool.herokuapp.com"
        let path = "/school/\(schoolCode)/meals"
        let urlString = baseURLString + path
        let parameters: [String: Any] = [
            "year": self.date.year,
            "month": self.date.month,
        ]
        
        Alamofire.request(urlString, parameters: parameters).responseJSON { response in
            guard let json = response.result.value as? [String: [[String:Any]]],
                let dicts = json["data"]
                else { return }
            
            self.meals = dicts.flatMap {
                return Meal(dictionary: $0)
            }
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func schoolSelectButtonItemDidSelect() {
        let schoolSearchViewController = SchoolSearchViewController()
        schoolSearchViewController.didSelectSchool = { school in
            self.school = school
            self.loadMeals()
        }
        let navigationController = UINavigationController(
            rootViewController: schoolSearchViewController
        )
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func prevMonthButtonItemDidSelect() {
        var newYear = self.date.year
        var newMonth = self.date.month - 1
        if newMonth <= 0 {
            newMonth = 12
            newYear -= 1
        }
        self.date = (year: newYear, month: newMonth)
        loadMeals()
    }
    
    func nextMonthButtonItemDidSelect() {
        var newYear = self.date.year
        var newMonth = self.date.month + 1
        if newMonth >= 13 {
            newMonth = 1
            newYear += 1
        }
        self.date = (year: newYear, month: newMonth)
        loadMeals()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.meals.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            return 2
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String? {
            let meal = self.meals[section]
            return meal.date
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "mealCell",
                for: indexPath
                ) as! MealCell
            
            let meal = self.meals[indexPath.section]
            if indexPath.row == 0 {
                cell.titleLabel.text = "점심"
                cell.contentLabel.text = meal.lunch.joined(separator: ", ")
            } else {
                cell.titleLabel.text = "저녁"
                cell.contentLabel.text = meal.dinner.joined(separator: ", ")
            }
            cell.contentLabel.numberOfLines = 0
            return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            let meal = self.meals[indexPath.section]
            if indexPath.row == 0 {
                return MealCell.height(
                    width: tableView.frame.size.width,
                    title: "점심",
                    content: meal.lunch.joined(separator: ", ")
                )
            } else {
                return MealCell.height(
                    width: tableView.frame.size.width,
                    title: "저녁",
                    content: meal.dinner.joined(separator: ", ")
                )
            }
    }
}

