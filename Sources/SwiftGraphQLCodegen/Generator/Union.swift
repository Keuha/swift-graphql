import Foundation
import GraphQLAST

/**
 Interfaces generates an object type as well as possible type extensions.
 */

extension GraphQLCodegen {
    /// Generates a function to handle a type.
    func generateUnion(
        _ type: UnionType,
        with objects: [ObjectType]
    ) throws -> [String] {
        let name = type.name.pascalCase

        /* Collect of all fields of all possible types. */
        var fields: [Field] = []
        for object in objects {
            // Skip object if it's not inside possible types.
            guard type.possibleTypes.contains(where: { $0.namedType.name == object.name }) else { continue }
            // Append fields otherwise.
            for field in object.fields {
                // Make suer fields are unique.
                guard !fields.contains(where: { $0.name == field.name }) else { continue }
                fields.append(field)
            }
        }

        /* Code */

        /* Decoders */
        var code: [String] = [
            "/* \(type.name) */",
            "",
            "extension Unions {",
        ]
        // Definition
        code.append(contentsOf:
            try generateEncodableStruct(
                name,
                fields: fields,
                possibleTypes: type.possibleTypes.map { $0.namedType }
            )
        )
        code.append("}")
        code.append("")
        // Decoder
        code.append("extension Unions.\(name): Decodable {")
        code.append(contentsOf:
            try generateDecodableExtension(
                fields: fields,
                possibleTypes: type.possibleTypes.map { $0.namedType }
            )
        )
        code.append("}")
        code.append("")
        // 
        code.append(contentsOf:
            generateFragmentSelection(
                "Unions.\(type.name.pascalCase)",
                for: type.possibleTypes,
                with: objects
            )
        )

        return code
    }
}
