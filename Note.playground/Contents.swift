import UIKit



enum Importance: Int {
    
    case unimportant
    case usual
    case important
    
}




struct Note {
    
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = .white, importance: Importance, selfDestructionDate: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
}






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







class FileNotebook {
    
    /// Коллекция заметок в записной книжке
    private (set) lazy var notes = [Note]()
    
    /// Путь к папке "Caches", куда будет сохраняться записная книжка
    private var cachesDirectoryPath: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    /// Путь к файлу записной книжки
    private var notebookFilePath: URL {
        return cachesDirectoryPath.appendingPathComponent("Notebook").appendingPathExtension("bin")
    }
    
    
    
    
    
    /// Добавить заметку в записную книжку
    func add(_ note: Note) {
        notes.append(note)
    }
    
    /// Удалить заметку по уникальному идентификатору
    func remove(with uid: String) {
        if let index = notes.firstIndex(where: { $0.uid == uid }) {
            notes.remove(at: index)
        }
    }
    
    /// Сохранить записную книжку в файл
    func saveToFile() {
        checkCachesDirectory()
        
        guard let serializatedNotes = serializeNotes() else {
            print("Serialization data is empty")
            return
        }
        
        saveToFile(content: serializatedNotes)
    }
    
    
    /// Загрузить записную книжку из файла
    func loadFromFile() {
        guard notebookFileExist() else {
            print("File .notebook is not exist")
            return
        }
 
        guard let loadedSerializedNotes = loadContentFromFile() else {
            print("Content was loaded with fail")
            return
        }
        
        deserializeNotes(data: loadedSerializedNotes)
    }
    
    
    
    
    
    
    /// Создать папку .caches, если она не была создана ранее
    private func checkCachesDirectory() {
        if cachesDirectoryNotExist() {
            print("Directory .caches does not exist")
            createCachesDirectory()
        }
        print("Directory .caches exist")
    }
    
    
    /// Проверить, существует ли папка .caches
    private func cachesDirectoryNotExist() -> Bool {
        var isDirectory: ObjCBool = true
        return !(FileManager.default.fileExists(atPath: cachesDirectoryPath.absoluteString, isDirectory: &isDirectory))
    }
    
    
    /// Проверить, существует ли файл .notebook
    private func notebookFileExist() -> Bool {
        return FileManager.default.fileExists(atPath: notebookFilePath.absoluteString)
    }
    
    
    /// Создать папку .caches
    private func createCachesDirectory() {
        print("Create new .cashes directory")
        try? FileManager.default.createDirectory(atPath: cachesDirectoryPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
    }
    
    
    /// Загрузить данные из файла
    private func loadContentFromFile() -> Data? {
        return FileManager.default.contents(atPath: notebookFilePath.absoluteString)
    }
    
    
    /// Сериализовать json по данным заметок
    private func serializeNotes() -> Data? {
        do {
            let jsons = notes.map { $0.json }
            return try JSONSerialization.data(withJSONObject: jsons, options: [])
        }
        catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    /// Десериализировать данные по заметкам
    private func deserializeNotes(data: Data) {
        do {
            let notesList = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let notesDictionary = notesList as? [[String: Any]] else {
                print("Casting to Array<Dictionary<String, Any>> was failed")
                return
            }
            
            notesDictionary.forEach {
                if let note = Note.parse(json: $0) {
                    add(note)
                }
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    /// Сохранить контент в файл
    private func saveToFile(content: Data) {
        FileManager.default.createFile(atPath: notebookFilePath.absoluteString, contents: content, attributes: nil)
    }
}



let note = Note(title: "Hello world", content: "It's first note of this application", color: .red, importance: .important, selfDestructionDate: Date())

let notebook = FileNotebook()
notebook.add(note)
print(notebook.notes)

notebook.saveToFile()

notebook.remove(with: note.uid)
print(notebook.notes)

notebook.loadFromFile()
print(notebook.notes)
