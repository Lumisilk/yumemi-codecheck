import UIKit

extension UITableViewCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type) -> T {
        dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
}
