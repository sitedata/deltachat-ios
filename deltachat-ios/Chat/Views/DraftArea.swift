
import UIKit
import DcCore
import InputBarAccessoryView

public class DraftArea: UIView, InputItem {

    public var inputBarAccessoryView: InputBarAccessoryView?
    public var parentStackViewPosition: InputStackView.Position?
    public func textViewDidChangeAction(with textView: InputTextView) {}
    public func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {}
    public func keyboardEditingEndsAction() {}
    public func keyboardEditingBeginsAction() {}

    var delegate: DraftPreviewDelegate? {
        set {
            quotePreview.delegate = newValue
            mediaPreview.delegate = newValue
            documentPreview.delegate = newValue
        }
        get {
            return quotePreview.delegate
        }
    }

    lazy var mainContentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [quotePreview, mediaPreview, documentPreview])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    lazy var quotePreview: QuotePreview = {
        let view = QuotePreview()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var mediaPreview: MediaPreview = {
        let view = MediaPreview()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var documentPreview: DocumentPreview = {
        let view = DocumentPreview()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    convenience init() {
        self.init(frame: .zero)

    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupSubviews() {
        addSubview(mainContentView)
        mainContentView.fillSuperview()
    }

    public func configureDraftArea(draft: DraftModel) {
        quotePreview.configure(draft: draft)
        mediaPreview.configure(draft: draft)
        documentPreview.configure(draft: draft)
    }

    public func cancel() {
        quotePreview.cancel()
        mediaPreview.cancel()
        documentPreview.cancel()
    }

}
