import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var startExerciseButton: UIButton!
  
    private var storedfavouriteExerciseData = UserDefaults.standard
    private var exerciseData = [ExerciseDataModel]()
    private var exerciseService = ExerciseService()
    private var exerciseDetailVC : ExerciseDetailViewController?
  
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestData()
        handleOrientation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleOrientation()
    }
    

    private func  setupUI(){
        table.register(ExerciseTableViewCell.nib(), forCellReuseIdentifier: ExerciseTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
    }
    

    @IBAction func startExerciseButtonTapped(_ sender: UIButton) {
        exerciseDetailVC = ExerciseDetailViewController(exerciseDetailData: exerciseData)
        exerciseDetailVC?.delegate = self
        self.present(exerciseDetailVC!, animated: true, completion: nil)
    }
    
}

// MARK: - Service handling : Remote API
extension ViewController {
    
    private func requestData() {
        exerciseService.requestDataforExercise { (data) in
            guard let dataArray = data
                else {return}
            
            self.exerciseData = dataArray
            
            for exercise in self.exerciseData {
                var isFavourite = false
                if let id = exercise.id,
                    self.storedfavouriteExerciseData.bool(forKey: String(id)){
                    isFavourite = self.storedfavouriteExerciseData.bool(forKey: String(id))
                    self.storedfavouriteExerciseData.set(isFavourite, forKey: String(id))
                }
            }
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }
    }
    
}


// MARK: - Orientation
extension ViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func handleOrientation(){
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}


// MARK: - TableViewController Datasource and Delegate

extension ViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as! ExerciseTableViewCell
        
        let currentRowData : ExerciseDataModel = exerciseData[indexPath.row]
        
        cell.isFavouriteExercise = false

        if let id = currentRowData.id,
            storedfavouriteExerciseData.bool(forKey: String(id)){
            cell.isFavouriteExercise = true
        }
        
        cell.configureCell(exerciseData: currentRowData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


// MARK: - ExerciseDetailViewControllerDelegate

extension ViewController : ExerciseDetailViewControllerDelegate{
    func dismissExerciseDetailVC(){
        dismiss(animated: true, completion: {
            self.table.reloadData()
        })
    }
}





