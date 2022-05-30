<?php

/****************************
 * un humain de base
 ****************************/
class Human {

	public $name;
	public $gender;
	private $status;

	//dÃ©finr le statut
	public function setStatus( $newStatus ) {
		$this->status = $newStatus;
	}

	// Afficher qui on est
	public function whoAmI() {
		echo '<br/><i> Je suis un humain ' . $this->gender . ' ' . $this->status . ' nommÃ© ' . $this->name . '</i>';
	}

}

/****************************
 * un mÃ¢le humain
 * Class Man
 * /*****************************/
class Man extends Human {

	public function __construct( $complete_name = "Bob" , $status = "puceau" ) {
		$this->name = $complete_name;
		$this->gender = "homme";
		$this->setStatus( $status );
	}

	/**
	 * les hommes ne fuckent qu'avec les femmes
	 * nous allons donc restreindre ce paramÃ¨tre
	 * @param Woman $femme
	 */
	public function fuck( Woman $femme ) {

		/**
		 * si la femme fuckeÃ© est une mÃ¨re,
		 * alors l'homme est un mother fuckeur
		 */
		if ( $femme->isMother() ) {
			$newMaleStatus = "mother fucker";
			$femme->setStatus( 'impossible' );
		}
		else {
			// on va dire que fucker fait tomber enceinte Ã  tous les coups.
			$femme->pregnant = true;
			$femme->setStatus( 'comblÃ©e' );
			$newMaleStatus = "viril";
		}
		$this->setStatus( $newMaleStatus );
		echo '<i>' . $this->name . ' : OWIIII ma mignonne Ã  la rose</i>';
		echo '<i>' . $femme->name . ' : HOU! grand fou je suis toute retournÃ©e</i>';
	}

}

/****************************
 * une femelle humain
 * Class Woman
 ***************************/
class Woman extends Human {

	public $pregnant = false;

	public function __construct( $complete_name = "Alice" , $status = "vierge" ) {
		$this->name = $complete_name;
		$this->gender = "femme";
		$this->setStatus( $status );
	}

	// tester si la femme est enceinte
	public function isMother() {
		if ( $this->pregnant == true ) {
			return true;
		}
		return false;
	}

}

/***************************
 * lancer le rendu visuel
 **************************/
// c'est sale de mettre autant de echo Ã  la suite
echo "
<!-- doctype html -->
<html>
<head>
<title>Adam et Eve</title>
<meta charset=UTF-8 />
<style>
.container{
margin: 0 auto;
width:60ch;
}
i{
margin: 0.5em 2em 0;
padding: 1em;
background: #ccc;
display: block;
}
i+i{
margin: 0 2em;
}
</style>
</head>
<body>
<div class='container'>";
echo "Bonjour Monde!";
echo "<br/>Vous connaissez la lÃ©gende: au huitiÃ¨me jour, Dieu crÃ©a le Lundi.";
echo "<br/>CrÃ©ons donc Adam le premier homme";
$adam = new Man( "Adam" );
echo "<br/>hop, c'est fait.";
echo "<br/>Allez Adam, dis nous tout.";
$adam->whoAmI();
echo "<br/>Merci mon petit.";
echo "<br/>CrÃ©ons donc Eve la premiÃ¨re femme";
$eve = new Woman( "Eve" );
echo "<br/>hop, c'est fait.";
echo "<br/>Allez Eve, dis nous tout.";
$eve->whoAmI();
echo "<br/>Merci mon petit.";
echo "<br/>Et puis un jour, Adam et Eve ont forniquÃ©.";
echo "<br/>Ici c'est donc Adam qui prend Eve.";
$adam->fuck( $eve );
echo "<br/>hop, c'est fait.";
echo "<br/>Eve est donc comblÃ©e et enceinte.";
$eve->whoAmI();
echo "<br/>Et adam a gagnÃ© en virilitÃ©.";
$adam->whoAmI();
echo "<br/>Mais adam, fort de pulsions animales absolument incontrÃ´lables
ne s'arrÃªte pas lÃ  et va fucker Eve qui est maintenant une maman.
Hors nous savons que les maman sont dÃ©nuÃ©es d'activitÃ© sexuelle";
$adam->fuck( $eve );
echo "<br/>Eve est donc une femme qui ne peut exister.";
$eve->whoAmI();
echo "<br/>Et Adam a gagnÃ© un nouveau statut.";
$adam->whoAmI();
echo "</div>
</body>
</html>
";