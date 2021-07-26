
import UIKit

class ExerciseTableViewCell: UITableViewCell {
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var isFavouriteButton: UIButton!
    
    var isFavouriteExercise : Bool = false
    private var exerciseId : Int?
    private var storedFavouriteData = UserDefaults.standard
    
    static let identifier = "ExerciseTableViewCell"
    
    private let placeHolderImage = UIImage(named: "placeholder_image")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
  
    @IBAction func isFavouriteButtonTapped(_ sender: UIButton) {
        isFavouriteExercise = !isFavouriteExercise
        
        setFavouriteButtonImage()
       
        if let currentexerciseId = exerciseId {
            storedFavouriteData.set(isFavouriteExercise, forKey: String(currentexerciseId))
        }
    }
}

// MARK: - Cell data configuartion

extension ExerciseTableViewCell {
    
    func configureCell(exerciseData : ExerciseDataModel){
        
        guard let urlString = exerciseData.cover_image_url,
            let name = exerciseData.name,
            let idValue = exerciseData.id
            else {return}
        
        guard let url = URL(string : urlString)
            else {return}
        
        exerciseImageView.image = placeHolderImage
        loadImage(url: url)
        
        setFavouriteButtonImage()
        
        exerciseName.text = name
        exerciseId = idValue
    }
    
}

// MARK: - Favourite Button Image handling

extension ExerciseTableViewCell {
    
    func setFavouriteButtonImage(){
        let imageName = isFavouriteExercise == true ? "favourite_selected_image.png" : "favourite_unselected_image.png"
        isFavouriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
}


// MARK: - Image Cache handling

extension ExerciseTableViewCell {
    
    private func loadImage(url: URL) {
        exerciseImageView?.loadImage(url: url) { [weak self] loadImageResult in
            self?.handle(loadImageResult,
                         requestURL: url,
                         placeHolderImage: self?.placeHolderImage)
        }
    }
    
    private func handle(_ loadImageResult: (Result<FetchImageResponse, ImageLoadingError>),
                        requestURL: URL,
                        placeHolderImage: UIImage?) {
        assert(Thread.isMainThread)
        switch loadImageResult {
        case.success(let imageResponse):
            if imageResponse.requestUrl == requestURL {
                exerciseImageView.image = imageResponse.image
            } else {
                exerciseImageView.image = placeHolderImage
            }
        case .failure: exerciseImageView.image = placeHolderImage
        }
    }
}

