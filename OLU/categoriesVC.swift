//
//  categoriesVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 27/03/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class categoriesVC: UIViewController ,UITableViewDataSource ,UITableViewDelegate,iCarouselDelegate ,iCarouselDataSource{
    
    @IBOutlet var carouselView: iCarousel!
    @IBOutlet var reserveBtn: UIButton!
    @IBOutlet var plusBtn: UIButton!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet var categoryTable: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    
    var menuDict = NSDictionary()
    var images = NSArray()
    var higlightedImages = NSArray()
    var currentSelectedCrouselIndex = -1
    var isOpenFirstCat = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        currentSelectedCrouselIndex = -1
        // Dispose of any resources that can be recreated.
    }
    
    //StartFunc
    func startFunc(){
        categoryTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        categoryTable.tableFooterView = UIView()
        categoryTable.estimatedRowHeight = 80
        categoryTable.rowHeight = UITableViewAutomaticDimension
        
        carouselView.type = .rotary
        images = [#imageLiteral(resourceName: "boxingIcon"),#imageLiteral(resourceName: "watchIcon"),#imageLiteral(resourceName: "timerIcon"),#imageLiteral(resourceName: "roleIcon"),#imageLiteral(resourceName: "heartIcon"),#imageLiteral(resourceName: "shoesIcon"),#imageLiteral(resourceName: "Gimnasia"),#imageLiteral(resourceName: "theraphyIcon"),#imageLiteral(resourceName: "masajes")]
        carouselView.reloadData()
        menuDict = ["imageArray":[#imageLiteral(resourceName: "boxingIcon"),#imageLiteral(resourceName: "watchIcon"),#imageLiteral(resourceName: "timerIcon"),#imageLiteral(resourceName: "roleIcon"),#imageLiteral(resourceName: "heartIcon"),#imageLiteral(resourceName: "shoesIcon"),#imageLiteral(resourceName: "Gimnasia"),#imageLiteral(resourceName: "theraphyIcon"),#imageLiteral(resourceName: "masajes")],"nameArray":["Kickboxing","Entrenamiento Funcional" ,"Stretching" ,"Yoga" ,"Pilates" ,"Dance Fit" ,"Gimnasia Adulto Mayor","Fisioterapia","Masajes Deportivos"] ,"descriptionArray":[kickBoxingDescription,cardioCrossfitDescription,strectingDescription,yogaDescription,pilatesDescription,danzaFitDescription,gimnasiaAdultoMayor,fisioterapiaDescription ,masajesDeportivos ]]
        categoryTable.reloadData()
        categoryTable.layoutIfNeeded()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == categoryTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    tableHeight.constant = newSize.height
                }
            }
        }
    }
    
    
    @objc func plusButton(sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            currentSelectedCrouselIndex = -1
            categoryTable.reloadData()
        }else{
            sender.isSelected = true
            currentSelectedCrouselIndex = sender.tag
            carouselView.reloadData()
            carouselView.scrollToItem(at: sender.tag, animated: true)
        }
    }
    
    @objc func selectDate(sender:UIButton) {
        var catId = Int()
        let indexValue = sender.tag
        switch indexValue {
        case 0:
            catId = 1
        case 1 :
            catId = 2
        case 2:
            catId = 3
        case 3:
            catId = 4
        case 4:
            catId = 5
        case 5 :
            catId = 11
        case 6 :
            catId = 10
        case 7:
            catId = 9
        case 8 :
            catId = 8
        case 9 :
            catId = 12
        default:
            print("Default Case")
        }
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SelectCalendarVc") as! SelectCalendarVC
        myVC.catId = catId
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    //MARK:- UIButton
    //menu password
    @IBAction func menuBtn(_ sender: UIButtonCustomClass){
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }    }
    
    //back password
    @IBAction func backBtn(_ sender: UIButtonCustomClass){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func carouselLeftBtn(_ sender: Any){
        currentSelectedCrouselIndex -= 1
        scrollCarousel()
    }
    
    @IBAction func carouselRightBtn(_ sender: Any){
        currentSelectedCrouselIndex += 1
        scrollCarousel()
    }
    
    func scrollCarousel() {
        carouselView.reloadData()
        carouselView.scrollToItem(at: currentSelectedCrouselIndex, animated: true)
        let indexPath = IndexPath(row: currentSelectedCrouselIndex, section: 0)
        if let cell = categoryTable.cellForRow(at: indexPath)  as? CategoryTableViewCell {
            cell.plusBtn.isSelected = !cell.plusBtn.isSelected
            categoryTable.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        let imageArr = menuDict.value(forKey: "imageArray") as! NSArray
        let titleArr =  menuDict.value(forKey: "nameArray") as! NSArray
        let descriptionArr =  menuDict.value(forKey: "descriptionArray") as! NSArray
        cell.iconImage.image = imageArr[indexPath.row] as?UIImage
        cell.nameLabel.text = titleArr[indexPath.row] as? String
        cell.reserveBtn.addTarget(self, action: #selector(selectDate), for: .touchUpInside)
        cell.reserveBtn.tag = indexPath.row
        cell.plusBtn.tag = indexPath.row
        cell.plusBtn.addTarget(self, action: #selector(plusButton(sender:))
            , for: .touchUpInside)
        
        if(indexPath.row == currentSelectedCrouselIndex){
            cell.plusBtn.isSelected = true
        }else{
            cell.plusBtn.isSelected = false
        }
        if  cell.plusBtn.isSelected {
            let heightCalculate = 200 + (indexPath.row * 50);
            scrollView.setContentOffset(CGPoint(x: 0, y: heightCalculate), animated: true)
            cell.descriptionLabel.text = descriptionArr[indexPath.row] as? String
        }
        else{
            cell.descriptionLabel.text = ""
        }
        categoryTable.layoutIfNeeded()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    
    //MARK: - carousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return images.count
    }
    
    func carousel(_ _carousel: iCarousel, viewForItemAt index: Int,reusing view: UIView?) -> UIView {
        
        // create view
        let temView = UIView(frame:CGRect(x: 0, y: 0, width: 180, height: 180))
        let frame = CGRect(x: 45, y: 45, width: 90, height: 90)
        temView.backgroundColor = UIColor(red: 216/255.0, green: 224/255.0, blue: 228/255.0, alpha: 1)
        temView.layer.cornerRadius = temView.frame.height/2
        temView.layer.borderColor = UIColor.white.cgColor
        temView.layer.borderWidth = 15
        temView.clipsToBounds = true
        // uiimageView
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.image = images[index] as? UIImage
        imageView.image = imageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        temView.addSubview(imageView)
        if (index == currentSelectedCrouselIndex) {
            temView.backgroundColor = UIColor(red: 0/255.0, green: 151/255.0, blue: 167/255.0, alpha: 1)
            imageView.tintColor = UIColor.white
            categoryTable.reloadData()
        }else{
            imageView.tintColor = UIColor.gray
        }
        return temView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let indexPath = IndexPath(item :index, section: 0)
        let cell = categoryTable.cellForRow(at: indexPath) as! CategoryTableViewCell
        cell.plusBtn.isSelected = true
          //self.currentSelectedCrouselIndex = index
        categoryTable.reloadRows(at: [indexPath], with: .automatic)
        categoryTable.layoutIfNeeded()
      
        DispatchQueue.main.async {
            let indexPathValue = IndexPath(row: carousel.currentItemIndex, section: 0)
            self.categoryTable.scrollToRow(at: indexPathValue, at: .top, animated: true)
        }
        
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        if(currentSelectedCrouselIndex != carousel.currentItemIndex){
            if(isOpenFirstCat){
                currentSelectedCrouselIndex = carousel.currentItemIndex
                carousel.reloadData()
            }else{
                isOpenFirstCat = true
            }
        }
    }
    
}
