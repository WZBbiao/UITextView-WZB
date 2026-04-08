import UIKit

final class RootViewController: UITableViewController {
    enum Demo: Int, CaseIterable {
        case placeholder
        case autoHeight
        case maxLength
        case attachments

        var title: String {
            switch self {
            case .placeholder:
                return "占位符"
            case .autoHeight:
                return "自动高度"
            case .maxLength:
                return "字数限制"
            case .attachments:
                return "添加图片"
            }
        }

        var detail: String {
            switch self {
            case .placeholder:
                return "原生 UITextView + placeholder"
            case .autoHeight:
                return "聊天输入框式高度增长"
            case .maxLength:
                return "限制最大输入长度并显示当前计数"
            case .attachments:
                return "支持把图片插入到文本流里"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UITextView-WZB"
        tableView.rowHeight = 68
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Demo.allCases.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let demo = Demo.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = demo.title
        cell.detailTextLabel?.text = demo.detail
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let demo = Demo(rawValue: indexPath.row) else { return }
        navigationController?.pushViewController(FeatureDemoViewController(demo: demo), animated: true)
    }
}
