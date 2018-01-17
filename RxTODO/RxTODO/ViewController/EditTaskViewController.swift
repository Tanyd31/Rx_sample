//
//  EditTaskViewController.swift
//  RxTODO
//
//  Created by tanyadong on 2018/1/16.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class EditTaskViewController: UIViewController, StoryboardInitializable, BindableType {

    @IBOutlet weak private var okButton: UIBarButtonItem!
    @IBOutlet weak private var cancelButton: UIBarButtonItem!
    @IBOutlet weak private var textView: UITextView!
    
    var viewModel: EditViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func bindViewModel() {
        
        textView.text = viewModel.taskTitle
        
        textView.rx.text.orEmpty
            .map { $0.count > 0 }
            .bind(to: okButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        cancelButton.rx.tap
            .throttle(0.3, scheduler: MainScheduler.instance)
            .bind(to: viewModel.cancel)
            .disposed(by: rx.disposeBag)
        
        okButton.rx.tap
            .throttle(0.3, scheduler: MainScheduler.instance)
            .withLatestFrom(textView.rx.text.orEmpty)
            .bind(to: viewModel.add)
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("🐼")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
