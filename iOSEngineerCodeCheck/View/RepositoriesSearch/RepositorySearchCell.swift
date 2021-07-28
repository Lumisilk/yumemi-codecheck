import Kingfisher
import UIKit
import SwiftUI
import SnapKit

final class RepositorySearchResultCell: UITableViewCell {
    
    let ownerAvatarImageView = UIImageView()
    let ownerNameLabel = UILabel()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let starIcon = UIImageView()
    let starCountLabel = UILabel()
    let languageLabel = UILabel()
    
    let ownerStack = UIStackView()
    let infoStack = UIStackView()
    let stack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        // owner
        ownerAvatarImageView.layer.cornerRadius = 4
        ownerAvatarImageView.layer.borderColor = UIColor.systemGray5.cgColor
        ownerAvatarImageView.layer.borderWidth = 1
        ownerAvatarImageView.clipsToBounds = true
        ownerAvatarImageView.snp.makeConstraints { make in
            make.size.equalTo(28)
        }
        
        ownerNameLabel.font = .preferredFont(forTextStyle: .footnote)
        
        ownerStack.axis = .horizontal
        ownerStack.spacing = 8
        ownerStack.alignment = .center
        ownerStack.addArrangedSubview(ownerAvatarImageView)
        ownerStack.addArrangedSubview(ownerNameLabel)
        
        // name
        nameLabel.font = .preferredFont(forTextStyle: .title2)
        nameLabel.numberOfLines = 0
        
        // description
        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.numberOfLines = 0
        
        // info
        let config = UIImage.SymbolConfiguration(textStyle: .subheadline)
        starIcon.image = UIImage(systemName: "star", withConfiguration: config)
        starIcon.tintColor = .secondaryLabel
        starCountLabel.font = .preferredFont(forTextStyle: .subheadline)
        starCountLabel.textColor = .secondaryLabel
        
        languageLabel.font = .preferredFont(forTextStyle: .subheadline)
        languageLabel.textColor = .secondaryLabel
        
        infoStack.axis = .horizontal
        infoStack.spacing = 4
        infoStack.alignment = .firstBaseline
        infoStack.addArrangedSubview(starIcon)
        infoStack.addArrangedSubview(starCountLabel)
        infoStack.addArrangedSubview(languageLabel)
        infoStack.setCustomSpacing(8, after: starCountLabel)
        
        // whole
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.addArrangedSubview(ownerStack)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(infoStack)
        stack.setCustomSpacing(12, after: descriptionLabel)
        
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
    
    func configure(repository: RepositorySearchResult.Repository) {
        ownerAvatarImageView.kf.setImage(with: repository.owner.avatarUrl)
        ownerNameLabel.text = repository.owner.login
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        descriptionLabel.isHidden = repository.description == nil
        starCountLabel.text = String(repository.stargazersCount)
        languageLabel.text = repository.language
    }
}

struct RepositorySearchResultCellPreview: PreviewProvider {
    static var previews: some View {
        RepositorySearchViewControllerRepresentable(delay: 0.1)
    }
}
