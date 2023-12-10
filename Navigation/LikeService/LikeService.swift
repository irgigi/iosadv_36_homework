//
//  LikeService.swift
//  Navigation


import CoreData

protocol ILikeService {
    var backgroundContext: NSManagedObjectContext { get }
}

final class LikeService: ILikeService {
    
    private let coreDataService: ICoreDataService = CoreDataService.shared
    
    var backgroundContext: NSManagedObjectContext {
        return coreDataService.backgroundContext
    }
    
    
    func newSaveObject(author: String, text: String, image: String, likes: String, views: String) {
        coreDataService.backgroundContext.perform { [weak self] in
            guard let self else { return }
            let dbModel = DataBaseModel(context: coreDataService.backgroundContext)
            dbModel.author = author
            dbModel.text = text
            dbModel.image = image
            dbModel.likes = likes
            dbModel.views = views
            
            if coreDataService.backgroundContext.hasChanges {
                
                do {
                    try coreDataService.backgroundContext.save()
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
        }
        
    }
    
    
    func newDeliteObject(_ dbModel: DataBaseModel) {
        coreDataService.backgroundContext.perform { [weak self] in
            guard let self else { return }
            coreDataService.backgroundContext.delete(dbModel)
            
            if coreDataService.backgroundContext.hasChanges {
                
                do {
                    try coreDataService.backgroundContext.save()
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
}
