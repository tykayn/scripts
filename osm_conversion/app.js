/**
 * converter of overpass results to CSV
 */

const exportFileName = "bdd-vitesses-fr-osm_ways_zone-saint-mande_date-made-2022-08-03_full.csv"
let header_csv = ["national_ref", "way_id", "osm_link", "name", "highway_tag","speed_limit"]
let lines_csv = []
const sourceFilePath = "./overpass_results/export_saint_mande.json"
const overpassDataJson = require(sourceFilePath)
const reference_prefix = "V94160_";

let counter_no_speedlimit = 0;
let counter_highways = overpassDataJson['elements'].length;

let turn_ii = 0;
let turn_ii_limit = 2000;
const fs = require('fs')
console.log("overpassDataJson elements", overpassDataJson['elements'].length)

overpassDataJson['elements'].forEach((elem) => {

    // limit turns for dev time
    turn_ii++
    if (turn_ii >= turn_ii_limit) {
        return
    }

    let line_properties = {
        "ref": ""+reference_prefix + turn_ii,
        "way_id": elem.id,
        "osm_link": `"https://www.openstreetmap.org/way/${elem.id}"`,
        "name": null,
        "highway": null,
        "speedlimit": null,
    }
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
        }else{
            counter_no_speedlimit++
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

    })
    return csv_line + "\n"
});


writeCSVOutput();


function writeCSVOutput() {


    let content = header_csv.join(';') + ';\n' + lines_out;
    console.log(" ")
    // console.log("content", content.replace(','+reference_prefix, reference_prefix))
    fs.writeFile('output/' + exportFileName, content, function (err, data) {
        if (err) {
            return console.log(err);
        }
        console.log("counter_no_speedlimit", counter_no_speedlimit)
        console.log("on", counter_highways)
        console.log("missing data : ", Math.floor(  counter_no_speedlimit * 100 /counter_highways ) + "%" )
        console.log(" ")
        console.log('wrote output file', exportFileName);
    });
}


