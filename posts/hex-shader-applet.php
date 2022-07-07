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
		echoSlider("Minimum Side Length","minSize",0.1,50.0,10.0,"Pixels");
		echoSlider("Number of Steps","steps",0,10.0,1.0,"Steps","Each step increases side length by a factor of &radic;3");
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
		<?php echoTooltip("Luminance: <a href=\"https://en.wikipedia.org/wiki/Relative_luminance\" target=\"_blank\">sRGB relative luminance</a><br>Brightness: RGB weighted equally",true); ?>
	</div>
	<div class="inputcontainer">
		<div class="inputlabel">Invert greyscale input</div>
		<input type="checkbox" id="invert">
		<?php echoTooltip("Default: Dark=Denser Hexagons<br>Inverted: Light=Denser Hexagons<br>Recommend swapping Color 0 and Color 1 if checked",true); ?>
	</div>
	<div class="inputcontainer">
		<div class="inputlabel">Refresh on parameter change</div>
		<input type="checkbox" id="refreshToggle">
		<?php echoTooltip("Recommend you uncheck this if you have limited graphics capabilities, or if you are using a large image",true); ?>
		
	</div>
	<div class="inputcontainer">
		<div style="text-align:center">
		<button id="refreshButton">Refresh</button>
		<button onclick="resetToDefaults()">Reset to Defaults</button>
		<button onclick="saveImage()">Save Image</button>
		</div>
	</div>
	<p>This is a fun tool I made that convolves a source image with a hex-grid dithering shader I wrote. Try loading an image, playing with the parameters and see what you come up with! All the image processing is done in a few shaders in client-side WebGL, so don't worry about me stealing your images or anything.</p>
	<h3>Explanation</h3>
	<h4>Tesselation</h4>
	<p>To break down a hexagon grid to a tesselating pattern, I draw, on each hexagon on the grid, a line from every other vertex to the center.</p>
	<figure>
		<img src="images/hex_tesselation.gif" class="figure-img img-fluid" alt="A GIF shows how lines are drawn from the center of each hexagon to every other corner.">
		<figcaption class="figure-caption">Basic hexagon tesselation</figcaption>
	</figure>
	<h4>Density Transition</h4>
	<p>To transition from one density level to the next, each hexagon vertex where three lines meet expands to form a hexagon. At the same time, each line splits to two other lines, which rotate away from each other. When the transformation is complete, the resulting hexagon grid has smaller side length by a factor of &radic;3</p>
	<figure>
		<img src="images/hex_tesselation_split_step_1.gif" class="figure-img img-fluid" alt="A GIF shows how one hexagon grid is transformed into a denser hexagon grid.">
		<figcaption class="figure-caption">Hexagon tesselation transitions 1 (one) step of density</figcaption>
	</figure>
	<h4>Steps</h4>
	<p>For a given pixel, we index to the step of density required by the input greyscale value, performing the necessary transformations to position it correctly relative to the previous step of density. The "Steps" parameter controls the number of steps through which the filter passes on its way from its lowest density to its highest density.</p>
	<figure>
		<img src="images/hex_tesselation_split_step_4.gif" class="figure-img img-fluid" alt="A GIF shows how one hexagon grid is transformed stepwise over 4 steps of density.">
		<figcaption class="figure-caption">Hexagon tesselation transitions through 4 (four) steps of density</figcaption>
	</figure>
	<h4>Blur</h4>
	<p>Since the convolution is 'continuous' (not in a strict mathematical sense), we get smooth transitions across input values. However, most source images are not necessarily smooth pixel-to-pixel. It's a stylistic choice, but applying a Gaussian blur to the image prior to convolving it with the hexagon density function gets rid of most pixelation of the source image. However, sometimes it can look better to include those artifacts, or keep the blur radius small.</p>
	<figure>
		<img src="images/hex_tesselation_blur.gif" class="figure-img img-fluid" alt="A GIF shows how blurring the source image smooths out the density transitions.">
		<figcaption class="figure-caption">Increased blur smooths out density transitions</figcaption>
	</figure>
	<h4>Gamma</h4>
	<p>Raising the incoming greyscale value (normalized from 0 to 1) to some gamma value gives us control over whether contrast is highlighted more on dark parts or light parts of the image.</p>
	<figure>
		<img src="images/hex_tesselation_gamma.gif" class="figure-img img-fluid" alt="A GIF shows how applying an exponentation to the source value changes contrast behavior.">
		<figcaption class="figure-caption">Gamma changes from 0.45 to 1.65</figcaption>
	</figure>
	<h4>Appearance</h4>
	<p>Finally, I added controls to invert the incoming greyscale value, swap which colors are used for the lines and hexagons, and change the thickness and width of the lines. These parameters should be relatively self-explanatory as soon as you play with the sliders :)</p>
	<p>Many thanks to Red Blob Games for their <a href="https://www.redblobgames.com/grids/hexagons/" target="_blank"> write-up on axial coordinate systems</a>, without which this whole thing would have taken me ages to figure out. Thanks also to <a href="https://webglfundamentals.org/" target="_blank">WebGLFundamentals</a> for their tutorials on using WebGL. Great for anyone with experience in OpenGL like me, or really anyone interested in in-browser rendering with WebGL.</p>
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
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/vert_shader.txt");
	echo "</script>";
	echo "<script id='hex-fragment-shader-2d' type='x-shader/x-fragment'>";
	include_once($_SERVER['DOCUMENT_ROOT']."/../posts/hex_shader_code/hex_frag_shader.txt");
	echo "</script>";
	echo "<script id='blur-fragment-shader-2d' type='x-shader/x-fragment'>";
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