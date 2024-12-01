xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
import schema default element namespace "" at "performers.xsd";

declare option output:method "xml";
declare option output:indent "yes";

declare variable $episodeJSON := fn:json-doc("../EPMA0000001350.json");
declare variable $performers := $episodeJSON?episode?performers?*;

let $generatedXML := 
    <performers>
      {
        let $livingPerformers :=
          for $performer in $performers
          where $performer?dateOfBirth and
                starts-with($performer?dateOfBirth, "195") and
                not($performer?dateOfDeath)
          return <performer>
                   <uid>{ $performer?uid }</uid>
                   <name>{ $performer?name }</name>
                   <dateOfBirth>{ $performer?dateOfBirth }</dateOfBirth>
                   <gender>{ $performer?gender }</gender>
                 </performer>,
            $deceasedPerformers :=
          for $performer in $performers
          where $performer?dateOfBirth and
                starts-with($performer?dateOfBirth, "195") and
                $performer?dateOfDeath
          return <performer>
                   <uid>{ $performer?uid }</uid>
                   <name>{ $performer?name }</name>
                   <dateOfBirth>{ $performer?dateOfBirth }</dateOfBirth>
                   <gender>{ $performer?gender }</gender>
                 </performer>
        return (
          if (exists($livingPerformers)) then <livingPerformers>{ $livingPerformers }</livingPerformers> else (),
          if (exists($deceasedPerformers)) then <deceasedPerformers>{ $deceasedPerformers }</deceasedPerformers> else ()
        )
      }
    </performers>

return validate { $generatedXML }
