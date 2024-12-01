xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:indent "yes";

declare variable $episodeJSON := fn:json-doc("../episodes.json");

let $episodes := $episodeJSON?episodes?*[?yearFrom ge 2100 and ?yearTo le 2200]

return array {
    for-each($episodes, function($episode) {
        map {
            "episodeTitle": $episode?title,
            "usAirDate": $episode?usAirDate,
            "id": $episode?uid
        }
    })
}