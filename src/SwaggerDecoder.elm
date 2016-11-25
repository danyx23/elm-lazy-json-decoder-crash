module SwaggerDecoder exposing (..)

import Json.Decode
    exposing
        ( int
        , string
        , float
        , Decoder
        , map
        , oneOf
        , andThen
        , succeed
        , dict
        , lazy
        , list
        , field
        , bool
        , map2
        , fail
        )
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, custom)
import Dict exposing (Dict)


type SchemaOrReference
    = ReferencedSchema String
    | SpecifiedSchema Schema


type DataType
    = TypeInteger
    | TypeFloat
    | TypeString
    | TypeBoolean
    | TypeObject (Dict String SchemaOrReference)
    | TypeArray SchemaOrReference


type alias Schema =
    { fieldType : DataType
    , description : Maybe String
    , xNullable : Bool
    }


decodeSchemaOrReference : Decoder SchemaOrReference
decodeSchemaOrReference =
    oneOf
        [ map ReferencedSchema <| field "$ref" string
        , map SpecifiedSchema (lazy (\_ -> decodeSchema))
        ]


decodeSchema : Decoder Schema
decodeSchema =
    field "type" string
        |> andThen decodeSchemaByType


decodeSchemaByType : String -> Decoder Schema
decodeSchemaByType typeString =
    let
        typedDecoder =
            case typeString of
                "integer" ->
                    succeed TypeInteger

                "float" ->
                    succeed TypeFloat

                "double" ->
                    succeed TypeFloat

                "string" ->
                    succeed TypeString

                "boolean" ->
                    succeed TypeBoolean

                "object" ->
                    map TypeObject <|
                        field "properties" <|
                            dict (lazy (\_ -> decodeSchemaOrReference))

                "array" ->
                    map TypeArray <|
                        field "items" <|
                            (lazy (\_ -> decodeSchemaOrReference))

                other ->
                    fail <| "Found unrecognized type " ++ other

        fullDecoder =
            decode Schema
                |> custom typedDecoder
                |> optional "description" (map Just string) Nothing
                |> optional "x-nullable" bool False
    in
        fullDecoder
