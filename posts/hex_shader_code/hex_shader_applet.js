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
        }
        this.display_elt.oninput = function() {
            var num = parseFloat(this.value);
            if (num === NaN) return;
            self.slider_elt.value = num*self.ratio;
            self.value = num;
        }
    }
    reset(){
        this.value = this.default_val;
        this.display_elt.value = this.value;
        this.slider_elt.value = this.value * this.ratio;
    }
};

const minSize = new SliderInput("minSize",1.0,10.0);
const steps = new SliderInput("steps",7);
const lineWidth = new SliderInput("lineWidth",2.0,5.0);
const lineFade = new SliderInput("lineFade",1.0,5.0);
const color0 = document.getElementById("color0");
const color1 = document.getElementById("color1");
const control = document.getElementById("control");
const invert = document.getElementById("invert");
const refreshToggle = document.getElementById("refreshToggle");
const refreshButton = document.getElementById("refreshButton");

var user_image_tex = null;
// Initialize the GL context
var gl;
main();


function resetToDefaults() {
    minSize.reset();
    steps.reset();
    lineWidth.reset();
    lineFade.reset();
    color0.value = 0;
    color1.value = 1;
    control.value = 0;
    invert.checked = false;
}

function loadSourceTexture(gl, url) {
  const texture = gl.createTexture();
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
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texImage2D(gl.TEXTURE_2D, level, internalFormat,
                  srcFormat, srcType, user_image);
    canvas.width = user_image.width;
    canvas.height = user_image.height;
    // WebGL1 has different requirements for power of 2 images
    // vs non power of 2 images so check if the image is a
    // power of 2 in both dimensions.
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
    document.getElementById("widthxheight").innerHTML = String(user_image.width).concat("x").concat(String(user_image.height));
    requestAnimationFrame(draw);
  };
  user_image.src = url;

  return texture;
}

function isPowerOf2(value) {
  return (value & (value - 1)) == 0;
}

var program;

function draw() {
      // Set clear color to black, fully opaque
      gl.clearColor(0.0, 0.0, 0.0, 1.0);
      // Clear the color buffer with specified clear color
      gl.clear(gl.COLOR_BUFFER_BIT);
      if (user_image_tex === null){
          if (user_image.src !== ''){
              user_image_tex = loadSourceTexture(gl,user_image.src);
              return;
          }
      }
      else {
          // look up where the vertex data needs to go.
          var positionLocation = gl.getAttribLocation(program, "a_position");
          var texcoordLocation = gl.getAttribLocation(program, "a_texCoord");

          // Create a buffer to put three 2d clip space points in
          var positionBuffer = gl.createBuffer();

          // Bind it to ARRAY_BUFFER (think of it as ARRAY_BUFFER = positionBuffer)
          gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
          // Set a rectangle the same size as the image.
          setRectangle(gl, 0, 0, canvas.width, canvas.height);

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

          gl.bindTexture(gl.TEXTURE_2D, user_image_tex);

          // lookup uniforms
          var resolutionLocation = gl.getUniformLocation(program, "u_resolution");
          var iResolutionLocation = gl.getUniformLocation(program, "iResolution");
          var minSizeLocation = gl.getUniformLocation(program, "minSize");
          var stepsLocation = gl.getUniformLocation(program, "steps");
          var lineWidthLocation = gl.getUniformLocation(program, "lineWidth");
          var lineFadeLocation = gl.getUniformLocation(program, "lineFade");
          var color0Location = gl.getUniformLocation(program, "color0");
          var color1Location = gl.getUniformLocation(program, "color1");
          var controlLocation = gl.getUniformLocation(program, "control");
          var invertLocation = gl.getUniformLocation(program, "invert");
          // Tell WebGL how to convert from clip space to pixels
          gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);

          // Tell it to use our program (pair of shaders)
          gl.useProgram(program);

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

          // set the resolution
          gl.uniform2f(resolutionLocation, gl.canvas.width, gl.canvas.height);
          // set the image resolution
          gl.uniform2f(iResolutionLocation, user_image.width, user_image.height);
          //set the minimum hex side length
          gl.uniform1f(minSizeLocation, minSize.value);
          //set the number of steps
          gl.uniform1f(stepsLocation, steps.value);
          //set the line width and line fade
          gl.uniform1f(lineWidthLocation, lineWidth.value);
          gl.uniform1f(lineFadeLocation, lineFade.value);
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
    if (refreshToggle.checked)
        requestAnimationFrame(draw);
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
  user_image.src = '';
  gl = canvas.getContext("webgl");
  program = webglUtils.createProgramFromScripts(gl, ["vertex-shader-2d", "fragment-shader-2d"]);
  gl.useProgram(program);
  resetToDefaults();
  refreshToggle.oninput = function() {
      refreshButton.style.display = refreshToggle.checked ? "none" : "block";
      if (refreshToggle.checked) requestAnimationFrame(draw);
  }
  refreshButton.onclick = function() {
      requestAnimationFrame(draw);
  }
}

function main() {
  init();
  const fileSelector = document.getElementById('file-selector');
  fileSelector.addEventListener('change', (event) => {
    const fileList = event.target.files;
    console.log(fileList);
    readImage(event.target.files[0],user_image);
  });
  
  

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
  });
  reader.readAsDataURL(file);
}

window.onload = main;