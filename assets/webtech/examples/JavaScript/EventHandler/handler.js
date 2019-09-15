var over = 0;

function mouseover() {
	var text = document.createTextNode("Ihr " + ++over + " Mouse over! ");
	document.getElementById("miracle").appendChild(text);
	br = document.createElement("br");
	document.getElementById("miracle").appendChild(br);
}