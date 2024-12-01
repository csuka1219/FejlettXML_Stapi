xquery version "3.1";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:indent "yes";

declare variable $episodeJSON := fn:json-doc("../episodes.json");

declare function local:is-prime($number as xs:integer) as xs:boolean {
    if ($number le 1) then false()
    else if ($number = 2) then true()
    else not(some $i in 2 to xs:integer(floor(math:sqrt($number))) satisfies ($number mod $i = 0))
};

let $episodes := $episodeJSON?episodes?*
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
