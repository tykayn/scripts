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

    console.log('le fichier input.org a ce nombre de');
    console.log(' SOMEDAY:', org_content.toString().match(/SOMEDAY/g)?.length);
    console.log(' TODO:', org_content.toString().match(/TODO/g)?.length);
    console.log(' NEXT:', org_content.toString().match(/NEXT/g)?.length);
    console.log(' CANCELLED:', org_content.toString().match(/CANCELLED/g)?.length);
    console.log(' DONE:', org_content.toString().match(/DONE/g)?.length);

});


