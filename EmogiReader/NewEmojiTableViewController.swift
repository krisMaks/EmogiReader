//
//  NewEmojiTableViewController.swift
//  EmogiReader
//
//  Created by Кристина Максимова on 12.01.2022.
//

import UIKit

class NewEmojiTableViewController: UITableViewController {
    
    var emojiDefault = Emoji(emoji: "", name: "", description: "", isFavourite: false)
    
    @IBOutlet weak var emoji: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var descr: UITextField!
    @IBOutlet weak var save: UIBarButtonItem!
    
    @IBAction func textChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let emojiText = emoji.text ?? ""
        let nameText = name.text ?? ""
        let descrText = descr.text ?? ""
        
        save.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descrText.isEmpty
    }
    
    private func updateUI() {
        emoji.text = emojiDefault.emoji
        name.text = emojiDefault.name
        descr.text = emojiDefault.description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
        
        let emojiText = emoji.text ?? ""
        let nameText = name.text ?? ""
        let descrText = descr.text ?? ""
        
        self.emojiDefault = Emoji(emoji: emojiText, name: nameText, description: descrText, isFavourite: self.emojiDefault.isFavourite)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateSaveButtonState()
    }
}
