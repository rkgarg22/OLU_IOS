//
//  ViewController.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 17/06/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController ,UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{

    @IBOutlet var pageCtrl: UIPageControl!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageCntrl: UIPageControl!
    @IBOutlet var skipBtn: UIButton!
    var tutorialArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialArray = [#imageLiteral(resourceName: "tutorialFirstScreen"),#imageLiteral(resourceName: "tutorialSecond"),#imageLiteral(resourceName: "tutorialFour") ,#imageLiteral(resourceName: "tutorialfive"),#imageLiteral(resourceName: "tutorial6")]
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action
    @IBAction func skipButton(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "HomeVc") as! HomeVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    //MARK: - collection View delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutorialCollectionViewCell
        cell.tutorialImage.image = tutorialArray[indexPath.row] as? UIImage
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) -> () {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width);
        pageCntrl.currentPage = Int(pageNumber)
        
        if pageCtrl.currentPage == tutorialArray.count-1 {
        //skipBtn.setTitle("DONE", for: .normal)
        }
    }
}
