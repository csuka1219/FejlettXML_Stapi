xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
import schema default element namespace "" at "weapons.xsd";

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

let $weapons := local:get-all-weapons(),
    $filteredWeapons := $weapons[?explosiveWeapon and ?alternateReality and 
                                string-length(translate(?name, 'aeiouyAEIOUY', '')) < string-length(?name) - 2],
    $generatedXML := document {
        <weapons>
            {
                for $weapon in $filteredWeapons return
                <weapon>
                    <name>{$weapon?name}</name>
                    <explosiveWeapon>{$weapon?explosiveWeapon}</explosiveWeapon>
                    <alternateReality>{$weapon?alternateReality}</alternateReality>
                </weapon>
            }
        </weapons>
    }

return validate { $generatedXML }
