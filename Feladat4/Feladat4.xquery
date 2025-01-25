(:Kiszámítja az epizódban szereplő karakterek élettartamát, és JSON formátumban visszaadja azokat, akik több mint 70 évet éltek.
:)

xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";

declare option output:method "json";
declare option output:html-version "5.0";
declare option output:indent "yes";

let $episodeJSON := fn:json-doc("../EPMA0000001350.json"),
    $charactersWithLifeLength := $episodeJSON?episode?performers?*[fn:empty(?dateOfBirth) eq false() and fn:empty(?dateOfDeath) eq false()],
    $charactersLivedMoreThanThirty := $charactersWithLifeLength[year-from-date(xs:date(?dateOfDeath)) - year-from-date(xs:date(?dateOfBirth)) gt 70],
    $transformedArray := array {
        for $character in $charactersLivedMoreThanThirty
        return map {
            "characterID": $character?uid,
            "name": $character?name,
            "gender": if ($character?gender = "M") then "Male" else "Female",
            "yearOfBirth": year-from-date(xs:date($character?dateOfBirth)),
            "yearOfDeath": year-from-date(xs:date($character?dateOfDeath)),
            "lifeInYears": year-from-date(xs:date($character?dateOfDeath)) - year-from-date(xs:date($character?dateOfBirth))
        }
    }
return $transformedArray
