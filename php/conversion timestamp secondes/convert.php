<?php
// coller ici les données de timestamp pour les convertir
$data = ["    00:10:47.000"
    , "00:02:01.000"
    , "00:01:47.000"
    , "00:04:04.862"
    , "00:12:28.000"
    , "00:01:10.000"
    , "00:02:54.000"
    , "00:01:58.000"
    , "00:01:54.000"
    , "00:14:23.000"
    , "00:01:33.000"
    , "00:01:31.000"
    , "00:04:22.000"
    , "00:00:53.000"
    , "00:06:37.000"
    , "00:01:22.000"
    , "00:12:11.000"
    , "00:16:13.000"
    , "00:00:56.000"
];

$results = [];
foreach ($data as $datum) {
    $results[] = convertTimeStampToSeconds($datum);

}

function convertTimeStampToSeconds($timestamp)
{
    $converted = '';
    $boom = explode(':', $timestamp);
    $seconds = explode('.', $boom[2]);
    $converted = $boom[0] * 120 + $boom[1] * 60 + $boom[2] * 1;
    return $converted;
}


foreach ($results as $result) {
    echo "\n" . $result . ' ';
}