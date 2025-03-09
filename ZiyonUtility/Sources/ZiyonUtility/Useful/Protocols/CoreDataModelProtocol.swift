//
//  CoreDataModelProtocol.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 10/07/23.
//

import CoreData
/// Protocol for models that interact with Core Data.
///
/// This protocol provides a standard  way to convert between Core Data entities
/// and Swift models. It requires conforming types to be Equatable and Identifiable.
///
/// - Parameters:
///   - id: The unique identifier of the model.
///   - objectID: The object ID used for referencing the Core Data object.
///   - generateEntity: method to Generate a Core Data entity from the model.
///
/// - Returns: Core data entity using a defined model
///
/// - Usage Exemple:
/// ``` swift
/// import SwiftUI
///import CoreData
///
///struct MyView: View {
///    @Environment(\.managedObjectContext) private var viewContext
///
///    @FetchRequest(
///        sortDescriptors: [NSSortDescriptor(keyPath: \MyItemEntity.title, ascending: true)],
///        animation: .default)
///    private var items: FetchedResults<BudgetItemEntity>
///
///    var body: some View {
///        List {
///            ForEach(items) { item in
///                // Create a MyItemModel from the Core Data entity
///                let budgetItem = MyItemModel(from: item)
///
///                // Use the budgetItem in your SwiftUI view
///                Text(budgetItem.title)
///            }
///        }
///    }
/// }
///```
public protocol CoreDataModelProtocol: Equatable, Identifiable {
    
    associatedtype EntityType: NSManagedObject
    /// The unique identifier of the model.
    var id: UUID { get set }
    ///  The object ID used for referencing the Core Data object.
    var objectID: NSManagedObjectID? { get set }
    
    init(from entity: EntityType)
    /// method to Generate a Core Data entity from the model.
    mutating func generateEntity(context: NSManagedObjectContext) -> EntityType
}

extension CoreDataModelProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
