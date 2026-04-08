import UIKit
import XCTest
@testable import WZBTextView_demo

final class WZBTextViewTests: XCTestCase {
    func testPlaceholderLabelVisibilityTracksContent() throws {
        let textView = WZBTextView(frame: CGRect(x: 0, y: 0, width: 240, height: 44))
        textView.placeholder = "placeholder"
        textView.layoutIfNeeded()

        let placeholderLabel = try XCTUnwrap(textView.subviews.compactMap { $0 as? UILabel }.first)
        XCTAssertFalse(placeholderLabel.isHidden)

        textView.text = "hello"
        XCTAssertTrue(placeholderLabel.isHidden)

        textView.text = ""
        XCTAssertFalse(placeholderLabel.isHidden)
    }

    func testPlaceholderStaysHiddenWhenTextIsPreset() throws {
        let textView = WZBTextView(frame: CGRect(x: 0, y: 0, width: 240, height: 44))
        textView.placeholder = "placeholder"
        textView.text = "prefilled"
        textView.layoutIfNeeded()

        let placeholderLabel = try XCTUnwrap(textView.subviews.compactMap { $0 as? UILabel }.first)
        XCTAssertTrue(placeholderLabel.isHidden)
    }

    func testTextViewCanDeallocateAfterUse() {
        weak var weakTextView: WZBTextView?

        autoreleasepool {
            let textView = WZBTextView(frame: CGRect(x: 0, y: 0, width: 240, height: 44))
            textView.placeholder = "placeholder"
            textView.text = "content"
            weakTextView = textView
        }

        XCTAssertNil(weakTextView)
    }

    func testAddImageStoresImageAndAttachment() {
        let textView = WZBTextView(frame: CGRect(x: 0, y: 0, width: 240, height: 44))
        let image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 12)).image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 24, height: 12))
        }

        textView.addImage(image)

        XCTAssertEqual(textView.images().count, 1)
        XCTAssertEqual(textView.attributedText.length, 1)
        XCTAssertTrue(textView.attributedText.attribute(.attachment, at: 0, effectiveRange: nil) is NSTextAttachment)
    }

    func testAutoHeightReportsClampedHeight() {
        let textView = WZBTextView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        textView.font = .systemFont(ofSize: 17)
        textView.minHeight = 44

        var reportedHeights: [CGFloat] = []
        textView.autoHeight(maxHeight: 80) { height in
            reportedHeights.append(height)
        }
        textView.text = Array(repeating: "Swift rewrite", count: 30).joined(separator: " ")

        XCTAssertFalse(reportedHeights.isEmpty)
        XCTAssertGreaterThanOrEqual(reportedHeights.last ?? 0, 44)
        XCTAssertLessThanOrEqual(reportedHeights.last ?? .greatestFiniteMagnitude, 80)
    }

    func testMaxLengthTrimsPlainText() {
        let textView = WZBTextView(frame: CGRect(x: 0, y: 0, width: 240, height: 44))
        textView.maxLength = 5

        textView.text = "123456789"
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: textView)

        XCTAssertEqual(textView.text, "12345")
    }

    func testMaxLengthTrimsAttributedText() {
        let textView = WZBTextView(frame: CGRect(x: 0, y: 0, width: 240, height: 44))
        textView.maxLength = 4
        let attributed = NSAttributedString(
            string: "abcdef",
            attributes: [.foregroundColor: UIColor.systemRed]
        )

        textView.attributedText = attributed
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: textView)

        XCTAssertEqual(textView.attributedText.string, "abcd")
        let color = textView.attributedText.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        XCTAssertEqual(color, .systemRed)
    }
}
