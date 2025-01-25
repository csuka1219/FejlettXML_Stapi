xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
import schema default element namespace "" at "animals.xsd";

declare option output:method "xml";
declare option output:indent "yes";

declare function local:fetch-page($pageNumber as xs:integer) {
    let $url := "https://stapi.co/api/v1/rest/animal/search"
    let $params := "?pageNumber=" || $pageNumber || "&amp;pageSize=100"
    return json-doc($url || $params)
};

declare function local:get-all-animals() {
    let $first-page := local:fetch-page(0)
    let $total-pages := xs:integer($first-page?page?totalPages)
    
    let $all-pages := 
        for $page in 0 to ($total-pages - 1)
        return local:fetch-page($page)?animals?*
        
    return $all-pages
};

let $animals := local:get-all-animals()
let $generatedXML :=
    <animals>
    {
        for $animal in $animals
        where not($animal?earthAnimal)
        return <animal>
                 <uid>{ $animal?uid }</uid>
                 <name>{ $animal?name }</name>
               </animal>
    }
    </animals>

return validate { $generatedXML }
