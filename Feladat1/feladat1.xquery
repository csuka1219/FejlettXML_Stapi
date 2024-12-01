xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
import schema default element namespace "" at "weapons.xsd";

declare option output:method "xml";
declare option output:html-version "5.0";
declare option output:indent "yes";

let $weaponsJSON := fn:json-doc("../weapons.json"),
    $filteredWeapons := $weaponsJSON?weapons?*[?explosiveWeapon and ?alternateReality and string-length(translate(?name, 'aeiouyAEIOUY', '')) < string-length(?name) - 2],
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
