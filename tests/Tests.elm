module Tests exposing (..)

import Test exposing (..)
import Expect
import SwaggerDecoder
import Json.Decode exposing (decodeString)


all : Test
all =
    describe "Single decoder test"
        [ test "test SchemaOrReference" <|
            \() ->
                let
                    decodeResult =
                        decodeString SwaggerDecoder.decodeSchemaOrReference definitionJson

                    ( resultOk, message ) =
                        isResultOk decodeResult
                in
                    Expect.true "SchemaOrReference is resul ok" resultOk
                        |> Expect.onFail message
        ]


isResultOk : Result String a -> ( Bool, String )
isResultOk result =
    case result of
        Result.Ok _ ->
            ( True, "" )

        Err error ->
            ( False, error )


definitionJson : String
definitionJson =
    """{
    "properties": {
      "buckets": {
        "description": "Aggregation values (buckets) and correspondig item counts",
        "items": {
          "$ref": "#/definitions/AggregationBucket"
        },
        "type": "array"
      },
      "filterTerm": {
        "description": "Term used to filter the results",
        "type": "string"
      },
      "name": {
        "description": "Aggregation name",
        "type": "string"
      }
    },
    "type": "object"
  }
"""
