//
//  PoseSelectTableViewController.swift
//  tutorial
//
//  Created by Cody Ng on 2/6/2021.
//
import HKUITLTD_PoseEstim_Framework
import UIKit




class PoseSelectTableViewController: UITableViewController {
    
    let poses: [Pose] = [Pose.ArdhaUttanasanaLeft, Pose.ArdhaUttanasanaRight, Pose.AdhoMukhaShivanasana, Pose.Balasana, Pose.MarjarasanaBLeft, Pose.MarjarasanaBRight, Pose.MarjarasanaCLeft, Pose.MarjarasanaCRight, Pose.Navasana, Pose.Padangushthasana, Pose.UrdhvaDhanurasana, Pose.UtthitaParsvakonasanaALeft, Pose.UtthitaParsvakonasanaARight, Pose.UtthitaParsvakonasanaBLeft, Pose.UtthitaParsvakonasanaBRight, Pose.Utkatasana, Pose.UrdhvaMukhaSvanasana, Pose.UtthitaTrikonasanaLeft, Pose.UtthitaTrikonasanaRight, Pose.VirabhadrasanaALeft, Pose.VirabhadrasanaARight, Pose.VirabhadrasanaBLeft, Pose.VirabhadrasanaBRight, Pose.VirabhadrasanaCLeft, Pose.VirabhadrasanaCRight, Pose.VirabhadrasanaDLeft, Pose.VirabhadrasanaDRight, Pose.TPose]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return poses.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poseCell", for: indexPath) as! PoseSelectTableViewCell
        
        // Configure the cell...
        cell.poseName.text = poses[indexPath.row].rawValue
        cell.poseImageView.image = UIImage(named: poses[indexPath.row].rawValue) ?? UIImage(named: "image-placeholder")
        cell.poseImageView.frame.size.height=200
        cell.poseImageView.contentMode = .scaleAspectFit
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickedPose"{
            let target = segue.destination as! ViewController
            if let selectedRow = tableView.indexPathForSelectedRow{
                target.userSelectedPose = poses[selectedRow.row]
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
