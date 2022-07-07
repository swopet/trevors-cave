//
// start here
//


const user_image = new Image();
const canvas = document.querySelector("#glCanvas");

class SliderInput{
    constructor(name,default_val,ratio=1){
        this.slider_elt = document.getElementById(name.concat("Input"));
        this.display_elt = document.getElementById(name.concat("Display"));
        this.default_val = default_val;
        this.ratio = ratio;
        this.value = this.slider_elt.value / ratio;
        this.display_elt.value = this.value;
        var self = this;
        this.slider_elt.oninput = function() {
            self.value = this.value/self.ratio;
            self.display_elt.value = self.value;
			if (refreshToggle.checked)
				requestAnimationFrame(draw);
        }
        this.display_elt.oninput = function() {
            var num = parseFloat(this.value);
            if (num === NaN) return;
            self.slider_elt.value = num*self.ratio;
            self.value = num;
			if (refreshToggle.checked)
				requestAnimationFrame(draw);
        }
    }
    reset(){
        this.value = this.default_val;
        this.display_elt.value = this.value;
        this.slider_elt.value = this.value * this.ratio;
    }
};

const minSize = new SliderInput("minSize",6.0,10.0);
const steps = new SliderInput("steps",6);
const lineWidth = new SliderInput("lineWidth",2.0,5.0);
const lineFade = new SliderInput("lineFade",12.0,5.0);
const gamma = new SliderInput("gamma",1.0,10.0);
const gaussianBlur = new SliderInput("gaussianBlur",5);
const color0 = document.getElementById("color0");
const color1 = document.getElementById("color1");
const control = document.getElementById("control");
const invert = document.getElementById("invert");
const refreshToggle = document.getElementById("refreshToggle");
const refreshButton = document.getElementById("refreshButton");
var hex_program;
var user_image_tex = null;
// Initialize the GL context
var blur_buffer_0_texture = null;
var blur_buffer_0_fb = null;
var blur_buffer_1_texture = null;
var blur_buffer_1_fb = null;
var hex_texture = null;
var hex_fb = null;
var gl;
main();

function create_frame_buffer(){
	const texture = gl.createTexture();
	gl.bindTexture(gl.TEXTURE_2D, texture);
	{
		const level = 0;
		const internalFormat = gl.RGBA;
		const width = user_image.width;
		const height = user_image.height;
		const border = 0;
		const format = gl.RGBA;
		const type = gl.UNSIGNED_BYTE;
		gl.texImage2D(gl.TEXTURE_2D, level, internalFormat,
					  width, height, border,
					  format, type, null);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
	}
	const fb = gl.createFramebuffer();
	gl.bindFramebuffer(gl.FRAMEBUFFER, fb);
	const attachmentPoint = gl.COLOR_ATTACHMENT0;
	const level = 0;
	gl.framebufferTexture2D(gl.FRAMEBUFFER, attachmentPoint, gl.TEXTURE_2D, texture, level);
	return {fb, texture};
}

function initializeBlurAndHexBuffers(){
	if (blur_buffer_0_texture != null){
		gl.deleteTexture(blur_buffer_0_texture);
		blur_buffer_0_texture = null;
	}
	if (blur_buffer_0_fb != null){
		gl.deleteFramebuffer(blur_buffer_0_fb);
		blur_buffer_0_fb = null;
	}
	if (blur_buffer_1_texture != null){
		gl.deleteTexture(blur_buffer_1_texture);
		blur_buffer_1_texture = null;
	}
	if (blur_buffer_1_fb != null){
		gl.deleteFramebuffer(blur_buffer_1_fb);
		blur_buffer_1_fb = null;
	}
	let buffer_0 = create_frame_buffer();
	blur_buffer_0_texture = buffer_0.texture;
	blur_buffer_0_fb = buffer_0.fb;
	let buffer_1 = create_frame_buffer();
	blur_buffer_1_texture = buffer_1.texture;
	blur_buffer_1_fb = buffer_1.fb;
	let hex_buffer = create_frame_buffer();
	hex_texture = hex_buffer.texture;
	hex_fb = hex_buffer.fb;
}

function resetToDefaults() {
    minSize.reset();
    steps.reset();
    lineWidth.reset();
    lineFade.reset();
	gamma.reset();
	gaussianBlur.reset();
    color0.value = 3;
    color1.value = 0;
    control.value = 1;
    invert.checked = true;
	refreshToggle.checked = true;
	refreshButton.style.display = "none";
	requestAnimationFrame(draw);
}

function applyBlur(texture,fb,dimension,blur_radius,width,height){
  gl.useProgram(blur_program);
  gl.bindFramebuffer(gl.FRAMEBUFFER,fb);
  gl.clearColor(0.0,0.0,1.0,1.0);
  gl.clear(gl.COLOR_BUFFER_BIT);
  
  //lookup uniforms in vert shader
  var positionLocation = gl.getAttribLocation(blur_program, "a_position");
  var texcoordLocation = gl.getAttribLocation(blur_program, "a_texCoord");
  var resolutionLocation = gl.getUniformLocation(blur_program, "u_resolution");
  
  // lookup uniforms for frag shader
  var iResolutionLocation = gl.getUniformLocation(blur_program, "iResolution");
  var dimensionLocation = gl.getUniformLocation(blur_program, "dimension");
  var radiusLocation = gl.getUniformLocation(blur_program, "radius");
  
  var positionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
  setRectangle(gl, 0, 0, width, height);
  // provide texture coordinates for the rectangle.
	var texcoordBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
	  0.0,  0.0,
	  1.0,  0.0,
	  0.0,  1.0,
	  0.0,  1.0,
	  1.0,  0.0,
	  1.0,  1.0,
	]), gl.STATIC_DRAW);
	gl.activeTexture(gl.TEXTURE0);
	gl.bindTexture(gl.TEXTURE_2D, texture);
	gl.viewport(0,0,width,height);
    // Turn on the position attribute
	gl.enableVertexAttribArray(positionLocation);

	// Bind the position buffer.
	gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);

	// Tell the position attribute how to get data out of positionBuffer (ARRAY_BUFFER)
	var size = 2;          // 2 components per iteration
	var type = gl.FLOAT;   // the data is 32bit floats
	var normalize = false; // don't normalize the data
	var stride = 0;        // 0 = move forward size * sizeof(type) each iteration to get the next position
	var offset = 0;        // start at the beginning of the buffer
	gl.vertexAttribPointer(
	  positionLocation, size, type, normalize, stride, offset);

	// Turn on the texcoord attribute
	gl.enableVertexAttribArray(texcoordLocation);

	// bind the texcoord buffer.
	gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);

	// Tell the texcoord attribute how to get data out of texcoordBuffer (ARRAY_BUFFER)
	var size = 2;          // 2 components per iteration
	var type = gl.FLOAT;   // the data is 32bit floats
	var normalize = false; // don't normalize the data
	var stride = 0;        // 0 = move forward size * sizeof(type) each iteration to get the next position
	var offset = 0;        // start at the beginning of the buffer
	gl.vertexAttribPointer(
	  texcoordLocation, size, type, normalize, stride, offset);

	// set the resolution in vert
	gl.uniform2f(resolutionLocation, width, height);
	
	gl.uniform2f(iResolutionLocation, width, height);
	gl.uniform1i(dimensionLocation, dimension);
	gl.uniform1f(radiusLocation, blur_radius);
	
	var primitiveType = gl.TRIANGLES;
	var offset = 0;
	var count = 6;
	gl.drawArrays(primitiveType, offset, count);
}

function loadSourceTexture(gl, url) {
  const texture = gl.createTexture();
  gl.activeTexture(gl.TEXTURE0);
  gl.bindTexture(gl.TEXTURE_2D, texture);

  // Because images have to be downloaded over the internet
  // they might take a moment until they are ready.
  // Until then put a single pixel in the texture so we can
  // use it immediately. When the image has finished downloading
  // we'll update the texture with the contents of the image.
  const level = 0;
  const internalFormat = gl.RGBA;
  const width = 1;
  const height = 1;
  const border = 0;
  const srcFormat = gl.RGBA;
  const srcType = gl.UNSIGNED_BYTE;

  user_image.onload = function() {
	gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texImage2D(gl.TEXTURE_2D, level, internalFormat,
                  srcFormat, srcType, user_image);
    
    // WebGL1 has different requirements for power of 2 images
    // vs non power of 2 images so check if the image is a
    // power of 2 in both dimensions.
	setCanvasSize();
    if (isPowerOf2(user_image.width) && isPowerOf2(user_image.height)) {
       // Yes, it's a power of 2. Generate mips.
       gl.generateMipmap(gl.TEXTURE_2D);
    } else {
       // No, it's not a power of 2. Turn off mips and set
       // wrapping to clamp to edge
       gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
       gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
       gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    }
	initializeBlurAndHexBuffers();
    document.getElementById("widthxheight").innerHTML = String(user_image.width).concat("x").concat(String(user_image.height));
    requestAnimationFrame(draw);
  };
  user_image.src = url;

  return texture;
}

function setCanvasSize(){
	if (user_image.width !== 0){
		canvas.width = Math.min(user_image.width,document.body.clientWidth-20);
		canvas.height = user_image.height * canvas.width / user_image.width;
	}
}
function isPowerOf2(value) {
  return (value & (value - 1)) == 0;
}



function saveImage() {
  if (canvas.width === 0) return;
  drawHexes(applyBlurStack(),hex_fb);
  gl.bindFramebuffer(gl.FRAMEBUFFER,hex_fb);
  var data = new Uint8Array(user_image.width * user_image.height * 4);
  gl.readPixels(0, 0, user_image.width, user_image.height, gl.RGBA, gl.UNSIGNED_BYTE, data);
  var temp_canvas = document.createElement('canvas');
  temp_canvas.width = user_image.width;
  temp_canvas.height = user_image.height;
  var context = temp_canvas.getContext('2d');
  var imageData = context.createImageData(temp_canvas.width, temp_canvas.height);
  imageData.data.set(data);
  context.putImageData(imageData,0,0);
  let downloadLink = document.createElement('a');
  downloadLink.setAttribute('download', 'hexed_image.png');
  let dataURL = temp_canvas.toDataURL('image/png');
  let url = dataURL.replace(/^data:image\/png/,'data:application/octet-stream');
  downloadLink.setAttribute('href', url);
  downloadLink.click();
}

function applyBlurStack() {
	var source_tex;
	var blur_radius = Math.floor(gaussianBlur.value);
	if (blur_radius > 0){
		applyBlur(user_image_tex,blur_buffer_0_fb,0,blur_radius,user_image.width,user_image.height);
		applyBlur(blur_buffer_0_texture,blur_buffer_1_fb,1,blur_radius,user_image.width,user_image.height);
		source_tex = blur_buffer_1_texture;
	}
	else source_tex = user_image_tex;
	return source_tex;
}

function drawHexes(source_tex,fb) {
	gl.bindFramebuffer(gl.FRAMEBUFFER,fb);
	gl.useProgram(hex_program);
	// Set clear color to black, fully opaque
	gl.clearColor(0.0, 0.0, 0.0, 1.0);
	// Clear the color buffer with specified clear color
	gl.clear(gl.COLOR_BUFFER_BIT);
	// look up where the vertex data needs to go.
	var positionLocation = gl.getAttribLocation(hex_program, "a_position");
	var texcoordLocation = gl.getAttribLocation(hex_program, "a_texCoord");

	// Create a buffer to put three 2d clip space points in
	var positionBuffer = gl.createBuffer();

	// Bind it to ARRAY_BUFFER (think of it as ARRAY_BUFFER = positionBuffer)
	gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
	// Set a rectangle the same size as the image.
	setRectangle(gl, 0, 0, user_image.width, user_image.height);

	// provide texture coordinates for the rectangle.
	var texcoordBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
	  0.0,  0.0,
	  1.0,  0.0,
	  0.0,  1.0,
	  0.0,  1.0,
	  1.0,  0.0,
	  1.0,  1.0,
	]), gl.STATIC_DRAW);
	gl.activeTexture(gl.TEXTURE0);
	gl.bindTexture(gl.TEXTURE_2D, source_tex);
	gl.activeTexture(gl.TEXTURE1);
	gl.bindTexture(gl.TEXTURE_2D, user_image_tex);

	// lookup uniforms
	var resolutionLocation = gl.getUniformLocation(hex_program, "u_resolution");
	var iResolutionLocation = gl.getUniformLocation(hex_program, "iResolution");
	var minSizeLocation = gl.getUniformLocation(hex_program, "minSize");
	var stepsLocation = gl.getUniformLocation(hex_program, "steps");
	var lineWidthLocation = gl.getUniformLocation(hex_program, "lineWidth");
	var lineFadeLocation = gl.getUniformLocation(hex_program, "lineFade");
	var color0Location = gl.getUniformLocation(hex_program, "color0");
	var color1Location = gl.getUniformLocation(hex_program, "color1");
	var controlLocation = gl.getUniformLocation(hex_program, "control");
	var invertLocation = gl.getUniformLocation(hex_program, "invert");
	var gammaLocation = gl.getUniformLocation(hex_program, "gamma");
	// Tell WebGL how to convert from clip space to pixels
	gl.viewport(0, 0, user_image.width, user_image.height);
	var uimageLocation = gl.getUniformLocation(hex_program, "u_image");
	var uimage1Location = gl.getUniformLocation(hex_program, "u_image1");
	// Turn on the position attribute
	gl.enableVertexAttribArray(positionLocation);

	// Bind the position buffer.
	gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);

	// Tell the position attribute how to get data out of positionBuffer (ARRAY_BUFFER)
	var size = 2;          // 2 components per iteration
	var type = gl.FLOAT;   // the data is 32bit floats
	var normalize = false; // don't normalize the data
	var stride = 0;        // 0 = move forward size * sizeof(type) each iteration to get the next position
	var offset = 0;        // start at the beginning of the buffer
	gl.vertexAttribPointer(
	  positionLocation, size, type, normalize, stride, offset);

	// Turn on the texcoord attribute
	gl.enableVertexAttribArray(texcoordLocation);

	// bind the texcoord buffer.
	gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);

	// Tell the texcoord attribute how to get data out of texcoordBuffer (ARRAY_BUFFER)
	var size = 2;          // 2 components per iteration
	var type = gl.FLOAT;   // the data is 32bit floats
	var normalize = false; // don't normalize the data
	var stride = 0;        // 0 = move forward size * sizeof(type) each iteration to get the next position
	var offset = 0;        // start at the beginning of the buffer
	gl.vertexAttribPointer(
	  texcoordLocation, size, type, normalize, stride, offset);

	// set the textures
	gl.uniform1i(uimageLocation,0);
	gl.uniform1i(uimage1Location,1);

	// set the resolution
	gl.uniform2f(resolutionLocation, user_image.width, user_image.height);
	// set the image resolution
	gl.uniform2f(iResolutionLocation, user_image.width, user_image.height);
	//set the minimum hex side length
	gl.uniform1f(minSizeLocation, minSize.value);
	//set the number of steps
	gl.uniform1f(stepsLocation, steps.value);
	//set the line width and line fade
	gl.uniform1f(lineWidthLocation, lineWidth.value);
	gl.uniform1f(lineFadeLocation, lineFade.value);
	//set the gamma
	gl.uniform1f(gammaLocation, gamma.value);
	//set the two colors and fade parameters
	gl.uniform1i(color0Location, color0.value);
	gl.uniform1i(color1Location, color1.value);
	gl.uniform1i(controlLocation, control.value);
	gl.uniform1i(invertLocation, invert.checked ? 1 : 0);
	// Draw the rectangle.
	var primitiveType = gl.TRIANGLES;
	var offset = 0;
	var count = 6;
	gl.drawArrays(primitiveType, offset, count);
}

function drawToCanvas() {
	
	var source_tex = applyBlurStack();
	drawHexes(source_tex,hex_fb);
	//we use applyBlur because I didn't want to write the empty shader lol
	applyBlur(hex_texture,null,2,0,canvas.width,canvas.height);
}

function draw() {
      if (user_image_tex !== null)
	  {
		  drawToCanvas();
      }
}

function setRectangle(gl, x, y, width, height) {
  var x1 = x;
  var x2 = x + width;
  var y1 = y;
  var y2 = y + height;
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
     x1, y1,
     x2, y1,
     x1, y2,
     x1, y2,
     x2, y1,
     x2, y2,
  ]), gl.STATIC_DRAW);
}

function init() {
	
  gl = canvas.getContext("webgl");
  hex_program = webglUtils.createProgramFromScripts(gl, ["vertex-shader-2d", "hex-fragment-shader-2d"]);
  blur_program = webglUtils.createProgramFromScripts(gl, ["vertex-shader-2d", "blur-fragment-shader-2d"]);
  resetToDefaults();
  refreshToggle.oninput = function() {
      refreshButton.style.display = refreshToggle.checked ? "none" : "inline-block";
      if (refreshToggle.checked) requestAnimationFrame(draw);
  }
  refreshButton.onclick = function() {
      requestAnimationFrame(draw);
  }
  color0.onchange = function() {
	  if (refreshToggle.checked)
				requestAnimationFrame(draw);
  }
  color1.onchange = function() {
	  if (refreshToggle.checked)
				requestAnimationFrame(draw);
  }
  control.onchange = function() {
	  if (refreshToggle.checked)
				requestAnimationFrame(draw);
  }
  invert.onchange = function() {
	  if (refreshToggle.checked)
				requestAnimationFrame(draw);
  }
  document.body.onresize = function() {
	  setCanvasSize();
	  requestAnimationFrame(draw);
  }
}

function main() {
  init();
  const fileSelector = document.getElementById('file-selector');
  fileSelector.value = null;
  fileSelector.addEventListener('change', (event) => {
    const fileList = event.target.files;
    readImage(event.target.files[0],user_image);
  });
  user_image_tex = loadSourceTexture(gl,"../images/meadow.jpg");
  
  

  // Only continue if WebGL is available and working
  if (gl === null) {
    alert("Unable to initialize WebGL. Your browser or machine may not support it.");
    return;
  }
  requestAnimationFrame(draw);
}

function readImage(file,out_img) {
  // Check if the file is an image.
  if (file.type && file.type.indexOf('image') === -1) {
    console.log('File is not an image.', file.type, file);
    return;
  }

  const reader = new FileReader();
  reader.addEventListener('load', (event) => {
    out_img.src = event.target.result;
	user_image_tex = loadSourceTexture(gl,user_image.src);
  });
  reader.readAsDataURL(file);
}

window.onload = main;