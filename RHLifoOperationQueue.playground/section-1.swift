import Foundation

class RHLifoOperations {
    
    let operationQueue = NSOperationQueue()
    
    init() {
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    /**
     Method scheduled operations in LIFO order (Last In First Out)
     
     - parameter operations: The array of NSOperation objects that you want to add to the receiver.
     - parameter waitUntilFinished: If true, the current thread is blocked until all of the specified operations finish executing. If false, the operations are added to the queue and control returns immediately to the caller.
     */
    func addOperations(operations: [NSOperation], waitUntilFinished: Bool = false) {
        // Add dependency according to last enqueued operation
        if let firstOperationInNewSet = operations.first {
            operationQueue.operations.last?.addDependency(firstOperationInNewSet)
        }
        
        for indx in 0  ..< operations.count  {
            let tempOperation = operations[indx]
            
            let nextIndx = indx + 1
            if nextIndx < operations.count {
                let nextOperation = operations[nextIndx]
                tempOperation.addDependency(nextOperation)
            }
        }
        
        operationQueue.addOperations(operations, waitUntilFinished: waitUntilFinished)
    }
}



                                                    // Example usage //
let lifoQueue = RHLifoOperations()

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
