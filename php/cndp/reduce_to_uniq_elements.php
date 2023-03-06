<?php

$data="
CNDP
CNDP
FNE
CNDP
ANCCLI
Sénat
PCF
Maire de Dieppe
Science-po

SDN
EDF
CNDP
CNDP
EDF

CNDP
CNDP
EDF
CNDP
CNDP
ADEME
Négawatt
EDF
Ministère de la transition écologique
CNDP
CNDP
RTE
EDF
CNDP
CNDP
SFEN
ENSAE
CNDP
IRSN
Global Chance


EDF
CNDP
CNDP
Cour des comptes
CNDP
EDF
CNDP
CNDP
CNDP
Maire de CAEN
EDF
IRSN

EDF
CNDP
EDF
ARS
RTE
CNDP
CNDP
Sciences Po
ACRO
Sciences Po
Greenpeace
Sciences Po
Commission environementale normandie
CLIN
GIEC
DTM
EDF
Conseil départemental

CNDP


FNE

Chambre d'agriculture
DREAL

EDF
CNDP


CNDP
GIEC
Préfecture
CNDP
CNDP
Elu
CNDP
CNDP
CNDP
CNDP
GIFEN
CNDP
Communauté de communes
Commission développement économique
CCI
CESER
EDF
CNDP
CNDP
Normandie Energies
Négawatt
CNDP
Pôle Emploi
Délégué à l'action régionale Normandie
Préfecture
CNDP
CNDP
NEA
FNE
Energie et Environement en Débat dans l'Aisne
Global Chance
CNRS
SFEN
CFECGC
Global Chance
CNDP
DNN
EDF
EPE
CNDP

CNDP
CNDP
CNDP
CNDP
FNE
CNDP
EDF

CNDP
EDF
EDF
CNDP
Voix du Nucléaire
Global Chance
IRSN
EDF
?
Andra
ENS ULM
CNDP
ORANO
EELV
Greenpeace
CNDP
Andra


CNDP
CNDP
CEA
Global Chance
SFEN
Fondation pour la nature et l'homme
Global Chance
CNDP
Cérémé
Cour des comptes
CNDP
CNDP
Ville de Lyon

";
    $data = explode("\n", trim($data));
        $data = array_unique($data);

        sort($data);
join('\n', $data);



foreach ($data as $d) {
    echo  $d . "\n";
}
