//
//  OpenSourceViewController.swift
//  pohe-ios
//
import UIKit
import RxSwift

final class OpenSourceViewController: UIViewController {
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    private let podsList: [License] = License.map()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var text = ""
        
        podsList.forEach({ entity in
            if let title = entity.title {
                text += title + "\n"
            }
            if let footerText = entity.footerText {
                text += footerText + "\n"
            }
        })
        
        textView.text = text
        cancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
}
