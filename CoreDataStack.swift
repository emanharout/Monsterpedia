


import CoreData

// MARK:  - Main
class CoreDataStack {
	
	let container: NSPersistentContainer
	let context : NSManagedObjectContext
	static let sharedInstance = CoreDataStack(modelName: "Model")!
	
	fileprivate init?(modelName: String) {
		
		container = NSPersistentContainer(name: modelName)
		context = container.viewContext
		
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error {
				print("Error initializing core data stack: \(error), Error Description: \(error.localizedDescription)")
			}
		}
	}
	
}

extension CoreDataStack {
	
	func save() {
		context.performAndWait {
			if self.context.hasChanges {
				do {
					try self.context.save()
				} catch{
					fatalError("Error while saving main context: \(error), description: \(error.localizedDescription)")
				}
			}
		}
	}
	
}

