<?php
/***
 * écrire un rapport à partir des données prises dans un fichier tableur odt
 */

require 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\Spreadsheet;


$temps_parole_total = 0;
$sheet_name = "résumé";
$cell_temps_parole_total = "E26";

$file_readable = "./cndp_calcul_temps_parole.ods";

$inputFileType = 'ods';
$inputFileName = $file_readable;

/**  Create a new Reader of the type defined in $inputFileType  **/
$reader = new \PhpOffice\PhpSpreadsheet\Reader\Ods();
/**  Advise the Reader of which WorkSheets we want to load  **/
//$reader->setLoadSheetsOnly($sheet_name);
/**  Load $inputFileName to a Spreadsheet Object  **/
try {
    $spreadsheet = \PhpOffice\PhpSpreadsheet\IOFactory::load($inputFileName);
} catch (\PhpOffice\PhpSpreadsheet\Reader\Exception $e) {
    throw new ErrorException($e);
}
$spreadsheet->setActiveSheetIndexByName($sheet_name);

$temps_parole_total = $spreadsheet->getActiveSheet()->getCell($cell_temps_parole_total)->getCalculatedValue();
$temps_parole_total = round($temps_parole_total /60 /60 , 2);

$phrase = "au total, ce sont ".$temps_parole_total." heures qui ont été enregistrées pour ce débat public";


$resume= 'sur les 	52	groupes invités par la CNDP
représentant	'.$temps_parole_total.'	heures de temps de parole
	37 %	Pourcent était accordé à des organisations se positionnant contre le projet de nouveaux EPR,
	38 %	étaient neutres
	25 %	étaient en faveur du projet
soit	1,5	fois plus de gens contre invités que pour
		alors que selon l’étude de l’ifop de Septembre 2022 pour le JDD
	65	% des Français 
		sont favorables ou « tout à fait favorables » à la construction de nouveaux réacteurs nucléaires en France dans les prochaines années';

echo $resume;
// on peut lire une feuille mais pas obtenir une valeur si on fait un calcul à partir de plusieurs feuilles