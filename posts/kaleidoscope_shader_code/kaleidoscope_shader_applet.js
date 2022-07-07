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
			if (refreshToggle.checked){
                setCanvasSize();
				requestAnimationFrame(draw);
            }
        }
        this.display_elt.oninput = function() {
            var num = parseFloat(this.value);
            if (num === NaN) return;
            self.slider_elt.value = num*self.ratio;
            self.value = num;
			if (refreshToggle.checked){
                setCanvasSize();
				requestAnimationFrame(draw);
            }
        }
    }
    reset(){
        this.value = this.default_val;
        this.display_elt.value = this.value;
        this.slider_elt.value = this.value * this.ratio;
    }
};

const outResolutionX = new SliderInput("resolutionX",1280);
const outResolutionY = new SliderInput("resolutionY",960);
const originX = new SliderInput("originX",0.75,1000.0);
const originY = new SliderInput("originY",0.75,1000.0);
const centerX = new SliderInput("centerX",0.5,1000.0);
const centerY = new SliderInput("centerY",0.5,1000.0);
const zoom = new SliderInput("zoom",1.0,10.0);
const reflections = new SliderInput("reflections",5);
const rotation = new SliderInput("rotation",45);
const refreshToggle = document.getElementById("refreshToggle");
const refreshButton = document.getElementById("refreshButton");
var kaleidoscope_program;
var user_image_tex = null;
var kaleidoscope_texture = null;
var kaleidoscope_fb = null;
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

function initializeKaleidoscopeBuffer(){
	let kaleidoscope_buffer = create_frame_buffer();
	kaleidoscope_texture = kaleidoscope_buffer.texture;
	kaleidoscope_fb = kaleidoscope_buffer.fb;
}

function resetToDefaults() {
    outResolutionX.reset();
    outResolutionY.reset();
    originX.reset();
    originY.reset();
    centerX.reset();
    centerY.reset();
    zoom.reset();
    reflections.reset();
    rotation.reset();
	refreshToggle.checked = true;
	refreshButton.style.display = "none";
	requestAnimationFrame(draw);
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
	initializeKaleidoscopeBuffer();
    document.getElementById("widthxheight").innerHTML = String(user_image.width).concat("x").concat(String(user_image.height));
    requestAnimationFrame(draw);
  };
  user_image.src = url;

  return texture;
}

function setCanvasSize(){
	if (user_image.width !== 0){
		canvas.width = Math.min(640,document.body.clientWidth-20);
		canvas.height = outResolutionY.value * canvas.width / outResolutionX.value;
	}
}
function isPowerOf2(value) {
  return (value & (value - 1)) == 0;
}



function saveImage() {
  if (canvas.width === 0) return;
  drawKaleidoscope(user_image_tex,kaleidoscope_fb,outResolutionX.value,outResolutionY.value);
  gl.bindFramebuffer(gl.FRAMEBUFFER,kaleidoscope_fb);
  var data = new Uint8Array(outResolutionX.value * outResolutionY.value * 4);
  gl.readPixels(0, 0, outResolutionX.value, outResolutionY.value, gl.RGBA, gl.UNSIGNED_BYTE, data);
  var temp_canvas = document.createElement('canvas');
  temp_canvas.width = outResolutionX.value;
  temp_canvas.height = outResolutionY.value;
  var context = temp_canvas.getContext('2d');
  var imageData = context.createImageData(temp_canvas.width, temp_canvas.height);
  imageData.data.set(data);
  context.putImageData(imageData,0,0);
  let downloadLink = document.createElement('a');
  downloadLink.setAttribute('download', 'kaleidoscoped_image.png');
  let dataURL = temp_canvas.toDataURL('image/png');
  let url = dataURL.replace(/^data:image\/png/,'data:application/octet-stream');
  downloadLink.setAttribute('href', url);
  downloadLink.click();
}

function drawKaleidoscope(source_tex, fb, width, height) {
    gl.useProgram(kaleidoscope_program);
    gl.bindFramebuffer(gl.FRAMEBUFFER,fb);
    // Set clear color to black, fully opaque
	gl.clearColor(0.0, 0.0, 0.0, 1.0);
	// Clear the color buffer with specified clear color
	gl.clear(gl.COLOR_BUFFER_BIT);
    // look up where the vertex data needs to go.
    var positionLocation = gl.getAttribLocation(kaleidoscope_program, "a_position");
	var texcoordLocation = gl.getAttribLocation(kaleidoscope_program, "a_texCoord");
    var resolutionLocation = gl.getUniformLocation(kaleidoscope_program, "u_resolution");
    
    // lookup uniforms for frag shader
    var iResolutionLocation = gl.getUniformLocation(kaleidoscope_program, "iResolution");
    var oResolutionLocation = gl.getUniformLocation(kaleidoscope_program, "oResolution");
    var uimageLocation = gl.getUniformLocation(kaleidoscope_program, "u_image");
    var centerLocation = gl.getUniformLocation(kaleidoscope_program, "center");
    var originLocation = gl.getUniformLocation(kaleidoscope_program, "origin");
    var rotationLocation = gl.getUniformLocation(kaleidoscope_program, "rotation");
    var reflectionsLocation = gl.getUniformLocation(kaleidoscope_program, "reflections");
    var zoomLocation = gl.getUniformLocation(kaleidoscope_program, "zoom");
    
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
    
    // Tell WebGL how to convert from clip space to pixels
	gl.viewport(0, 0, width, height);
    
    
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
    
    // set the resolution in vert
	gl.uniform2f(resolutionLocation, user_image.width, user_image.height);
	
    // set the image resolution in frag
	gl.uniform2f(iResolutionLocation, user_image.width, user_image.height);
    gl.uniform2f(oResolutionLocation, outResolutionX.value, outResolutionY.value);
    gl.uniform2f(centerLocation,centerX.value,centerY.value);
    gl.uniform2f(originLocation,originX.value,originY.value);
    gl.uniform1f(rotationLocation,rotation.value);
    gl.uniform1f(reflectionsLocation,reflections.value);
    gl.uniform1f(zoomLocation,zoom.value);
	// Draw the rectangle.
	var primitiveType = gl.TRIANGLES;
	var offset = 0;
	var count = 6;
	gl.drawArrays(primitiveType, offset, count);
}

function drawToCanvas() {
	drawKaleidoscope(user_image_tex,null,canvas.width,canvas.height);
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
  kaleidoscope_program = webglUtils.createProgramFromScripts(gl, ["vertex-shader-2d", "kaleidoscope-fragment-shader-2d"]);
  resetToDefaults();
  refreshToggle.oninput = function() {
      refreshButton.style.display = refreshToggle.checked ? "none" : "inline-block";
      if (refreshToggle.checked) requestAnimationFrame(draw);
  }
  refreshButton.onclick = function() {
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