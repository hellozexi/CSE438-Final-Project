//
//  CommentsTableViewCell.swift
//  CSE438 Final Project
//
//  Created by 王梓辰 on 7/29/20.
//  Copyright © 2020 Michael Zhao. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var dislikes: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var theComment:Comment?
    weak var delegate:CommentsTableCellDelegate?
    let ref = Database.database().reference(withPath: "comments")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        username.text = theComment?.username
        content.text = theComment?.content
        likes.text = "\(String(describing: theComment?.likes))"
        dislikes.text = "\(String(describing: theComment?.dislikes))"
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeAction(_ sender: Any) {
        let commentRef = ref.child(theComment!.id)
        let likeRef = commentRef.child("likes")
        likeRef.setValue(theComment!.likes+1)
        likes.text = "\(theComment!.likes+1)"
        delegate?.deleteButtonPressed()
    }
    
    
    @IBAction func dislikeAction(_ sender: Any) {
        let commentRef = ref.child(theComment!.id)
        let dislikeRef = commentRef.child("dislikes")
        dislikeRef.setValue(theComment!.dislikes+1)
        dislikes.text = "\(theComment!.dislikes+1)"
        delegate?.deleteButtonPressed()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let commentRef = ref.child(theComment!.id)
        commentRef.removeValue()
        delegate?.deleteButtonPressed()
    }
}

//The idea of this delegate credits to https://stackoverflow.com/questions/46199727/reload-uitableview-when-button-clicked-in-custom-uitableviewcell
protocol CommentsTableCellDelegate: class {
    func deleteButtonPressed()
}
