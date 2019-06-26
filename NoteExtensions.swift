//: Playground - noun: a place where people can play

import UIKit

extension Note {
    
    /// Свойство формирования JSON
    var json: [String: Any] {
        var newjson: [String: Any] = ["uid" : uid, "title" : title, "content" : content]
        
        if color != .white {
            newjson["color"] = getComponents(from: color)
        }
        
        if importance != .usual {
            newjson["importance"] = importance.rawValue
        }
        
        newjson["selfDestructionDate"] = selfDestructionDate?.timeIntervalSince1970
        return newjson
    }
    
    
    /// Функция разбора JSON
    static func parse(json: [String: Any]) -> Note? {
        let uid = decodeString(from: json, forKey: "uid")
        
        let title = decodeString(from: json, forKey: "title")
        
        let content = decodeString(from: json, forKey: "content")
        
        let color = decodeColor(from: json, forKey: "color")
        
        let importance = decodeImportance(from: json, forKey: "importance")
        
        let selfDestructionDate = decodeDate(from: json, forKey: "selfDestructionDate")
        
        
        // Чтобы не было дублирования, важно отслеживать пришёл ли уникальный идентификатор или нет.
        // Остальные параметры не так важны для дедублирования.
        if uid.isEmpty {
            return Note(title: title, content: content, color: color, importance: importance, selfDestructionDate: selfDestructionDate)
        } else {
            return Note(uid: uid, title: title, content: content, color: color, importance: importance, selfDestructionDate: selfDestructionDate)
        }
    }
    
    
    /// Вычленение строки из json со всеми соответствующими проверками
    private static func decodeString(from json: [String: Any], forKey key: String) -> String {
        guard let foundParameter = json[key], let stringParameter = foundParameter as? String else {
            return String()
        }
        
        return stringParameter
    }
    
    
    /// Вычленение цвета из json со всеми соответствующими проверками
    private static func decodeColor(from json: [String: Any], forKey key: String) -> UIColor {
        guard let foundParameter = json[key], let colorComponents = foundParameter as? [String: Double] else {
            return UIColor.white
        }
        
        return getColor(from: colorComponents)
    }
    
    
    /// Вычленение приоритета из json со всеми соответствующими проверками
    private static func decodeImportance(from json: [String: Any], forKey key: String) -> Importance {
        guard let foundParameter = json[key], let rawValueParameter = foundParameter as? Int, let importanceValue = Importance(rawValue: rawValueParameter) else {
            return Importance.usual
        }
        
        return importanceValue
    }
    
    
    /// Вычленение даты уничтожения из json со всеми соответствующими проверками
    private static func decodeDate(from json: [String: Any], forKey key: String) -> Date? {
        guard let foundParameter = json[key], let timeIntervalOfParameter = foundParameter as? TimeInterval else {
            return nil
        }
        
        return Date(timeIntervalSince1970: timeIntervalOfParameter)
    }
    
    
    /// Разложение цвета на компоненты
    private func getComponents(from color: UIColor) -> [String: Double] {
        var r = CGFloat(), g = CGFloat(), b = CGFloat(), a = CGFloat()
    
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return ["red":Double(r), "green":Double(g), "blue":Double(b), "alpha":Double(a)]
    }
    
    
    /// Сборка компонентов в один цвет
    private static func getColor(from components: [String: Double]) -> UIColor {
        guard let red = components["red"],
            let green = components["green"],
            let blue = components["blue"],
            let alpha = components["alpha"] else { return .white }
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}






