// Copyright (c) 2023 Kodeco Inc.
// For full license & permission details, see LICENSE.markdown.

import Foundation
import PlaygroundSupport
//: # Make a Class Threadsafe
//: ## The Problem: Race Condition
//: When you're using asynchronous calls then you need to consider thread safety.
//: Consider the following object:
let nameChangingPerson = Person(firstName: "Alison", lastName: "Anderson")
//: The `Person` class includes a method to change names:
//nameChangingPerson.changeName(firstName: "Brian", lastName: "Biggles")
//nameChangingPerson.name
//: What happens if you use the `changeName(firstName:lastName:)` simulataneously from a concurrent queue?
let workerQueue = DispatchQueue(label: "com.kodeco.worker", attributes: .concurrent)
//let nameChangeGroup = DispatchGroup()

let nameList = [("Charlie", "Cheesecake"), ("Delia", "Dingle"), ("Eva", "Evershed"), ("Freddie", "Frost"), ("Gina", "Gregory")]

// Comment out the code below before you implement ThreadSafePerson
//for (idx, name) in nameList.enumerated() {
//  workerQueue.async(group: nameChangeGroup) {
//    usleep(UInt32(10_000 * idx))
//    nameChangingPerson.changeName(firstName: name.0, lastName: name.1)
//    print("Current Name: \(nameChangingPerson.name)")
//  }
//}
//
//nameChangeGroup.notify(queue: DispatchQueue.global()) {
//  print("Final name: \(nameChangingPerson.name)")
//  PlaygroundPage.current.finishExecution()
//}
//
//nameChangeGroup.wait()
//: __Result:__ `nameChangingPerson` has been left in an inconsistent state.
//:
//: ## The Solution: Dispatch Barrier for Thread Safety
//: A barrier allows you add a task to a concurrent queue that will be run in a serial fashion, i.e., it will wait for the currently queued tasks to complete, and prevent any new ones starting.
class ThreadSafePerson: Person {
  // TODO: Write this implementation
	let isolattionQueue = DispatchQueue(label: "com.kodeco.person.isolation", attributes: .concurrent)
	
	override var name: String {
		isolattionQueue.sync {
			super.name
		}
	}
	
	override func changeName(firstName: String, lastName: String) {
		isolattionQueue.async(flags: .barrier) {
			// barrier task
			super.changeName(firstName: firstName, lastName: lastName)
		}
	}
  
}

print("\n=== Threadsafe ===")

let threadSafeNameGroup = DispatchGroup()

let threadSafePerson = ThreadSafePerson(firstName: "Anna", lastName: "Adams")

for (idx, name) in nameList.enumerated() {
  workerQueue.async(group: threadSafeNameGroup) {
    usleep(UInt32(10_000 * idx))
    threadSafePerson.changeName(firstName: name.0, lastName: name.1)
    print("Current threadsafe name: \(threadSafePerson.name)")
  }
}

threadSafeNameGroup.notify(queue: DispatchQueue.global()) {
  print("Final threadsafe name: \(threadSafePerson.name)")
  PlaygroundPage.current.finishExecution()
}
//: ## Xcode's Thread Sanitizer
//: Now run the __NameChanger project__, to see Xcode's thread sanitizer find the race condition errors.
