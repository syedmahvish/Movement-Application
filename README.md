# Movement-Application
Exercise IOS Application (Swift)

# Description:

Movement Application is a IOS application implemented using IOS framework, MVC design pattern and swift.
This application provide following functionality :
```python
1- Home Screen display all exercise(in tabular form) with informations like exercise image, name and isfavourite or not.
2- It allows user to start exercise.
3- Each exercise display for period of 5 seconds and once reached to last exercise, it navigates to home screen.
4- User can cancel exercise anytime and can navigates to home screen.
```

### Technology used:
###### platform : Xcode, IOS framework(UIKit, UIfoundation) 
###### Design pattern : MVC(Model View Controller)
###### Third part API(provided in assessment) is used to render exercise information : "https://jsonblob.com/api/jsonBlob/d92ee4cd-dff6-11eb-a8ab-05b78a9f1668"
###### Language : Swift


## Installation

Follow commands to install and run the application :

##### Open terminal and navigate to the folder where you want to clone project : 
```bash
git clone {the url to the GitHub repo}
cd [local repository]
```

##### Using terminal and pod 
```bash
pod init 
```
If pod is not install
```bash
pod install
```
Run application

```bash
open MovementApp.xcworkspace/
```

##### Using Xcode directly
```
Right click on MovementApp.xcworkspace and choose open with Xcode.

```


## Usage
```python
Home Screen : Display exercise information and allows user to start exercise
```
<img width="293" alt="Screenshot 2021-07-24 at 10 32 40 PM" src="https://user-images.githubusercontent.com/61482989/126885985-c41ded7b-1041-44fe-9525-17fee346dee5.png">


```python
Detail Exercise Screen : Display Detail information about exercise and allows user to cancel exercise.
Each exercise is display for 5 seconds
```
<img width="618" alt="Screenshot 2021-07-24 at 10 32 54 PM" src="https://user-images.githubusercontent.com/61482989/126886008-e929c729-f6fe-4121-b64e-10a2102f7b9d.png">



