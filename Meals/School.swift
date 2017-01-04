
struct School {
    var name: String
    var type: String
    var code: String
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let type = dictionary["type"] as? String,
            let code = dictionary["code"] as? String
            else { return nil }
        self.name = name
        self.type = type
        self.code = code
    }
    
    func toJSON() -> [String: Any] {
        return [
            "name": self.name,
            "type": self.type,
            "code": self.code,
        ]
    }
}
