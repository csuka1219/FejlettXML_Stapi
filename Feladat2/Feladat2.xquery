(:Az epizódban szereplő halott karaktereket adja vissza XML formátumban.
:)

xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
import schema default element namespace "" at "deceasedCharacters.xsd";

declare option output:method "xml";
declare option output:html-version "5.0";
declare option output:indent "yes";

let $episodeJSON := fn:json-doc("../EPMA0000001350.json"),
    $characters := $episodeJSON?episode?characters?*[?deceased = true()],
    $generatedXML := document {
        <deceasedCharacters>
            {
                for $character in $characters return
                <character>
                    <name>{$character?name}</name>
                    <yearOfDeath>{$character?yearOfDeath}</yearOfDeath>
                </character>
            }
        </deceasedCharacters>
    }

return validate { $generatedXML }
