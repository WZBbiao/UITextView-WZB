import UIKit

final class FeatureDemoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    typealias Demo = RootViewController.Demo

    private let demo: Demo
    private let textView = WZBTextView()
    private let helperLabel = UILabel()
    private var textViewHeightConstraint: NSLayoutConstraint?

    init(demo: Demo) {
        self.demo = demo
        super.init(nibName: nil, bundle: nil)
        title = demo.title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTextView()
        configureDemo()
    }

    private func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 17)
        textView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        textView.layer.borderColor = UIColor(white: 0.84, alpha: 1).cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 16
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10)
        view.addSubview(textView)

        helperLabel.translatesAutoresizingMaskIntoConstraints = false
        helperLabel.font = .systemFont(ofSize: 13, weight: .medium)
        helperLabel.textColor = .secondaryLabel
    }

    private func configureDemo() {
        switch demo {
        case .placeholder:
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
            textView.placeholder = "请输入文字，placeholder 会跟随字体、对齐方式和 inset。"
            textView.placeholderColor = .systemRed

        case .autoHeight:
            textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 44)
            textViewHeightConstraint?.isActive = true
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                textView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            textView.placeholder = "继续输入，输入框会自动增高。"
            textView.minHeight = 44
            textView.autoHeight(maxHeight: 140) { [weak self] height in
                self?.textViewHeightConstraint?.constant = height
                self?.view.layoutIfNeeded()
            }

        case .maxLength:
            view.addSubview(helperLabel)
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
                textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                textView.heightAnchor.constraint(equalToConstant: 180),
                helperLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
                helperLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
                helperLabel.leadingAnchor.constraint(greaterThanOrEqualTo: textView.leadingAnchor)
            ])
            textView.placeholder = "最多输入 20 个字符，超出后会自动截断。"
            textView.maxLength = 20
            helperLabel.text = "0/20"
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleTextDidChange),
                name: UITextView.textDidChangeNotification,
                object: textView
            )

        case .attachments:
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
            textView.placeholder = "点击右上角把照片插入到文本里。"
            textView.autoHeight(maxHeight: 220)
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "添加图片",
                style: .plain,
                target: self,
                action: #selector(addImage)
            )
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleTextDidChange() {
        helperLabel.text = "\(textView.text.count)/\(textView.maxLength)"
    }

    @objc private func addImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        present(picker, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        if let image {
            textView.addImage(image)
        }
        picker.dismiss(animated: true)
    }
}
