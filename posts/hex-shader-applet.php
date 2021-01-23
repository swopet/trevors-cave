<html>
<div><body>
  <canvas id="glCanvas" width="0" height="0"></canvas>
</body>
</div>

<div><input type="file" id="file-selector" accept=".jpg, .jpeg, .png"><p id="widthxheight"></p></div>

<?php 
	function echoSlider($title,$id_base,$min,$max,$ratio,$units,$tooltiptext=null){
		echo "<div>";
		echo "<p>".$title."</p>";
		echo "<input type=\"range\" min=\"".$min*$ratio."\" max=\"".$max*$ratio."\" class=\"slider\" id=\"".$id_base."Input\">";
		echo "<input type=\"text\" id=\"".$id_base."Display\"> ".$units;
		if ($tooltiptext!=null){
			echo "<div class=\"tooltip\">?<span class=\"tooltiptext\">".$tooltiptext."</span></div>";
		}
		echo "</div>";
	}
	echoSlider("Minimum Side Length","minSize",0.1,50.0,10.0,"Pixels");
	echoSlider("Number of Steps","steps",0,10.0,1.0,"Steps","Each step increases side length by a factor of sqrt(3)");
	echo "<div><p>Max Side Length: <span id=\"maxSize\"></span> Pixels</p></div>";
	echoSlider("Line Width","lineWidth",0,20.0,5.0,"Pixels");
	echoSlider("Line Fade","lineFade",0,20.0,5.0,"Pixels");
	echoSlider("Gamma","gamma",0.1,4.0,10.0,"","Determines whether contrast is more visible in darker or brighter areas");
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
	<div class="tooltip">?<span class="tooltiptext">Luminance: <a href="https://en.wikipedia.org/wiki/Relative_luminance" target="_blank">sRGB relative luminance</a><br>Brightness: RGB weighted equally</span></div>
</div>
<div>
    <span>Invert greyscale input
    <input type="checkbox" id="invert">
	<div class="tooltip">?<span class="tooltiptext">Default: Dark=High Density Hexagons<br>Inverted: Light=High Density Hexagons<br>Swapping Color 0 and Color 1 is recommended when this is checked</span></div>
	</span>
    
</div>
<div>
    <span>Refresh on parameter change
    <input type="checkbox" id="refreshToggle">
	<div class="tooltip">?<span class="tooltiptext">Recommend you uncheck this if you have limited graphics capabilities, or if you're using a large image.</span></div>
    </span>
	
    <button id="refreshButton">Refresh</button>
</div>
<div>
    <button onclick="resetToDefaults()">Reset to Defaults</button>
</div>
<div>
	<button onclick="saveImage()">Save Image</button>
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