// Copyright (c) 2023 Kodeco Inc.
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
//: # DispatchGroup Waiting
//: You can make the current thread wait for a dispatch group to complete.
//:
//: __DANGER__ This is a synchronous call on the __current__ queue, so will block it. You cannot have anything in the group that needs to use the current queue, otherwise you'll deadlock.
let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInitiated)

queue.async(group: group) {
  print("Start task 1")
  // TODO: Sleep for 4 seconds
	sleep(4)
  print("End task 1")
}

queue.async(group: group) {
  print("Start task 2")
  // TODO: Sleep for 1 second
	sleep(1)
  print("End task 2")
}

group.notify(queue: DispatchQueue.global()) {
  // TODO: Announce completion, stop playground page
	print("All tasks completed at last!")
	sleep(1)
	PlaygroundPage.current.finishExecution()
}
//: The tasks continue to run, even if the wait times out.
// TODO: Wait for 5 seconds, then for 3 seconds
if group.wait(timeout: .now() + 3) == .timedOut {
	print("I got tired of waiting.")
} else {
	print("All the tasks have completed.")
}





