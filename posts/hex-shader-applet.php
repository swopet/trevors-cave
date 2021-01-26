<html>
<body>
<div class="canvascontainer">
<canvas id="glCanvas" width="0" height="0" class="shadercanvas"></canvas>
</div>

<div class="inputcontainer">
<input type="file" id="file-selector" accept=".jpg, .jpeg, .png" class="fileselector"></input>
<div style="text-align:center" id="widthxheight"></div>
</div>

<?php 
	function echoSlider($title,$id_base,$min,$max,$ratio,$units,$tooltiptext=null){
		echo "<div class=\"inputcontainer\">";
		echo "<div class=\"inputlabel\">".$title."</div>";
		echo "<input type=\"range\" min=\"".$min*$ratio."\" max=\"".$max*$ratio."\" class=\"slider\" id=\"".$id_base."Input\">";
		echo "<input type=\"text\" id=\"".$id_base."Display\" class=\"sliderdisplay\"> ".$units;
		if ($tooltiptext!=null){
			echo "<div class=\"tooltip\">?<span class=\"tooltiptext\">".$tooltiptext."</span></div>";
		}
		echo "</div>";
	}
	echoSlider("Minimum Side Length","minSize",0.1,50.0,10.0,"Pixels");
	echoSlider("Number of Steps","steps",0,10.0,1.0,"Steps","Each step increases side length by a factor of sqrt(3)");
	echoSlider("Line Width","lineWidth",0,20.0,5.0,"Pixels");
	echoSlider("Line Fade","lineFade",0,20.0,5.0,"Pixels");
	echoSlider("Gamma","gamma",0.1,4.0,10.0,"","Determines whether contrast is more visible in darker or brighter areas");
	echoSlider("Blur Radius","gaussianBlur",0,10,1.0,"Pixels","Convolves the source image with a gaussian blur kernel with the given radius in both dimensions");
?>

<div class="inputcontainer">
    <div class="inputlabel">Color 0</div>
    <select class="inputselect" name="color0" id="color0">
        <option value=0>Black</option>
        <option value=1>White</option>
        <option value=2>Source Color</option>
		<option value=3>Original Color (no blur)</option>
    </select>
	
</div>
<div class="inputcontainer">
    <div class="inputlabel">Color 1</div>
    <select class="inputselect" name="color1" id="color1">
        <option value=0>Black</option>
        <option value=1>White</option>
        <option value=2>Source Color</option>
		<option value=3>Original Color (no blur)</option>
    </select>
	
</div>
<div class="inputcontainer">
    <div class="inputlabel">Greyscale Calc</div>
    <select class="inputselect" name="greyscale" id="control">
        <option value=0>Luminance</option>
        <option value=1>Brightness</option>
    </select>
	<div class="tooltip">?<span class="tooltiptext">Luminance: <a href="https://en.wikipedia.org/wiki/Relative_luminance" target="_blank">sRGB relative luminance</a><br>Brightness: RGB weighted equally</span></div>
</div>
<div class="inputcontainer">
    <div class="inputlabel">Invert greyscale input</div>
    <input type="checkbox" id="invert">
	<div class="tooltip">?<span class="tooltiptext">Default: Dark=High Density Hexagons<br>Inverted: Light=High Density Hexagons<br>Swapping Color 0 and Color 1 is recommended when this is checked</span></div>
</div>
<div class="inputcontainer">
    <div class="inputlabel">Refresh on parameter change</div>
    <input type="checkbox" id="refreshToggle">
	<div class="tooltip">?<span class="tooltiptext">Recommend you uncheck this if you have limited graphics capabilities, or if you're using a large image.</span></div>
    
</div>
<div class="inputcontainer">
	<div style="text-align:center">
	<button id="refreshButton">Refresh</button>
    <button onclick="resetToDefaults()">Reset to Defaults</button>
	<button onclick="saveImage()">Save Image</button>
	</div>
</div>
</body>
<?php
	//Load shaders and javascript for the page
	echo "<script  id=\"vertex-shader-2d\" type=\"notjs\">";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/vert_shader.txt");
	echo "</script>";
	echo "<script id=\"hex-fragment-shader-2d\" type=\"x-shader/x-fragment\">";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/hex_frag_shader.txt");
	echo "</script>";
	echo "<script id=\"blur-fragment-shader-2d\" type=\"x-shader/x-fragment\">";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/gaussian_blur_shader.txt");
	echo "</script>";
	echo "<script>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/webgl-utils.js");
	echo "</script>";
	echo "<script>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/hex_shader_applet.js");
	echo "</script>";
?>
</html>