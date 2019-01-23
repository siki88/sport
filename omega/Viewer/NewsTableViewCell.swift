//
//  NewsTableViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 23.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNewsLabel: UILabel!
    @IBOutlet weak var dateNewsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        self.movieImage.image.sd_cancelCurrentImageLoad()
    //    self.imageNews.image = nil
    }

}
