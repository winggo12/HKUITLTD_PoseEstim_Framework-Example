//
//  PoseCollectionViewController.swift
//  tutorial
//
//  Created by iosuser111 on 18/6/2021.
//

import UIKit
import HKUITLTD_PoseEstim_Framework

private let reuseIdentifier = "poseCell"

class PoseCollectionViewController: UICollectionViewController {

    let poses: [Pose] = [Pose.ArdhaUttanasanaLeft, Pose.ArdhaUttanasanaRight, Pose.AdhoMukhaShivanasana, Pose.Balasana, Pose.MarjarasanaBLeft, Pose.MarjarasanaBRight, Pose.MarjarasanaCLeft, Pose.MarjarasanaCRight, Pose.Navasana, Pose.Padangushthasana, Pose.UrdhvaDhanurasana, Pose.UtthitaParsvakonasanaALeft, Pose.UtthitaParsvakonasanaARight, Pose.UtthitaParsvakonasanaBLeft, Pose.UtthitaParsvakonasanaBRight, Pose.Utkatasana, Pose.UrdhvaMukhaSvanasana, Pose.UtthitaTrikonasanaLeft, Pose.UtthitaTrikonasanaRight, Pose.VirabhadrasanaALeft, Pose.VirabhadrasanaARight, Pose.VirabhadrasanaBLeft, Pose.VirabhadrasanaBRight, Pose.VirabhadrasanaCLeft, Pose.VirabhadrasanaCRight, Pose.VirabhadrasanaDLeft, Pose.VirabhadrasanaDRight, Pose.TPose]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return poses.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PoseCollectionViewCell
    
        // Configure the cell
        cell.poseName.text = poses[indexPath.row].rawValue
        
        cell.poseImageView.image = UIImage(named: poses[indexPath.row].rawValue) ?? UIImage(named: "image-placeholder")
        
        cell.poseImageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickedPose"{
            let target = segue.destination as! ViewController
            if let selectedRow = collectionView.indexPathsForSelectedItems{
                
                target.userSelectedPose = poses[selectedRow.first?.row ?? 0]
            }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension PoseCollectionViewController: UICollectionViewDelegateFlowLayout {
  // 1
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
        
    return self.view.frame.size
  }
  
}
