<html>
<div><body>
  <canvas id="glCanvas" width="0" height="0"></canvas>
</body>
</div>

<div><input type="file" id="file-selector" accept=".jpg, .jpeg, .png"><p id="widthxheight"></p></div>

<?php 
	function echoSlider($title,$id_base,$min,$max,$ratio,$units){
		echo "<div>";
		echo "<p>".$title."</p>";
		echo "<input type=\"range\" min=\"".$min*$ratio."\" max=\"".$max*$ratio."\" class=\"slider\" id=\"".$id_base."Input\">";
		echo "<input type=\"text\" id=\"".$id_base."Display\"> ".$units;
		echo "</div>";
	}
	echoSlider("Minimum Side Length","minSize",0.1,50.0,10.0,"Pixels");
	echoSlider("Number of Steps","steps",0,10.0,1.0,"Steps");
	echoSlider("Line Width","lineWidth",0,20.0,5.0,"Pixels");
	echoSlider("Line Fade","lineFade",0,20.0,5.0,"Pixels");
	echoSlider("Gamma","gamma",0.1,4.0,10.0,"");
?>

<div>
    <label for="color0">Color 0</label>
    <select name="color0" id="color0">
        <option value=0>Black</option>
        <option value=1>White</option>
        <option value=2>Original Color</option>
    </select>
</div>
<div>
    <label for="color1">Color 1</label>
    <select name="color1" id="color1">
        <option value=0>Black</option>
        <option value=1>White</option>
        <option value=2>Original Color</option>
    </select>
</div>
<div>
    <label for="control">Greyscale Calc</label>
    <select name="control" id="control">
        <option value=0>Luminance</option>
        <option value=1>Brightness</option>
    </select>
</div>
<div>
    <p>Invert greyscale input?
    <input type="checkbox" id="invert"></input>
    </p>
</div>
<div>
    <p>Refresh on parameter change?
    <input type="checkbox" id="refreshToggle"></input>
    </p>
    <button id="refreshButton">Refresh</button>
</div>
<div>
    <button onclick="resetToDefaults()">Reset to Defaults</button>
</div>

<?php
	//Load shaders and javascript for the page
	echo "<script  id=\"vertex-shader-2d\" type=\"notjs\">";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/vert_shader.txt");
	echo "</script>";
	echo "<script id=\"fragment-shader-2d\" type=\"x-shader/x-fragment\">";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/hex_frag_shader.txt");
	echo "</script>";
	echo "<script>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/webgl-utils.js");
	echo "</script>";
	echo "<script>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/hex_shader_applet.js");
	echo "</script>";
?>
</html>