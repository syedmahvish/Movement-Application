import UIKit

class ExerciseDetailViewController: UIViewController {

    @IBOutlet weak var isFavouiriteButton: UIButton!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var exerciseDetailData : [ExerciseDataModel]?
    private var pageNumber = 0
    private var storedFavouriteData = UserDefaults.standard
    
    private var currentExercise : ExerciseDataModel?
    private var currentPageNumber = 0
    
    private let placeHolderImage = UIImage(named: "placeholder_image")
    
    var delegate : ExerciseDetailViewControllerDelegate?
    
    private var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        handleOrientation()
    }
    
    private func initialSetup(){
        
        isFavouiriteButton.setButtonBorder(ofWidth : 2, color: UIColor.black)
        cancelButton.setButtonBorder(ofWidth : 2, color: UIColor.black)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    init(exerciseDetailData : [ExerciseDataModel]) {
        self.exerciseDetailData = exerciseDetailData
        super.init(nibName: nil, bundle: .main)
        pageNumber = 0
        currentPageNumber = 0
        startTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func cancelTrainingButtonTap(_ sender: UIButton) {
        stopTimerTest()
        delegate?.dismissExerciseDetailVC()
    }
    
   
    @IBAction func markFavouriteButtonTap(_ sender: UIButton) {
        guard let idValue = currentExercise?.id
        else { return }
       
        var isFavourite = storedFavouriteData.bool(forKey: String(idValue))
        isFavourite = !isFavourite
        
        isFavouiriteButton.setButtonTitle(forText: isFavourite == true ?  " Favourite exercise " : " Not Favorite exercise ")
        
        storedFavouriteData.set(isFavourite, forKey: String(idValue))
    }
  
}

// MARK: - View Updation handling

extension ExerciseDetailViewController {
    
    @objc func setupUI(){
        if pageNumber == exerciseDetailData?.count{
            stopTimerTest()
            delegate?.dismissExerciseDetailVC()
            return
        }
        
        updateCurrentExercise()
        
        guard let urlString = currentExercise?.cover_image_url,
            let idValue = currentExercise?.id
            else {return}
        
        guard let url = URL(string : urlString)
            else {return}
        
        exerciseImageView.image = placeHolderImage
        loadImage(url: url)
        
        let isFavourite = storedFavouriteData.bool(forKey: String(idValue))
        isFavouiriteButton.setButtonTitle(forText: isFavourite == true ?  " Favourite exercise " : " Not Favorite exercise ")
        
        updatePageNumber()
    }
    
    func updateCurrentExercise(){
        guard let exercise = exerciseDetailData?[currentPageNumber]
            else { return }
        currentExercise = exercise
    }
    
    func updatePageNumber(){
        pageNumber += 1
        currentPageNumber = pageNumber
    }
    
    
}

// MARK: - Timer handling

extension ExerciseDetailViewController {
    
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:#selector(setupUI), userInfo: nil, repeats: true)
    }
    
    private func stopTimerTest() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Image Cache handling

extension ExerciseDetailViewController {
    
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


// MARK: - Orientation handling

extension ExerciseDetailViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func handleOrientation(){
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @objc func appMovedToForeground() {
       handleOrientation()
    }
    
}


/// ExerciseDetail Delegate for handling dismiss view controller

protocol ExerciseDetailViewControllerDelegate  : class {
    func dismissExerciseDetailVC()
}
