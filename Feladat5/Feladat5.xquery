xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
import schema default element namespace "" at "weaponCategories.xsd";

declare option output:method "xml";
declare option output:html-version "5.0";
declare option output:indent "yes";

let $weaponsJSON := fn:json-doc("../weapons.json")
let $weapons := $weaponsJSON?weapons?*
let $weaponCategories := 
    for $weapon in $weapons
    for $key in map:keys($weapon)
    where $weapon($key) = true() and matches($key, "Technology|Weapon")
    return $key
let $distinctCategories := fn:distinct-values($weaponCategories)
let $categoriesSummary :=
    for $category in $distinctCategories
    let $count := count($weaponCategories[. = $category])
    return <category name="{$category}" count="{$count}" />

let $generatedXML := document {
    <weaponCategories>
        {$categoriesSummary}
    </weaponCategories>
}

return validate { $generatedXML }
