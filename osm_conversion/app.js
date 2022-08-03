/**
 * converter of overpass results to CSV
 */

const exportFileName = "bdd-vitesses-fr-osm_ways_zone-saint-mande_date-made-2022-08-03_full.csv"
let header_csv = ["ref", "way_id", "speedlimit", "highway"]
let lines_csv = []
const sourceFilePath = "./overpass_results/export_saint_mande.json"
const overpassDataJson = require(sourceFilePath)
let reference_prefix = "94160_";

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
        "ref": reference_prefix + turn_ii,
        "way_id": elem.id,
        "osm_link": "https://www.openstreetmap.org/way/" + elem.id,
        "speedlimit": null,
        "highway": null,
        "name": null,
    }
    console.log("elem.id", elem.id)
    if (elem.tags) {


        console.log("elem.tags.highway", elem.tags.highway)
        if (elem.tags.highway) {
            line_properties.highway = elem.tags.highway
        }

        if (elem.tags.ref) {

            line_properties.ref += '_' + elem.tags.ref.replace(' ', '-')
        }
        if (elem.tags.name) {
            line_properties['name'] = elem.tags.name
        }
        if (elem.tags.maxspeed) {
            line_properties['speedlimit'] = elem.tags.maxspeed
        }
    }
    lines_csv.push(line_properties)
})

let lines_out = lines_csv.map(elem => {

    let keys = Object.keys(elem)
    let csv_line = '';
    keys.forEach(keyName => {
        csv_line += elem[keyName]
        csv_line += ';'
        console.log("ii, elem[keyName]", ii, elem[keyName])

    })
    return csv_line + "\n"
});
writeCSVOutput();


function writeCSVOutput() {


    let content = header_csv.join(';') + ';\n' + lines_out;
    console.log(" ")
    console.log("content", content)
    fs.writeFile('output/' + exportFileName, content, function (err, data) {
        if (err) {
            return console.log(err);
        }
        console.log('wrote output file', exportFileName);
    });
}


