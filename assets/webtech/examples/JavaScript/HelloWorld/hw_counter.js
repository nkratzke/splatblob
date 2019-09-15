var klick = 0;

function hello_world_counter() {
	var text = document.createTextNode("Ihr " + ++klick + "ter Klick! ");
	document.getElementById("miracle").appendChild(text);
	br = document.createElement("br");
	document.getElementById("miracle").appendChild(br);
}