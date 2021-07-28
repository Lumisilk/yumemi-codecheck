import UIKit
import SnapKit

final class LoadingCell: UITableViewCell {

    let indicatorView = UIActivityIndicatorView(style: .medium)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addIndicatorView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addIndicatorView() {
        contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }
        indicatorView.startAnimating()
    }
}
