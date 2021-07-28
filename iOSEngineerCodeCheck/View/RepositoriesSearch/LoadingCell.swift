import UIKit
import SnapKit

final class LoadingCell: UITableViewCell {

    let indicatorView = UIActivityIndicatorView(style: .medium)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.bottom.equalToSuperview().offset(-48)
            make.centerX.equalToSuperview()
        }
        indicatorView.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
