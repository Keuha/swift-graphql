import Foundation

/*
 SwiftGraphQL uses Selection structure to collect data about the
 fields a query should fetch. To do that, it passes around a SelectionSet
 class reference. Generated code later calls `select` method on SelectionSet
 to add a subfield to the selection.
 
 SelectionSet also holds information about the response that the generated
 code uses to populate user-defined models.
 
 Generated code extends Select structure using Phantom types. SelectionSet,
 on the other hand, is final as you can see in the declaration.
 */

public final class SelectionSet<Type, TypeLock> {
    
    // Internal representation of selection.
    private(set) var fields = [GraphQLField]()
    // Internal representation of the response.
    private var _response: Response = .fetching
    
    // MARK: - Initializers
    
    init() {}
    
    init(data: TypeLock) {
        /* This initializer is used to decode response into Swift data. */
        self._response = .fetched(data)
    }
    
    // MARK: - Accessors
    
    /// Publically accessible response data.
    ///
    /// - Note: This function should only be used by the generated code.
    public var response: Response {
        _response
    }
    
    // MARK: - Methods
    
    /// Lets generated code add a selection to the selection set.
    ///
    /// - Note: This function should only be used by the generated code.
    public func select(_ field: GraphQLField) {
        self.fields.append(field)
    }
    
    /// Lets generated code add a selection to the selection set.
    ///
    /// - Note: This function should only be used by the generated code.
    public func select(_ fields: [GraphQLField]) {
        self.fields.append(contentsOf: fields)
    }
    
    // MARK: - Response
    
    /*
     Represents a response of the request.
     */
    public enum Response {
        case fetching
        case fetched(TypeLock)
    }
}

// MARK: - SelectionSet decoder

extension SelectionSet: Decodable where TypeLock: Decodable {
    public convenience init(from decoder: Decoder) throws {
        let data = try TypeLock(from: decoder)
        self.init(data: data)
    }
}

// MARK: - Selection

/// Global type used to wrap the selection.
public struct Selection<Type, TypeLock> {
    public typealias SelectionDecoder = (SelectionSet<Type, TypeLock>) -> Type
    
    /* Data */

    private let selectionSet = SelectionSet<Type, TypeLock>()
    private var decoder: SelectionDecoder // function used to decode data and populate selection
    private var mocked: Type // mock data
    
    
    // MARK: - Initializer
    
    public init(decoder: @escaping SelectionDecoder) {
        /* This initializer populates fields (selection set) and grabs a copy of mocked value. */
        self.decoder = decoder
        self.mocked = decoder(selectionSet)
    }
    
    // MARK: - Accessors
    
    /// Returns a list of selected fields.
    public var selection: [GraphQLField] {
        self.selectionSet.fields
    }
    
    // MARK: - Methods
    
    /// Decodes JSON response into a return type of the selection set.
    ///
    /// - Note: Don't use this function. This function should only be used internally by SwiftGraphQL.
    public func decode(data: TypeLock) -> Type {
        /* Construct a copy of the selection set, and use the new selection set to decode data. */
        let selectionSet = SelectionSet<Type, TypeLock>(data: data)
        return self.decoder(selectionSet)
    }
    
    /// Mocks the data of a selection.
    ///
    /// - Note: Don't use this function. This function should only be used internally by SwiftGraphQL.
    public func mock() -> Type {
        self.mocked
    }
}

// MARK: - Selection Utility functions

/*
 Utility functins are used for extending selections to nullable types and lists.
 */

extension Selection where TypeLock: Decodable {
    /// Lets you convert a type selection into a list selection.
    public var list: Selection<[Type], [TypeLock]> {
        return Selection<[Type], [TypeLock]> { selection in
            /* Selection */
            self.selection.forEach(selection.select)
            
            /* Decoder */
            switch selection.response {
            case .fetched(let data):
                return data.map { self.decode(data: $0) }
            case .fetching:
                return []
            }
        }
    }

    /// Lets you decode nullable values.
    public var nullable: Selection<Type?, TypeLock?> {
        Selection<Type?, TypeLock?> { selection in
            /* Selection */
            self.selection.forEach(selection.select)
            
            /* Decoder */
            switch selection.response {
            case .fetched(let data):
                return data.map { self.decode(data: $0) }
            case .fetching:
                return nil
            }
        }
    }
    
    /// Lets you decode nullable values into non-null ones.
    public var nonNullOrFail: Selection<Type, TypeLock?> {
        Selection<Type, TypeLock?> { selection in
            /* Selection */
            self.selection.forEach(selection.select)
            
            /* Decoder */
            switch selection.response {
            case .fetched(let data):
                return self.decode(data: data!)
            case .fetching:
                return self.mock()
            }
        }
    }
}

extension SelectionSet {
    /// Lets you leave the selection empty.
    public var empty: Selection<(), TypeLock> {
        Selection<(), TypeLock> { selection in
            /* Selection */
            let field = GraphQLField.leaf(name: "__typename", arguments: [])
            selection.select(field)
            
            /* Decoder */
            return ()
        }
    }
}

/*
 Helper functions that let you make changes upfront.
 */

extension Selection where TypeLock: Decodable {
    /// Lets you provide non-list selection for list field.
    public static func list<NonListType, NonListTypeLock>(
        _ selection: Selection<NonListType, NonListTypeLock>
    ) -> Selection<Type, TypeLock> where Type == [NonListType], TypeLock == [NonListTypeLock] {
        selection.list
    }
    
    /// Lets you provide non-nullable selection for nullable field.
    public static func nullable<NonNullType, NonNullTypeLock>(
        _ selection: Selection<NonNullType, NonNullTypeLock>
    ) -> Selection<Type, TypeLock> where Type == Optional<NonNullType>, TypeLock == Optional<NonNullTypeLock> {
        selection.nullable
    }
    
    /// Lets you provide non-nullable selection for nullable field and require that it has a value.
    public static func nonNullOrFail<NonNullTypeLock>(
        _ selection: Selection<Type, NonNullTypeLock>
    ) -> Selection<Type, TypeLock> where TypeLock == Optional<NonNullTypeLock> {
        selection.nonNullOrFail
    }
}
