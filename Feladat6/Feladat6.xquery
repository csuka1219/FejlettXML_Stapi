(:Visszaadja azokat az epizódokat JSON tömbként, amelyek amerikai sugárzási dátumának nap része prímszám.
:)

xquery version "3.1";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:indent "yes";

declare function local:is-prime($number as xs:integer) as xs:boolean {
    if ($number le 1) then false()
    else if ($number = 2) then true()
    else not(some $i in 2 to xs:integer(floor(math:sqrt($number))) satisfies ($number mod $i = 0))
};

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
let $filteredEpisodes := for $episode in $episodes
                         where local:is-prime(xs:integer(substring($episode?usAirDate, 9, 2)))
                         return $episode
return array {
    for $episode in $filteredEpisodes
    return map {
        "episodeTitle": $episode?title,
        "usAirDate": $episode?usAirDate,
        "id": $episode?uid
    }
}
