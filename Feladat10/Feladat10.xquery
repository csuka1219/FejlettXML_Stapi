xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:indent "yes";

declare variable $episodesJSON := fn:json-doc("../episodes.json");
declare variable $episodes := $episodesJSON?episodes?*;

array {
  for $episode in $episodes
  where $episode?episodeNumber mod $episode?seasonNumber = 0
  return map {
    "uid": $episode?uid,
    "title": $episode?title,
    "seasonNumber": $episode?seasonNumber,
    "episodeNumber": $episode?episodeNumber
  }
}