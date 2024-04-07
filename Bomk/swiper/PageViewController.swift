//
//  PageViewController.swift
//  Bomk
//
//  Created by Yaroslav on 3/17/24.
//

import UIKit

class PageViewController: UIPageViewController{
    var items: [UIViewController] = []
    var currentIndex = 0

    var parentController: InfoScreen? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        populateItems()
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        removeSwipeGesture()
    }
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    
    func next(){
        let nextIndex = presentationIndex(for: self) + 1
        guard items.count > nextIndex else {
            return
        }
        setViewControllers([items[nextIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func populateItems() {
        for index in 0..<1 {
            if let myVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstItem") as? FirstPage{
                myVC.view.tag = 0
                items.append(myVC)
            }
            if let myVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondView") as? SecondViewController{
                myVC.view.tag = 0
                items.append(myVC)
            }
            if let myVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondView") as? SecondViewController{
                myVC.view.tag = 0
                items.append(myVC)
            }
        }
    }

}

extension PageViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let tag = pageViewController.viewControllers!.first!.view.tag
        currentIndex = tag
    }
}

extension PageViewController: UIPageViewControllerDataSource {
func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = items.firstIndex(of: viewController) else {
        return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    return (previousIndex == -1) ? nil : items[previousIndex]
}

func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = items.firstIndex(of: viewController) else {
        return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    return (nextIndex == items.count) ? nil : items[nextIndex]
}

func presentationCount(for _: UIPageViewController) -> Int {
    return 0
}

func presentationIndex(for _: UIPageViewController) -> Int {
    guard let firstViewController = viewControllers?.first,
          let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
        return 0
    }
    currentIndex = firstViewControllerIndex
    return firstViewControllerIndex
}
}
