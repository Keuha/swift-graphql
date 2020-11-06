/**
 * This file was generated by Nexus Schema
 * Do not make changes to this file directly
 */

import * as swapi from './types/backingTypes'
import { core } from '@nexus/schema'
declare global {
  interface NexusGenCustomInputMethods<TypeName extends string> {
    date<FieldName extends string>(
      fieldName: FieldName,
      opts?: core.ScalarInputFieldConfig<
        core.GetGen3<'inputTypes', TypeName, FieldName>
      >,
    ): void // "Date";
  }
}
declare global {
  interface NexusGenCustomOutputMethods<TypeName extends string> {
    date<FieldName extends string>(
      fieldName: FieldName,
      ...opts: core.ScalarOutSpread<TypeName, FieldName>
    ): void // "Date";
  }
}

declare global {
  interface NexusGen extends NexusGenTypes {}
}

export interface NexusGenInputs {
  Greeting: {
    // input type
    language?: NexusGenEnums['Language'] | null // Language
    name: string // String!
  }
  GreetingOptions: {
    // input type
    prefix?: string | null // String
  }
}

export interface NexusGenEnums {
  Episode: 5 | 6 | 4
  Language: 'EN' | 'SL'
}

export interface NexusGenScalars {
  String: string
  Int: number
  Float: number
  Boolean: boolean
  ID: string
  Date: any
}

export interface NexusGenRootTypes {
  Droid: swapi.Droid
  Human: swapi.Human
  Query: {}
  Character: swapi.Character
  CharacterUnion: NexusGenRootTypes['Droid'] | NexusGenRootTypes['Human']
}

export interface NexusGenAllTypes extends NexusGenRootTypes {
  Greeting: NexusGenInputs['Greeting']
  GreetingOptions: NexusGenInputs['GreetingOptions']
  Episode: NexusGenEnums['Episode']
  Language: NexusGenEnums['Language']
  String: NexusGenScalars['String']
  Int: NexusGenScalars['Int']
  Float: NexusGenScalars['Float']
  Boolean: NexusGenScalars['Boolean']
  ID: NexusGenScalars['ID']
  Date: NexusGenScalars['Date']
}

export interface NexusGenFieldTypes {
  Droid: {
    // field return type
    appearsIn: NexusGenEnums['Episode'][] // [Episode!]!
    id: string // ID!
    name: string // String!
    primaryFunction: string // String!
  }
  Human: {
    // field return type
    appearsIn: NexusGenEnums['Episode'][] // [Episode!]!
    homePlanet: string | null // String
    id: string // ID!
    infoURL: string | null // String
    name: string // String!
  }
  Query: {
    // field return type
    character: NexusGenRootTypes['CharacterUnion'] | null // CharacterUnion
    characters: NexusGenRootTypes['Character'][] // [Character!]!
    droid: NexusGenRootTypes['Droid'] | null // Droid
    droids: NexusGenRootTypes['Droid'][] // [Droid!]!
    greeting: string // String!
    human: NexusGenRootTypes['Human'] | null // Human
    humans: NexusGenRootTypes['Human'][] // [Human!]!
    luke: NexusGenRootTypes['Human'] | null // Human
    time: NexusGenScalars['Date'] // Date!
    whoami: string // String!
  }
  Character: {
    // field return type
    id: string // ID!
    name: string // String!
  }
}

export interface NexusGenArgTypes {
  Query: {
    character: {
      // args
      id: string // ID!
    }
    droid: {
      // args
      id: string // ID!
    }
    greeting: {
      // args
      input?: NexusGenInputs['Greeting'] | null // Greeting
    }
    human: {
      // args
      id: string // ID!
    }
  }
}

export interface NexusGenAbstractResolveReturnTypes {
  CharacterUnion: 'Droid' | 'Human'
  Character: 'Droid' | 'Human'
}

export interface NexusGenInheritedFields {}

export type NexusGenObjectNames = 'Droid' | 'Human' | 'Query'

export type NexusGenInputNames = 'Greeting' | 'GreetingOptions'

export type NexusGenEnumNames = 'Episode' | 'Language'

export type NexusGenInterfaceNames = 'Character'

export type NexusGenScalarNames =
  | 'Boolean'
  | 'Date'
  | 'Float'
  | 'ID'
  | 'Int'
  | 'String'

export type NexusGenUnionNames = 'CharacterUnion'

export interface NexusGenTypes {
  context: swapi.ContextType
  inputTypes: NexusGenInputs
  rootTypes: NexusGenRootTypes
  argTypes: NexusGenArgTypes
  fieldTypes: NexusGenFieldTypes
  allTypes: NexusGenAllTypes
  inheritedFields: NexusGenInheritedFields
  objectNames: NexusGenObjectNames
  inputNames: NexusGenInputNames
  enumNames: NexusGenEnumNames
  interfaceNames: NexusGenInterfaceNames
  scalarNames: NexusGenScalarNames
  unionNames: NexusGenUnionNames
  allInputTypes:
    | NexusGenTypes['inputNames']
    | NexusGenTypes['enumNames']
    | NexusGenTypes['scalarNames']
  allOutputTypes:
    | NexusGenTypes['objectNames']
    | NexusGenTypes['enumNames']
    | NexusGenTypes['unionNames']
    | NexusGenTypes['interfaceNames']
    | NexusGenTypes['scalarNames']
  allNamedTypes:
    | NexusGenTypes['allInputTypes']
    | NexusGenTypes['allOutputTypes']
  abstractTypes: NexusGenTypes['interfaceNames'] | NexusGenTypes['unionNames']
  abstractResolveReturn: NexusGenAbstractResolveReturnTypes
}

declare global {
  interface NexusGenPluginTypeConfig<TypeName extends string> {}
  interface NexusGenPluginFieldConfig<
    TypeName extends string,
    FieldName extends string
  > {}
  interface NexusGenPluginSchemaConfig {}
}
