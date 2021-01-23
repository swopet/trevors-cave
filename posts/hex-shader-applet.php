<html>
<div><body>
  <canvas id="glCanvas" width="0" height="0"></canvas>
</body>
</div>

<div><input type="file" id="file-selector" accept=".jpg, .jpeg, .png"><p id="widthxheight"></p></div>
<div>
    <p>Minimum side length</p>
    <input type="range" min="1" max="1000" class="slider" id="minSizeInput" >
    <input type="text" id="minSizeDisplay"></span> Pixels
</div>
<div>
    <p>Number of steps</p>
    <input type="range" min="0" max="10" class="slider" id="stepsInput" >
    <input type="text" id="stepsDisplay"></span> Steps
</div>
<div>
    <p>Line width</p>
    <input type="range" min="0" max="100" class="slider" id="lineWidthInput" >
    <input type="text" id="lineWidthDisplay"></span> Pixels
</div>
<div>
    <p>Line fade</p>
    <input type="range" min="0" max="100" class="slider" id="lineFadeInput" >
    <input type="text" id="lineFadeDisplay"></span> Pixels
</div>
<div>
    <p>Gamma</p>
    <input type="range" min="0" max="40" class="slider" id="gammaInput" >
    <input type="text" id="gammaDisplay"></span>
</div>
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