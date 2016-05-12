import Foundation

class RHLifoOperationQueue: NSOperationQueue {
    
    /**
     Method override default implementation of 'addOperations' and scheduled operations in LIFO order (Last In First Out)
     
     - parameter operations: The array of NSOperation objects that you want to add to the receiver.
     - parameter waitUntilFinished: If true, the current thread is blocked until all of the specified operations finish executing. If false, the operations are added to the queue and control returns immediately to the caller.
     */
    override func addOperations(operations: [NSOperation], waitUntilFinished: Bool = false) {
        // Add new dependency according to already enqueued operation
        if let lastOperationInNewSet = operations.last, firstOperationInQueue = self.operations.first {
            lastOperationInNewSet.addDependency(firstOperationInQueue)
        }
        
        for indx in 0  ..< operations.count  {
            let tempOperation = operations[indx]
            
            let nextIndx = indx + 1
            if nextIndx < operations.count {
                let nextOperation = operations[nextIndx]
                tempOperation.addDependency(nextOperation)
            }
        }
        
        super.addOperations(operations, waitUntilFinished: waitUntilFinished)
    }
}



                                                    // Example usage //
let lifoQueue = RHLifoOperationQueue()

let blockOperation1 = NSBlockOperation {
    print("🐠 blockOperation1")
}

let blockOperation2 = NSBlockOperation {
    print("🐟 blockOperation2")
}

let blockOperation3 = NSBlockOperation {
    print("🐳 blockOperation3")
}

lifoQueue.addOperations([blockOperation1, blockOperation2, blockOperation3])
