//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

print("'\(str)'")

[{"__type":"Pointer","className":"Contact","objectId":"kyZ32YaIHe"},{"__type":"Pointer","className":"Contact","objectId":"O4bjQDJ1kv"},{"__type":"Pointer","className":"Contact","objectId":"aAvfHUqO1U"}]

let a = ["vSoHvhI3Vu", "yK9fBa21R5", "r8mUxaKuW8"]
let q = PFQuery(className: "Contact")
q.whereKey("objectId", containedIn: a)
var b = [PFObject]()

q.findObjectsInBackgroundWithBlock{
    (os: [PFObject]?, e: NSError?) in
    for o in os! {
        b.append(o)
    }
    currentUser["contacts"] = b
    currentUser.saveInBackground()
}