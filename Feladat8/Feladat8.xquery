xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
import schema default element namespace "" at "animals.xsd";

declare option output:method "xml";
declare option output:indent "yes";

declare variable $animalsJSON := fn:json-doc("../animals.json");

declare variable $animals := $animalsJSON?animals;

let $generatedXML :=
    <animals>
      {
        for $animal in $animals?*
        where not($animal?earthAnimal)
        return <animal>
                 <uid>{ $animal?uid }</uid>
                 <name>{ $animal?name }</name>
               </animal>
      }
    </animals>

return validate { $generatedXML }
