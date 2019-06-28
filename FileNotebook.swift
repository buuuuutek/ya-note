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
