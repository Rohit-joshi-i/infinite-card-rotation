## Infinite Card Rotation
Flutter widget which gives a flip animation to It's child widgets passed to it as the front and back child.


# Installation

1.  Add the latest version of package to your pubspec.yaml (and run `dart pub get`):
 ```sh
  dependencies:
    infinite_card_rotation: ^1.0.2
```
2.  Import the package and use it in your Flutter App.
 ```sh
import 'package:glitcheffect/glitcheffect.dart';
```
## Preview
> **Example:** Horizontal infinite rotation on the card.
>
[![N|Solid](https://github.com/Rohit-joshi-i/infinite-card-rotation/blob/main/assets/gif/example.gif?raw=true)](https://nodesource.com/products/nsolid)

# Example

```sh
FlipCard(  
  onFlipDone: () {  
    print('Rotation Completed');  
  },  
 front: Container(  
    height: 200,  
  width: 200,  
  decoration: BoxDecoration(  
      shape: BoxShape.circle,  
  color: Colors.red,  
  ),  
  child: Icon(Icons.home,size: 50,),  
  ),  
  back: Container(  
    height: 200,  
  width: 200,  
  child: Icon(Icons.call,size: 50,),  
  decoration: BoxDecoration(  
      color: Colors.blue,  
  shape: BoxShape.circle,),  
  ),  
  flipCount: 10,  
  speed: 500,  
)

