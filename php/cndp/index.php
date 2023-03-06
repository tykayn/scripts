<?php

$json = json_decode(file_get_contents('graphs_data_cndp.json'), true);
?>
<h1>Résumé du débat</h1>
<div class="resume">

<?php
echo $json['resume'];
?>
</div>
