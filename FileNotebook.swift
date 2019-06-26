
import UIKit

class FileNotebook {
    
    /// Коллекция заметок в записной книжке
    private (set) lazy var notes = [Note]()
    
    /// Путь к файлу сохранения записной книжки
    private var path: String {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        return path?.appendingPathComponent("Notebook").appendingPathExtension("txt").absoluteString
    }
    
    
    /// Добавить заметку в записную книжку
    func add(_ note: Note) {
        notes.append(note)
    }
    
    /// Удалить заметку по уникальному идентификатору
    func remove(with uid: String) {
        if let index = notes.index(where: { $0.uid == uid }) {
            notes.remove(at: index)
        }
    }
    
    /// Сохранить записную книжку в файл
    func saveToFile() {
        
    }
    
    /// Загрузить записную книжку из файла
    func loadFromFile() {
        if FileManager.default.fileExists(atPath: path) {
            print("File Exist!")
        }
        
        

    }
}


let notebook = FileNotebook()
notebook.add(note)
print(notebook.notes)
notebook.remove(with: note.uid)
print(notebook.notes)
notebook.loadFromFile()