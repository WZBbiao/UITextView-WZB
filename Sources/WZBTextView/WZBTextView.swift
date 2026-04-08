import UIKit

open class WZBTextView: UITextView {
    public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
            updatePlaceholderVisibility()
            setNeedsLayout()
        }
    }

    public var placeholderColor: UIColor = .placeholderText {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    public var minHeight: CGFloat = 0 {
        didSet {
            recalculateHeightIfNeeded()
        }
    }

    public var maxHeight: CGFloat = 0 {
        didSet {
            recalculateHeightIfNeeded()
        }
    }

    public var maxLength: Int = 0 {
        didSet {
            enforceMaxLengthIfNeeded()
        }
    }

    public var onHeightChange: ((CGFloat) -> Void)?

    public override var text: String! {
        didSet {
            updatePlaceholderVisibility()
            recalculateHeightIfNeeded()
        }
    }

    public override var attributedText: NSAttributedString! {
        didSet {
            updatePlaceholderVisibility()
            recalculateHeightIfNeeded()
        }
    }

    public override var font: UIFont? {
        didSet {
            placeholderLabel.font = font ?? .systemFont(ofSize: 16)
            setNeedsLayout()
        }
    }

    public override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    public override var textContainerInset: UIEdgeInsets {
        didSet {
            setNeedsLayout()
            recalculateHeightIfNeeded()
        }
    }

    public override var bounds: CGRect {
        didSet {
            guard oldValue.size != bounds.size else { return }
            setNeedsLayout()
            recalculateHeightIfNeeded()
        }
    }

    public override var intrinsicContentSize: CGSize {
        if let calculatedHeight {
            return CGSize(width: UIView.noIntrinsicMetric, height: calculatedHeight)
        }
        return super.intrinsicContentSize
    }

    private let placeholderLabel = UILabel()
    private var calculatedHeight: CGFloat?
    private var lastReportedHeight: CGFloat?
    private var insertedImages: [UIImage] = []
    private var textDidChangeObserver: NSObjectProtocol?
    private var isEnforcingMaxLength = false

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    deinit {
        if let textDidChangeObserver {
            NotificationCenter.default.removeObserver(textDidChangeObserver)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutPlaceholderLabel()
    }

    public func images() -> [UIImage] {
        insertedImages
    }

    public func autoHeight(maxHeight: CGFloat, onHeightChange: ((CGFloat) -> Void)? = nil) {
        if minHeight == 0 {
            minHeight = max(bounds.height, 36)
        }
        self.maxHeight = maxHeight
        self.onHeightChange = onHeightChange
        recalculateHeightIfNeeded()
    }

    public func addImage(_ image: UIImage) {
        insertImage(image, size: .zero, index: attributedText?.length ?? 0)
    }

    public func addImage(_ image: UIImage, size: CGSize) {
        insertImage(image, size: size, index: attributedText?.length ?? 0)
    }

    public func insertImage(_ image: UIImage, size: CGSize, index: Int) {
        let resolvedSize = resolveImageSize(for: image, preferredSize: size, multiple: nil)
        insertAttachment(image: image, size: resolvedSize, index: index)
    }

    public func addImage(_ image: UIImage, multiple: CGFloat) {
        insertImage(image, multiple: multiple, index: attributedText?.length ?? 0)
    }

    public func insertImage(_ image: UIImage, multiple: CGFloat, index: Int) {
        let resolvedSize = resolveImageSize(for: image, preferredSize: .zero, multiple: multiple)
        insertAttachment(image: image, size: resolvedSize, index: index)
    }

    private func commonInit() {
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.backgroundColor = .clear
        placeholderLabel.font = font ?? .systemFont(ofSize: 16)
        addSubview(placeholderLabel)

        textDidChangeObserver = NotificationCenter.default.addObserver(
            forName: UITextView.textDidChangeNotification,
            object: self,
            queue: .main
        ) { [weak self] _ in
            self?.enforceMaxLengthIfNeeded()
            self?.updatePlaceholderVisibility()
            self?.recalculateHeightIfNeeded()
        }
    }

    private func layoutPlaceholderLabel() {
        let horizontalInset = textContainerInset.left + textContainer.lineFragmentPadding
        let verticalInset = textContainerInset.top
        let maxWidth = max(
            0,
            bounds.width - horizontalInset - textContainerInset.right - textContainer.lineFragmentPadding
        )
        let targetSize = placeholderLabel.sizeThatFits(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        placeholderLabel.frame = CGRect(
            x: horizontalInset,
            y: verticalInset,
            width: maxWidth,
            height: targetSize.height
        )
    }

    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !(attributedText?.string.isEmpty ?? true)
    }

    private func enforceMaxLengthIfNeeded() {
        guard maxLength > 0, !isEnforcingMaxLength else { return }
        let currentLength = attributedText?.string.count ?? 0
        guard currentLength > maxLength else { return }

        isEnforcingMaxLength = true
        defer { isEnforcingMaxLength = false }

        let limitedText = limitedAttributedText(maxLength: maxLength)
        let previousSelection = selectedRange.location
        attributedText = limitedText
        selectedRange = NSRange(location: min(previousSelection, limitedText.length), length: 0)
    }

    private func limitedAttributedText(maxLength: Int) -> NSAttributedString {
        let source = attributedText ?? NSAttributedString()
        let string = source.string
        guard string.count > maxLength else { return source }

        let endIndex = string.index(string.startIndex, offsetBy: maxLength)
        let nsRange = NSRange(string.startIndex..<endIndex, in: string)
        return source.attributedSubstring(from: nsRange)
    }

    private func recalculateHeightIfNeeded() {
        guard maxHeight > 0 else { return }
        let measuredHeight = ceil(
            sizeThatFits(CGSize(width: max(bounds.width, 1), height: .greatestFiniteMagnitude)).height
        )
        let floorHeight = max(minHeight, measuredHeight)
        let clampedHeight = min(maxHeight, floorHeight)
        isScrollEnabled = measuredHeight > maxHeight
        calculatedHeight = clampedHeight
        invalidateIntrinsicContentSize()

        if translatesAutoresizingMaskIntoConstraints {
            var currentFrame = frame
            currentFrame.size.height = clampedHeight
            frame = currentFrame
        }

        guard lastReportedHeight != clampedHeight else { return }
        lastReportedHeight = clampedHeight
        onHeightChange?(clampedHeight)
    }

    private func resolveImageSize(
        for image: UIImage,
        preferredSize: CGSize,
        multiple: CGFloat?
    ) -> CGSize {
        if preferredSize != .zero {
            return preferredSize
        }

        if let multiple, multiple > 0 {
            return CGSize(width: image.size.width * multiple, height: image.size.height * multiple)
        }

        let availableWidth = max(
            40,
            bounds.width - textContainerInset.left - textContainerInset.right - textContainer.lineFragmentPadding * 2
        )

        guard image.size.width > 0 else { return image.size }
        let ratio = availableWidth / image.size.width
        return CGSize(width: availableWidth, height: image.size.height * ratio)
    }

    private func insertAttachment(image: UIImage, size: CGSize, index: Int) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(
            x: 0,
            y: (font?.descender ?? -4) / 2,
            width: size.width,
            height: size.height
        )

        let mutableText = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        let safeIndex = min(max(0, index), mutableText.length)
        mutableText.insert(NSAttributedString(attachment: attachment), at: safeIndex)

        attributedText = mutableText
        selectedRange = NSRange(location: safeIndex + 1, length: 0)
        if let font {
            typingAttributes[.font] = font
        }
        insertedImages.append(image)
        recalculateHeightIfNeeded()
    }
}
