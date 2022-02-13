//
//  EmojiTableTableViewController.swift
//  EmogiReader
//
//  Created by Кристина Максимова on 11.01.2022.
//

import UIKit

class EmojiTableTableViewController: UITableViewController {
    var objects = [Emoji(emoji: "☀️", name: "Sun", description: "It's sun!", isFavourite: false),
                   Emoji(emoji: "🌙", name: "Moon", description: "It's moon!", isFavourite: false),
                   Emoji(emoji: "🌈", name: "Rainbow", description: "It's rainbow!", isFavourite: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.title = "Emogi Reader"
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! NewEmojiTableViewController
        let emoji = sourceVC.emojiDefault
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            objects[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            let indexPath = IndexPath(row: objects.count, section: 0)
            objects.append(emoji)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmoji" else { return }
         
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = objects[indexPath.row]
        
        let navigationVC = segue.destination as! UINavigationController
        let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
        newEmojiVC.emojiDefault = emoji
        newEmojiVC.title = "Edit"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
        let object = self.objects[indexPath.row]
        cell.set(object: object)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        objects.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .middle)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let emojiMoved = objects.remove(at: sourceIndexPath.row)
        objects.insert(emojiMoved, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done, favourite])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") {
            (action, view, completion) in
            self.objects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        action.backgroundColor = .systemMint
        action.image = UIImage(systemName: "checkmark")
        return action
    }
    
    func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = self.objects[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Favourite") { action, view, competion in
            object.isFavourite = !object.isFavourite
            self.objects[indexPath.row] = object
            competion(true)
        }
        action.backgroundColor = object.isFavourite ? .systemPink : .systemGray
        action.image = UIImage(systemName: "suit.heart")
        return action
    }
}
