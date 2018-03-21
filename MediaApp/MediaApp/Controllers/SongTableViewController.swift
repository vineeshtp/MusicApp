//
//  SongTableViewController.swift
//  MediaApp
//
//  Created by Vineesh
//  Copyright © 2018 Media. All rights reserved.
//

import UIKit
import MediaPlayer
import StoreKit

class SongTableViewController: UITableViewController {

    var songList:[MPMediaItem]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.authenticateMusicLibrary()
    }
    
    func authenticateMusicLibrary() {
        if MPMediaLibrary.authorizationStatus() == MPMediaLibraryAuthorizationStatus.authorized {
            getAllsongs()
        }
        else{
            MPMediaLibrary.requestAuthorization({ (status) in
                if status == MPMediaLibraryAuthorizationStatus.authorized{
                    DispatchQueue.main.async {
                        self.getAllsongs()
                    }
                }
            })        }
    }
    
    func getAllsongs() {
        MediaHandler.instance.fetchAllSongs { (songs) in
            self.songList = songs
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (songList?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SongListTableViewCell

        let song:MPMediaItem = songList![indexPath.row]
        cell.loadSongs(param: song)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song:MPMediaItem = songList![indexPath.row]
        
        MediaHandler.instance.musicPlayerManager.musicPlayerController.setQueue(with: MPMediaQuery.songs())
        MediaHandler.instance.musicPlayerManager.musicPlayerController.nowPlayingItem = song
        MediaHandler.instance.musicPlayerManager.musicPlayerController.play()
        
//        MediaHandler.instance.musicPlayerManager.beginPlayback(itemCollection: song)
        
       let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.currentPlayingItem = song
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
        
       // MediaHandler.instance.musicPlayerManager.pl
        //beginPlayback
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
