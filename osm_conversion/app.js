/**
 * converter of overpass results to CSV
 */

const exportFileName = "bdd-vitesses-fr-osm_ways_zone-saint-mande_date-made-2022-08-03_full.csv"
let header_csv = ["ref", "way_id", "speedlimit", "highway"]
let lines_csv = []
const sourceFilePath = "./overpass_results/export_saint_mande.json"
const overpassDataJson = require(sourceFilePath)
const reference_prefix = "75_";

let turn_ii = 0;
let turn_ii_limit = 3;
const fs = require('fs')
console.log("overpassDataJson elements", overpassDataJson['elements'].length)

overpassDataJson['elements'].forEach((elem) => {

        // limit turns for dev time
        turn_ii++
        if (turn_ii >= turn_ii_limit) {
            return
        }
        let line_properties = {
            "ref": reference_prefix,
            "way_id": elem.id,
            "speedlimit": null,
            "highway": null
        }
        console.log("elem.id", elem.id)
        if (elem.tags) {


            console.log("elem.tags.highway", elem.tags.highway)
            if (elem.tags.highway) {
                line_properties.highway = elem.tags.highway
            }

            if (elem.tags.ref) {

                // line_properties.ref += elem.tags.ref.replace(' ','-')
                line_properties.ref += elem.tags.ref
            }
            if (elem.tags.maxspeed) {
                console.log("elem.tags.maxspeed", elem.tags.maxspeed)
                line_properties['speedlimit'] = elem.tags.maxspeed
            }
        }
        lines_csv.push(line_properties)
    })

let lines_out = lines_csv.map(elem => {
    let keys = Object.keys(elem)
    let csv_line = '';
    keys.forEach(keyName=>{
        csv_line += elem[keyName]+', '
    })
    return csv_line + "\n"
});
console.log("lines_out", lines_out)
// writeCSVOutput();



function writeCSVOutput() {



    fs.writeFile('output/' + exportFileName, header_csv.join(',') + '\n' + lines_out, function (err, data) {
        if (err) {
            return console.log(err);
        }
        console.log('wrote output file', exportFileName);
    });
}


