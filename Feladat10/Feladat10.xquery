(:Visszaadja azokat az epizódokat JSON formátumban, ahol az epizódszám osztható (maradék nélkül) az évad számával.
:)

xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:indent "yes";

declare function local:fetch-page($pageNumber as xs:integer) {
    let $url := "https://stapi.co/api/v1/rest/episode/search"
    let $params := "?pageNumber=" || $pageNumber || "&amp;pageSize=100"
    return json-doc($url || $params)
};

declare function local:get-all-episodes() {
    let $first-page := local:fetch-page(0)
    let $total-pages := xs:integer($first-page?page?totalPages)
    
    let $all-pages := 
        for $page in 0 to ($total-pages - 1)
        return local:fetch-page($page)?episodes?*
        
    return $all-pages
};

let $episodes := local:get-all-episodes()
return array {
    for $episode in $episodes
    where $episode?episodeNumber mod $episode?seasonNumber = 0
    return map {
        "uid": $episode?uid,
        "title": $episode?title,
        "seasonNumber": $episode?seasonNumber,
        "episodeNumber": $episode?episodeNumber
    }
}
