//: Playground - noun: a place where people can play

import UIKit

class Car {
    var name: String?
    var bool: Bool?
    
    init(name: String) {
        self.name = name
    }
}

let car1 = Car(name: "Honda")
car1.bool = true
let car2 = Car(name: "Suziki")
car2.bool = false
let car3 = Car(name: "Toyota")
car3.bool = true

var array = [car1, car2, car3]
var array2 = [Car]()

for car in array {
    if car.bool! {
        array2.append(car)
    }
}


