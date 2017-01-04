
import UIKit

class MealCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.contentLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func height(width: CGFloat, title: String, content: String) -> CGFloat {
        let titleWidth = self.size(for: title, width: 0, font: UIFont.boldSystemFont(ofSize: 15)).width
        let contentWidth = width - titleWidth - 10 - 10 - 10
        let contentHeight = self.size(
            for: content,
            width: contentWidth,
            font: UIFont.systemFont(ofSize: 15)
        ).height
        return 10 + contentHeight + 10
    }
    
    class func size(for string: String, width: CGFloat, font: UIFont) -> CGSize {
        let rect = string.boundingRect(
            with: CGSize(width: width, height: 0),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [NSFontAttributeName: font],
            context: nil
        )
        return rect.size
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame.origin.x = 10
        self.titleLabel.frame.origin.y = 10
        self.titleLabel.sizeToFit()
        
        let cellWidth = self.contentView.frame.size.width
        let titleLabelRight = self.titleLabel.frame.maxX
        self.contentLabel.frame.origin.x = titleLabelRight + 10
        self.contentLabel.frame.size.width = cellWidth
            - self.contentLabel.frame.origin.x
            - 10
        self.contentLabel.sizeToFit()
    }
}
