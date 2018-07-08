//
//  SentMemesTableViewController.swift
//  MemeMe 1.0
//
//  Created by David Rodrigues on 06/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    

    
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func showMemeEditor(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         
         */
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableViewCell", for: indexPath)
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.top
        cell.imageView?.image = meme.meme

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detailController, animated: true)
    }

}
