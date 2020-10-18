import Foundation
import Files
import SwiftGraphQLCodegen


let endpoint = URL(string: "http://localhost:4000")!

do {
    let target = try Folder.current.parent!
        .subfolder(at: "StarWars")
        .createFile(at: "API.swift").url
    try GraphQLCodegen.generate(target, from: endpoint)
    
    print("Generated API to \(target.absoluteString)")
} catch {
    exit(1)
}

