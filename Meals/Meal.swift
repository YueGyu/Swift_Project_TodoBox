
struct Meal {
    var date: String
    var lunch: [String]
    var dinner: [String]
    
    init?(dictionary: [String: Any]) {
        guard let date = dictionary["date"] as? String,
          let lunch = dictionary["lunch"] as? [String],
          let dinner = dictionary["dinner"] as? [String]
        else { return nil }
        self.date = date
        self.lunch = lunch
        self.dinner = dinner
    }
    
    func toJSON() -> [String: Any] {
        return [
            "date": self.date,
            "lunch": self.lunch,
            "dinner": self.dinner,
        ]
    }
}
