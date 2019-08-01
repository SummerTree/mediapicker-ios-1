import Foundation

extension Array {
  
  mutating func moveToFirst(_ index: Int) {
    guard index != 0 && index < count else { return }
    
    let item = self[index]
    remove(at: index)
    insert(item, at: 0)
  }
}
