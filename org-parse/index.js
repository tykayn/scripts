/**
 afficher des infos depuis un fichier orgmode source
 **/

import org from 'org';
import fs from 'fs';

let input_orgmode_file_name = './tasks.org';
input_orgmode_file_name = './input.org';

fs.readFile(input_orgmode_file_name, 'utf8', function read(err, data) {
    if (err) {
        throw err;
    }
    const org_content = data;
    var parser = new org.Parser();
    var orgDocument = parser.parse(org_content);

    // console.log('orgDocument', orgDocument)
    orgDocument.nodes.forEach(node => {

        if (node.type === 'header') {
            console.log('header')

            searchForChildren(node)
        }
    })

    console.log('headerTexts', headerTexts);

    let all_headers = headerTexts.join('\n')
    console.log('le fichier input.org a ce nombre de type de tâches');
    console.log(' SOMEDAY:', all_headers.toString().match(/SOMEDAY/g)?.length);
    console.log(' TODO:', all_headers.toString().match(/TODO/g)?.length);
    console.log(' NEXT:', all_headers.toString().match(/NEXT/g)?.length);
    console.log(' CANCELLED:', all_headers.toString().match(/CANCELLED/g)?.length);
    console.log(' DONE:', all_headers.toString().match(/DONE/g)?.length);

});

let headerTexts = []

function logTextOfNode(node) {
    if (node.value && node.type==='text') {
        console.log(' -- ', node.value)
        headerTexts.push(node.value)
    }
}

function searchForChildren(node) {
    logTextOfNode(node)

    if (node.children) {

        node.children.forEach(child => {
            console.log(' -- ', child)
            searchForChildren(child)
        })
    }
}

// trouver les propriétés de date de cloture pour grouper les tâches par section de temps
// afin de savoir ce qui a été réalisé ces X derniers jours

let interval_report_days = 30;


