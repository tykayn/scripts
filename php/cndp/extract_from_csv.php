<?php

echo "======== conversion du fichier csv de tableur vers des données json de graphique =======";
#// parcourir le fichier csv
$array_content_csv = array_map('str_getcsv', file('cndp_calcul_temps_parole.csv', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES));

$excluded_terms_for_graphs = ['minutes', 'somme', 'heures', $start_resume_data, $end_resume_data];
$start_resume_data = "RESUME";
$end_resume_data = "ENDRESUME";
$resume_active = false;
$resume_text = '';

$start_graph_data = "____";
$headers_graph_data = "headers";
$values_graph_data = "values";
$end_graph_data = "####";

$json_graphs_data = ['graphs' => []];

$currentGraph = [
    "title" => ''
];

foreach ($array_content_csv as $line) {

    // fix encoding
    $line = mb_convert_encoding($line, 'utf-8', 'iso-8859-9');

    if (in_array($start_graph_data, $line)) {
        $currentGraph['title'] = $line[2];
    } elseif (in_array($headers_graph_data, $line)) {
        foreach ($line as $cell) {
            if ($cell && $cell !== $headers_graph_data) {
                $currentGraph['headers'][] = $cell;
            }
        }
    } elseif (in_array($values_graph_data, $line)) {
        foreach ($line as $cell) {

            if ($cell && $cell !== $values_graph_data && !in_array($cell, $excluded_terms_for_graphs)) {

                $currentGraph['values'][] = round(str_replace(['%', ','], ['', '.'], $cell), 2);
            }
        }
    } elseif (in_array($end_graph_data, $line)) {
        $json_graphs_data['graphs'][] = $currentGraph;
        $currentGraph = [];
    }

    if (in_array($start_resume_data, $line)) {
        $resume_active = true;
    } elseif (in_array($end_resume_data, $line)) {
        $resume_active = false;
    }

    if ($resume_active) {
        foreach ($line as $cell) {
            if($cell && !in_array($cell,$excluded_terms_for_graphs)){


            $resume_text = $resume_text.' '.$cell;
            }
        }
    }

}

# // convertir en json pour faire un graphique
// clean des lignes de texte

$resume_text = preg_replace('!\s+!', ' ', $resume_text);

$json_graphs_data['resume'] = str_replace('  ', ' ',$resume_text);
echo " \n";
var_dump($resume_text);

$file = "graphs_data_cndp.json";
file_put_contents($file, json_encode($json_graphs_data));

$file = "resume.json";
file_put_contents($file, json_encode(['resume' => $resume_text]));

//var_dump($json_graphs_data);