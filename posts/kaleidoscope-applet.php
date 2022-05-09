<html>
<body>
<div class="canvascontainer">
<canvas id="glCanvas" width="0" height="0" class="shadercanvas"></canvas>
</div>

<div class="postcontainer">
	<div class="inputcontainer">
	<input type="file" id="file-selector" accept=".jpg, .jpeg, .png" class="fileselector"></input>
	<div style="text-align:center" id="widthxheight"></div>
	</div>

	<?php
		function echoTooltip($tooltiptext=null,$use_html=false){
			echo "<button type='button' class='btn btn-sm btn-info' data-toggle='tooltip' data-placement='top'"
			.(($use_html) ? "data-html='true'": "")
			." title='".$tooltiptext."'>?</button>";
		}
		function echoSlider($title,$id_base,$min,$max,$ratio,$units,$tooltiptext=null){
			echo "<div class='inputcontainer'>";
			echo "<div class='inputlabel'>".$title."</div>";
			echo "<input type='range' min='".$min*$ratio."' max='".$max*$ratio."' class='slider' id='".$id_base."Input'>";
			echo "<input type='text' id='".$id_base."Display' class='sliderdisplay'> ".$units;
			if ($tooltiptext!=null){
				echoTooltip($tooltiptext,true);
			}
			echo "</div>";
		}
        echoSlider("Output Resolution Width","resolutionX",1,1920,1,"Pixels");
        echoSlider("Output Resolution Height","resolutionY",1,1080,1,"Pixels");
        echoSlider("Sample Origin X","originX",0,1.0,1000.0,"");
        echoSlider("Sample Origin Y","originY",0,1.0,1000.0,"");
        echoSlider("Kaleidoscope Center X","centerX",0,1.0,1000.0,"");
        echoSlider("Kaleidoscope Center Y","centerY",0,1.0,1000.0,"");
        echoSlider("Zoom","zoom",0.1,5.0,10.0,"");
        echoSlider("Reflections","reflections",1,360,1,"");
        echoSlider("Rotation","rotation",0,360,1,"Degrees");
	?>

	<!--<div class="inputcontainer">
		<div class="inputlabel">Sample Method</div>
		<select class="inputselect" name="sampleMethod" id="sampleMethod">
			<option value=0>Nearest Neighbor</option>
			<option value=1>Bilinear Interpolation</option>
			<option value=2>Average Nearest 4</option>
			<option value=3>Average Nearest 16</option>
            <option value=4>Cubic Convolution</option>
		</select>
	</div>-->
	<div class="inputcontainer">
		<div class="inputlabel">Refresh on parameter change</div>
		<input type="checkbox" id="refreshToggle">
		<?php echoTooltip("Recommend you uncheck this if you have limited graphics capabilities, or if you're using a large image",true); ?>
		
	</div>
	<div class="inputcontainer">
		<div style="text-align:center">
		<button id="refreshButton">Refresh</button>
		<button onclick="resetToDefaults()">Reset to Defaults</button>
		<button onclick="saveImage()">Save Image</button>
		</div>
	</div>
	<p>This is a tool for taking an input image and kaleidoscoping it, originally written for my mom but published here for ease of use!</p>
	<h3>Instructions</h3>
    <p>Note that all sliders can be manually set to values outside of their default ranges, but behavior is undefined!</p>
	<h4>Output Resolution</h4>
	<p>The output resolution sliders determine the size of the output image when you click "Save Image". The image shown on the canvas is just a scaled preview. The shader uses bilinear interpolation to sample the original texture, so unless your output resolution is significantly different than the original resolution, or the zoom level is set to an extreme, there should not be significant pixellation or blurriness in the final image.</p>
    <h4>Sample Origin</h4>
    <p>Ranging from 0 to 1, the coordinate of the center of the slice taken out of the original image to be reflected.</p>
    <h4>Kaleidoscope Center</h4>
    <p>Ranging from 0 to 1, the coordinate of the center of the reflection on the final image.</p>
</div>
</body>
<script>
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})
</script>
<?php
	//Load shaders and javascript for the page
	echo "<script  id='vertex-shader-2d' type='notjs'>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/kaleidoscope_shader_code/vert_shader.txt");
	echo "</script>";
	echo "<script id='kaleidoscope-fragment-shader-2d' type='x-shader/x-fragment'>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/kaleidoscope_shader_code/kaleidoscope_frag_shader.txt");
	echo "</script>";
	echo "<script>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/kaleidoscope_shader_code/webgl-utils.js");
	echo "</script>";
	echo "<script>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/kaleidoscope_shader_code/kaleidoscope_shader_applet.js");
	echo "</script>";
?>
</html>