xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
import schema default element namespace "" at "weaponCategories.xsd";

declare option output:method "xml";
declare option output:html-version "5.0";
declare option output:indent "yes";

declare function local:fetch-page($pageNumber as xs:integer) {
    let $url := "https://stapi.co/api/v2/rest/weapon/search"
    let $params := "?pageNumber=" || $pageNumber || "&amp;pageSize=100"
    return json-doc($url || $params)
};

declare function local:get-all-weapons() {
    let $first-page := local:fetch-page(0)
    let $total-pages := xs:integer($first-page?page?totalPages)
    
    let $all-pages := 
        for $page in 0 to ($total-pages - 1)
        return local:fetch-page($page)?weapons?*
        
    return $all-pages
};

let $weapons := local:get-all-weapons()
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
