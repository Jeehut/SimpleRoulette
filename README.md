![Images](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/SimpleRoulette.png)

## Demo

![demo](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/demo_0.0.2.gif)
![demo](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/demo_0.0.5.gif)

## Install

### Swift Package Manager
Create `Package.swift` and add dependency like below.
```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", from: "0.1.1")
]
```

## Carthage
Create `Cartfile` and add dependency like below.
```swift
github "fummicc1/SimpleRoulette"
```

## Usage

1. First, create RouletteView instance.

```swift
let rouletteView: RouletteView = .init(frame: .zero)
```

or you can initiate RouletteView with Storyboard.

```swift
@IBOutlet weak var rouletteView: RouletteView!
```

2. Next, insert parts with `RouletteView().configure`.

You can choose parts from [Roulette.AnglePart](https://github.com/fummicc1/SimpleRoulette/blob/master/SimpleRoulette/Source/RoulettePart.swift) or [Roulette.HugePart](https://github.com/fummicc1/SimpleRoulette/blob/master/SimpleRoulette/Source/RoulettePart.swift).

3. Start Roulette by `RouletteView().start`.

You can check if Rotating via `RouletteView().isAnimating`.

4. Stop Roulette by `RouletteView().stop`

5. Detect when stopping roulette using `RouletteViewDelegate`.

- Example

```swift
class IBRouletteViewController: UIViewController {
    
    @IBOutlet var rouletteView: RouletteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rouletteView.delegate = self
        rouletteView.configure(parts: [
            Roulette.HugePart(name: "Title A", huge: .large, delegate: rouletteView, index: 0),
            Roulette.HugePart(name: "Title B", huge: .small, delegate: rouletteView, index: 1),
            Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
            Roulette.HugePart(name: "Title D", huge: .small, delegate: rouletteView, index: 3),
        ])
        
        rouletteView.start()

        // can check if animating
        // if rouletteView.isAnimating { }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.rouletteView.stop()
        }
    }
}

extension IBRouletteViewController: RouletteViewDelegate {
    func rouletteView(_ rouletteView: RouletteView, didStopAt part: RoulettePartType) {
        let alert = UIAlertController(title: "結果", message: part.name, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
```

![example](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/Alert.jpeg)

### Sample Code of updating RouletteView().parts.

#### update with Angle
Create `Roulette.AnglePart`.

**you can choose radian or degree**


```swift
rouletteView.configure(parts: [
    Roulette.AnglePart(name: "Title A", startAngle: .init(degree: 0), endAngle: .init(degree: 90), index: 0),
    Roulette.AnglePart(name: "Title B", startAngle: .init(degree: 90), endAngle: .init(degree: 200), index: 1),
    Roulette.AnglePart(name: "Title C", startAngle: .init(degree: 200), endAngle: .init(degree: 360), index: 2)
])
```

#### update with Huge

Create `Roulette.HugePart`.

```swift
rouletteView.configure(parts: [
    Roulette.HugePart(name: "Title A", huge: .small, delegate: rouletteView, index: 0),
    Roulette.HugePart(name: "Title B", huge: .large, delegate: rouletteView, index: 1),
    Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
])
```

**IMPORTANT: can not combine Huge with Angle in RouletteView().configure.**


## License
[MIT LICENSE](https://github.com/fummicc1/SimpleRoulette/blob/master/LICENSE)
