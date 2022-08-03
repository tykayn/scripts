# OSM Conversion

Convertir un résultat d'overpass vers un tableau CSV de base de données présentant les limites de vitesse de tronçons routiers.

file:///home/tykayn/Nextcloud/boulot/osm/bdd_vitesses/overpass_results

## Requête source Overpass turbo
https://overpass-turbo.eu/s/1kGY

## CSV output
|-----+--------+-------------+-------+---------+-----------+-----------+-------------+------------------+-----------+----------|
| ref | way_id |  speedlimit |  tags | highway | start_lat |  end_long |  start_long | end_long         | road_name | road_ref |
|-----+--------+-------------+-------+---------+-----------+-----------+-------------+------------------+-----------+----------|
