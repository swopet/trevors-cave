GDPC                                                                               <   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex q      �      &�y���ڞu;>��.p@   res://.import/icon2.png-2294dfe885793d4711fc20bee13a3760.stex   �y      �      8�$���#�:�,M�.@   res://.import/icon3.png-43d2171f508ea7fdbd835324de92f715.stex   ��      �      c�J�F�x����@   res://.import/icon4.png-58174286a6bda1542d86fe67f6a9a7fa.stex   ��      �      �s�T���fz'���@   res://.import/image.png-2de165adb17dfebcee8a7cd6c9833936.stex   Џ      �      �s�T���fz'���   res://Kaleido.gdshader  �      �      p7�TW��4ZT�g�r�    res://KaleidoPreview.gdshader   p      �      v��K��j$t���3}�   res://Main.gd.remap  �             �(@Er�#��K�F�[   res://Main.gdc  @      �(      ���*����.W��=�   res://Main.tscn 06      �,      T0�\C⤿Э���<   res://addons/HTML5FileExchange/HTML5FileExchange.gd.remap    �      E       AɰйF�P�`���(��4   res://addons/HTML5FileExchange/HTML5FileExchange.gdc�b            ��,,��p���I��0   res://addons/HTML5FileExchange/plugin.gd.remap  p�      :       �7�ޱ���j�
bg�,   res://addons/HTML5FileExchange/plugin.gdc   �n      g      �1u\�_�m_�F,�'��   res://default_env.tres  Pp      �       um�`�N��<*ỳ�8   res://icon.png  ��      �      G1?��z�c��vN��   res://icon.png.import   �v      �      ��fe��6�B��^ U�   res://icon2.png.import  @~      �      }��w&Qb&��   res://icon3.png.import  Ѕ      �      D�z�T�T��)�7�e   res://icon4.png.import   �      �      ~5�S�z�����.�HU   res://image.png.import  p�      �      n�Y��ŻK\�@U   res://preview_material.tres  �      �       �F.�g�定��wR:   res://project.binary��      Q      <���d���jN��#�0�        shader_type canvas_item;

uniform vec2 output_resolution;
uniform vec2 input_resolution;
uniform vec2 sample_center;
uniform vec2 offset_center;
uniform float zoom;
uniform float reflections;
uniform float rotation;

float flip_clamp(float val, float divisor){
	float modf_val = mod(val, divisor * 2.0);
	return min(divisor * 2.0 - modf_val, modf_val);
}

vec2 cis(float angle){
	return vec2(cos(angle),sin(angle));
}

float angle_offset(float angle,float radius){
	//return 0.0;
	return 3.14159 / reflections / 2.0 * sin(angle + radius * 3.14159 /  100.0);
}

void fragment(){
	vec2 uv = UV - offset_center;
	uv = uv * output_resolution / zoom;
	float angle = atan(uv.y, uv.x);
	float radius = length(uv);
	float angle_off = angle_offset(angle,radius);
	angle_off = 0.0;
	angle = angle - rotation;
	angle += angle_off;
	angle = flip_clamp(angle, 3.14159265359 / reflections);
	angle -= angle_off;
	angle = flip_clamp(angle, 3.14159265359 / reflections);
	
	angle = angle + rotation;
	
	
	uv = radius * cis(angle);
	uv = uv / input_resolution;
	uv = uv + sample_center;
	uv = vec2(flip_clamp(uv.x,1.0),flip_clamp(uv.y,1.0));
	COLOR = vec4(texture(TEXTURE,uv));
}      shader_type canvas_item;

uniform vec2 sample_center;
uniform float reflections;
uniform float rotation;

void fragment(){
	COLOR = texture(TEXTURE,UV);
	vec2 uv = UV - sample_center;
	float angle = atan(uv.y,uv.x);
	if (angle < 0.0) angle = angle + 6.28318530718 ;
	if (angle > 6.28318530718) angle = angle - 6.28318530718;
	angle = angle - rotation;
	if (angle >= 0.0 && angle <= 3.1415926535 / reflections){
		COLOR = COLOR * vec4(0.5,0.5,0.5,1.0);
	}
}        GDSC   �   4   �   !     ���ӄ�   ���������������Ѷ���   �������Ӷ���   ���������������Ѷ���   ��������������¶   ��������   ����������޶   ����������¶   ����������¶   �������������¶�   �������������¶�   �������������¶�   �������������¶�   ����������������¶��   ���������¶�   ���������������ض���   �������������������¶���   ������������������¶   ������������������¶   ����������������ض��   ����������������޶��   ��������������Ӷ   ���۶���   ������������Ķ��   ������������Ķ��   ����������Ŷ   ������������������ض   �����϶�   ����������ڶ   ����������������   ����������������Ŷ��   �������Ӷ���   �������¶���   ������¶   ����������Ŷ   �������Ӷ���   ���������Ѷ�   ��������������   ���������Ŷ�   ��������������������   ��������������   ���������������Ҷ���   ��������ƶ��   ���¶���   ζ��   ϶��   ����Ӷ��   ����������Ӷ   �������������������Ŷ���   �������ڶ���   ���������������۶���   ���   ���Ӷ���   ������������������޶   ���޶���   ����Ӷ��   ����Ӷ��   ����   ��Ķ   ����   �����������Ӷ���   ����������������Ӷ��   ��������������������޶��   ��������������������������Ҷ   �嶶   �������Ӷ���   ��������Ӷ��   ���������Ӷ�   ������������������Ӷ   �������������Ҷ�   ����������������¶��   ���������������������¶�   �������Ӷ���   ���޶���   �����������ض���   ������Ӷ   �������������Ӷ�   ����Ӷ��   ����������Ӷ    ���������������������������Ҷ���   �������������������������Ҷ�   �������¶���   �������������������������Ҷ�   �������������������������Ҷ�   ̶��   �������������������������Ҷ�   �������������Ҷ�    ����������������������������Ҷ��    ����������������������������Ҷ��    ����������������������������Ҷ��    ����������������������������Ҷ��$   ��������������������������������Ҷ��   Ķ��    �����������������������������Ҷ�(   ������������������������������������Ҷ��   ��������������������������Ҷ   ��Ѷ   �������׶���   �����϶�   ����Ŷ��   ���ݶ���   ��������޶��   ���������¶�   ��ڶ   ��������ڶ��   Ѷ��   Զ��   ׶��   ��������ڶ��   �����ݶ�   ���������Ӷ�$   �������������������������������Ҷ���   ����������������   �������Ѷ���    ������������������������������¶   ����¶��   ��������������������ض��   ������Ҷ   ��������������������ض��   ����¶��   ����������������������Ҷ   �����������   ��Ŷ   ���Ŷ���   ��������Ӷ��   �������Ѷ���   ��Ŷ   �������ض���      GUILayer/LoadFileDialog       GUILayer/SaveFileDialog       RenderViewport        ImageLayer/PreviewMesh        RenderViewport/RenderMesh      M   GUILayer/MarginContainer/MarginContainer/VBoxContainer/ResContainer/ResXInput      M   GUILayer/MarginContainer/MarginContainer/VBoxContainer/ResContainer/ResYInput      S   GUILayer/MarginContainer/MarginContainer/VBoxContainer/SampleContainer/SampleXInput    S   GUILayer/MarginContainer/MarginContainer/VBoxContainer/SampleContainer/SampleYInput    S   GUILayer/MarginContainer/MarginContainer/VBoxContainer/OffsetContainer/OffsetXInput    S   GUILayer/MarginContainer/MarginContainer/VBoxContainer/OffsetContainer/OffsetYInput    G   GUILayer/MarginContainer/MarginContainer/VBoxContainer/ReflectionsInput    N   GUILayer/MarginContainer/MarginContainer/VBoxContainer/ZoomContainer/ZoomInput     E   GUILayer/MarginContainer/MarginContainer/VBoxContainer/ShowHideButton      J   GUILayer/MarginContainer/MarginContainer/VBoxContainer/RotationInputSlider     V   GUILayer/MarginContainer/MarginContainer/VBoxContainer/RotationContainer/RotationInput     _   GUILayer/MarginContainer/MarginContainer/VBoxContainer/SourceTextureContainer/SourceTextureRect      �?                 ?     @@             toggled              size_changed      _on_size_changed      *.png,*.jpeg,*.jpg        *.png         GUI_elts      visible       input_resolution      output_resolution         zoom      sample_center         offset_center         reflections       rotation     4C                   HTML5         load_completed                    Hide      Show         h    ������@   	   image.png         @                                                    	      
   #      ,      5      >      G      P      Y      b      k      t      }      �      �      �      �      �      �      �      �      �      �      �       �   !   �   "   �   #   �   $   �   %   �   &   �   '     (     )   %  *   .  +   :  ,   C  -   L  .   M  /   S  0   W  1   X  2   ^  3   d  4   q  5     6   �  7   �  8   �  9   �  :   �  ;   �  <   �  =   �  >   �  ?   �  @   �  A   �  B   �  C     D     E     F   )  G   4  H   C  I   N  J   Y  K   h  L   i  M   r  N   {  O   �  P   �  Q   �  R   �  S   �  T   �  U   �  V   �  W   �  X   �  Y   �  Z   �  [   �  \   �  ]   �  ^   �  _   �  `   �  a   �  b   �  c     d     e     f     g     h   !  i   "  j   (  k   5  l   >  m   T  n   ^  o   _  p   e  q   k  r   o  s   v  t   �  u   �  v   �  w   �  x   �  y   �  z   �  {   �  |   �  }   �  ~   �     �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �     �     �   
  �     �     �      �   (  �   0  �   4  �   8  �   A  �   B  �   C  �   J  �   W  �   a  �   b  �   c  �   j  �   r  �   ~  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �      �     �     �     �     �   )  �   *  �   +  �   2  �   :  �   B  �   F  �   J  �   S  �   T  �   U  �   \  �   d  �   p  �   t  �   x  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   "  �   -  �   3  �   <  �   ?  �   Q  �   R  �   S  �   Z  �   g  �   p  �   v  �   }  �   ~  �     �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �   �  �     �     �     �     �   3YYYYYYY5;�  �  PQY5;�  �  P�  QY5;�  �  P�  QY5;�  �  P�  QY5;�  �  P�  QY5;�  �  P�  QY5;�  �  P�  QY5;�	  �  P�  QY5;�
  �  P�  QY5;�  �  P�	  QY5;�  �  P�
  QY5;�  �  P�  QY5;�  �  P�  QY5;�  �  P�  QY5;�  �  P�  QY5;�  �  P�  QY5;�  �  P�  QY;�  V�  �  P�  R�  QY;�  V�  �  Y;�  �  Y;�  V�  �  Y;�  V�  �  P�  R�  QY;�  V�  �  P�  R�  QY;�  V�  �  Y;�  V�  �  YYY0�  PQV�  �  T�  P�  R�  Q�  �  PQ�  �  PQ�  �  PQT�   PQT�!  P�  RR�  Q�  �  T�"  P�  PL�  MQQ�  �  T�#  P�$  T�%  Q�  �  T�&  P�$  T�'  Q�  �  T�"  P�  PL�  MQQ�  �  T�#  P�$  T�(  Q�  �  T�&  P�$  T�'  QYY0�)  PQV�  �  PQYY0�  PQV�  &�  �  V�  �  PQT�*  P�  R�  R�  Q�  �  T�+  �G  P�  P�  T�,  QQ�  �  T�+  �G  P�  P�  T�-  QQ�  �  T�+  �G  P�  Q�  �	  T�+  �G  P�  T�,  Q�  �
  T�+  �G  P�  T�-  Q�  �  T�+  �G  P�  T�,  Q�  �  T�+  �G  P�  T�-  Q�  �  T�+  �G  P�  Q�  �  T�.  �  �  �  T�+  �G  P�  Q�  �  T�/  P�  QYY0�0  PQV�  �  T�1  T�2  P�  R�  T�3  &�  �  (�  T�4  Q�  �  T�1  T�2  P�   R�  Q�  �  T�1  T�2  P�!  R�  Q�  �  T�1  T�2  P�"  R�  Q�  �  T�1  T�2  P�#  R�  Q�  �  T�1  T�2  P�$  R�  Q�  �  T�1  T�2  P�%  R�  Z�&  Q�  �  T�1  T�2  P�"  R�  Q�  �  T�1  T�2  P�$  R�  Q�  �  T�1  T�2  P�%  R�  Z�&  QYY0�5  P�6  QX�  V�  ;�7  �8  T�9  PQ�  ;�:  �7  T�L  P�6  Q�  &�:  �;  V�  .�  �  (V�  �  �<  T�9  PQ�  �  T�=  P�7  R�'  Q�  .�(  YY0�>  P�6  V�  QV�  �  �6  YY0�?  PQV�  /P�@  T�A  PQQV�  �)  V�  �B  T�C  PQ�  ;�7  AP�B  R�*  Q�  �  �<  T�9  PQ�  �  T�=  P�7  R�'  Q�  �D  PQ�  \V�  �  T�E  P�F  PQT�4  �  P�+  R�+  QQYY0�G  PQV�  �  T�H  P�  Q�  �  T�I  T�H  P�  Q�  �  T�J  P�  �,  QYY0�  PQV�  �  T�J  P�F  PQT�4  �,  Q�  ;�K  �F  PQT�4  �  ;�L  �4  P�K  T�,  �  T�,  R�K  T�-  �  T�-  Q�  �  T�M  �  T�3  �L  YY0�D  PQV�  �  �  T�4  �  �G  PQ�  �  T�/  P�  Q�  �  T�/  P�  T�N  PQQ�  �  PQ�  �0  PQ�  �  PQYY0�O  P�6  QV�  &P�5  P�6  QQV�  �>  P�6  Q�  �D  PQYYY0�P  P�Q  QV�  ;�,  �  P�Q  Q�  &P�,  �'  QV�  �  T�,  �,  �  �0  PQ�  �G  PQ�  �  PQ�  �  T�+  �G  P�  P�  T�,  QQ�  Y0�R  P�Q  QV�  ;�-  �  P�Q  Q�  &P�-  �'  QV�  �  T�-  �-  �  �0  PQ�  �G  PQ�  �  PQ�  �  T�+  �G  P�  P�  T�-  QQYY0�S  P�Q  QV�  ;�T  �  P�Q  Q�  &P�T  �'  QV�  �  �T  �  �0  PQ�  �  T�+  �G  P�  QYYY0�U  P�V  QV�  �  PQT�*  P�  R�  R�V  Q�  �  T�+  �-  &�V  (�.  YYY0�W  P�Q  QV�  ;�,  �  P�Q  Q�  &P�,  �'  �,  
�/  QV�  �  T�,  �,  �  �0  PQ�  �	  T�+  �G  P�  T�,  QYYY0�X  P�Q  QV�  ;�-  �  P�Q  Q�  &P�-  �'  �-  
�/  QV�  �  T�-  �-  �  �0  PQ�  �
  T�+  �G  P�  T�-  QYYY0�Y  P�Q  QV�  ;�,  �  P�Q  Q�  &P�,  �'  �,  
�/  QV�  �  T�,  �,  �  �0  PQ�  �  T�+  �G  P�  T�,  QYYY0�Z  P�Q  QV�  ;�-  �  P�Q  Q�  &P�-  �'  �-  
�/  QV�  �  T�-  �-  �  �0  PQ�  �  T�+  �G  P�  T�-  QYYY0�[  P�Q  QV�  ;�\  �  P�Q  Q�  &P�\  �'  QV�  �  �\  �  �0  PQ�  �  T�+  �G  P�  QYYY0�]  P�Q  QV�  ;�\  �  P�Q  Q�  &P�\  �'  �\  
�0  QV�  �  �\  �  �0  PQ�  �  T�+  �G  P�  Q�  �  T�.  �  YYY0�^  P�.  QV�  �  �.  �  �0  PQ�  �  T�+  �G  P�  QYYY0�_  PQV�  /P�@  T�A  PQQV�  �)  V�  ;�`  �  T�N  PQT�a  PQ�  �`  T�b  PQ�  ;�c  �`  T�a  PQ�  �`  T�d  PQ�  )�,  �K  P�`  T�e  PQQV�  )�-  �K  P�`  T�f  PQQV�  ;�g  �`  T�h  P�,  R�-  Q�  �g  �  P�  P�g  T�\  R�1  QR�  P�g  T�i  R�1  QR�  P�g  T�j  R�1  QR�g  T�k  Q�  �`  T�l  P�,  R�-  R�g  Q�  �`  T�m  PQ�  �B  T�n  P�`  R�2  Q�  \V�  �  T�E  P�F  PQT�4  �  P�+  R�+  QQYYY0�o  P�6  QV�  ;�`  �  T�N  PQT�a  PQ�  �`  T�9  P�8  T�p  Q�  �`  T�b  PQ�  �`  T�q  P�6  QYYY0�r  P�s  QV�  &P�s  4�t  �s  T�u  �s  4�v  �w  T�x  P�y  QQV�  .�  &P�  �  QV�  .�  ;�z  �  T�4  �  ;�{  �  T�|  �  ;�M  �4  P�{  T�,  �z  T�,  R�{  T�-  �z  T�-  Q�  ;�}  �z  �M  �  ;�~  �}  �3  P�s  T�  �  T�|  �3  Q�  �~  �  T�3  �  P�5  P�~  T�,  R�'  R�}  T�,  Q�}  T�,  R�5  P�~  T�-  R�'  R�}  T�-  Q�}  T�-  Q�  �  �~  �  �0  PQ�  �  PQY`    [gd_scene load_steps=9 format=2]

[ext_resource path="res://Main.gd" type="Script" id=1]
[ext_resource path="res://preview_material.tres" type="Material" id=2]
[ext_resource path="res://Kaleido.gdshader" type="Shader" id=3]
[ext_resource path="res://KaleidoPreview.gdshader" type="Shader" id=4]

[sub_resource type="QuadMesh" id=3]
size = Vector2( 240, 240 )

[sub_resource type="StyleBoxFlat" id=7]
bg_color = Color( 0.054902, 0.0117647, 0.0117647, 1 )

[sub_resource type="ShaderMaterial" id=9]
shader = ExtResource( 4 )
shader_param/sample_center = null
shader_param/reflections = null
shader_param/rotation = null

[sub_resource type="ShaderMaterial" id=6]
shader = ExtResource( 3 )
shader_param/output_resolution = null
shader_param/input_resolution = null
shader_param/sample_center = null
shader_param/offset_center = null
shader_param/zoom = null
shader_param/reflections = null
shader_param/rotation = null

[node name="Main" type="Node2D"]
script = ExtResource( 1 )

[node name="ImageLayer" type="CanvasLayer" parent="."]

[node name="PreviewMesh" type="MeshInstance2D" parent="ImageLayer"]
material = ExtResource( 2 )
mesh = SubResource( 3 )

[node name="GUILayer" type="CanvasLayer" parent="."]

[node name="LoadFileDialog" type="FileDialog" parent="GUILayer"]
margin_right = 315.0
margin_bottom = 130.0
grow_horizontal = 2
grow_vertical = 2

[node name="SaveFileDialog" type="FileDialog" parent="GUILayer"]
margin_right = 315.0
margin_bottom = 130.0
grow_horizontal = 2
grow_vertical = 2

[node name="MarginContainer" type="MarginContainer" parent="GUILayer"]

[node name="Panel" type="Panel" parent="GUILayer/MarginContainer"]
margin_right = 256.0
margin_bottom = 564.0
custom_styles/panel = SubResource( 7 )

[node name="MarginContainer" type="MarginContainer" parent="GUILayer/MarginContainer"]
margin_right = 256.0
margin_bottom = 564.0
custom_constants/margin_right = 8
custom_constants/margin_top = 8
custom_constants/margin_left = 8
custom_constants/margin_bottom = 8

[node name="VBoxContainer" type="VBoxContainer" parent="GUILayer/MarginContainer/MarginContainer"]
margin_left = 8.0
margin_top = 8.0
margin_right = 248.0
margin_bottom = 556.0

[node name="ShowHideButton" type="Button" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer"]
margin_right = 240.0
margin_bottom = 20.0
toggle_mode = true
text = "Show"

[node name="LoadImageButton" type="Button" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 24.0
margin_right = 240.0
margin_bottom = 44.0
text = "Load Image"

[node name="OutputResolutionLabel" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 48.0
margin_right = 240.0
margin_bottom = 62.0
text = "Output Resolution"

[node name="ResContainer" type="HBoxContainer" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 66.0
margin_right = 240.0
margin_bottom = 90.0

[node name="ResXInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ResContainer" groups=["GUI_elts"]]
margin_right = 58.0
margin_bottom = 24.0

[node name="Label" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ResContainer" groups=["GUI_elts"]]
margin_left = 62.0
margin_top = 5.0
margin_right = 69.0
margin_bottom = 19.0
text = "x"

[node name="ResYInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ResContainer" groups=["GUI_elts"]]
margin_left = 73.0
margin_right = 131.0
margin_bottom = 24.0

[node name="Label2" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ResContainer" groups=["GUI_elts"]]
margin_left = 135.0
margin_top = 5.0
margin_right = 150.0
margin_bottom = 19.0
text = "px"

[node name="ZoomLabel" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 94.0
margin_right = 240.0
margin_bottom = 108.0
text = "Zoom"

[node name="ZoomContainer" type="HBoxContainer" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 112.0
margin_right = 240.0
margin_bottom = 136.0

[node name="ZoomInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ZoomContainer" groups=["GUI_elts"]]
margin_right = 58.0
margin_bottom = 24.0

[node name="SampleLabel" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 140.0
margin_right = 240.0
margin_bottom = 154.0
text = "Sample Center"

[node name="SampleContainer" type="HBoxContainer" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 158.0
margin_right = 240.0
margin_bottom = 182.0

[node name="SampleXInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/SampleContainer" groups=["GUI_elts"]]
margin_right = 58.0
margin_bottom = 24.0

[node name="Label" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/SampleContainer" groups=["GUI_elts"]]
margin_left = 62.0
margin_top = 5.0
margin_right = 66.0
margin_bottom = 19.0
text = ","

[node name="SampleYInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/SampleContainer" groups=["GUI_elts"]]
margin_left = 70.0
margin_right = 128.0
margin_bottom = 24.0

[node name="OffsetLabel" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 186.0
margin_right = 240.0
margin_bottom = 200.0
text = "Offset Center"

[node name="OffsetContainer" type="HBoxContainer" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 204.0
margin_right = 240.0
margin_bottom = 228.0

[node name="OffsetXInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/OffsetContainer" groups=["GUI_elts"]]
margin_right = 58.0
margin_bottom = 24.0

[node name="Label" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/OffsetContainer" groups=["GUI_elts"]]
margin_left = 62.0
margin_top = 5.0
margin_right = 66.0
margin_bottom = 19.0
text = ","

[node name="OffsetYInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/OffsetContainer" groups=["GUI_elts"]]
margin_left = 70.0
margin_right = 128.0
margin_bottom = 24.0

[node name="ReflectionsLabel" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 232.0
margin_right = 240.0
margin_bottom = 246.0
text = "Reflections"

[node name="ReflectionsInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 250.0
margin_right = 240.0
margin_bottom = 274.0

[node name="RotationLabel" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 278.0
margin_right = 240.0
margin_bottom = 292.0
text = "Rotation"

[node name="RotationInputSlider" type="HSlider" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 296.0
margin_right = 240.0
margin_bottom = 312.0
max_value = 360.0
step = 0.005

[node name="RotationContainer" type="HBoxContainer" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 316.0
margin_right = 240.0
margin_bottom = 340.0

[node name="RotationInput" type="LineEdit" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/RotationContainer" groups=["GUI_elts"]]
margin_right = 58.0
margin_bottom = 24.0

[node name="Label" type="Label" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/RotationContainer" groups=["GUI_elts"]]
margin_left = 62.0
margin_top = 5.0
margin_right = 115.0
margin_bottom = 19.0
text = "Degrees"

[node name="SaveImageButton" type="Button" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 344.0
margin_right = 240.0
margin_bottom = 364.0
text = "Save Image"

[node name="SourceTextureContainer" type="PanelContainer" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer" groups=["GUI_elts"]]
margin_top = 368.0
margin_right = 240.0
margin_bottom = 548.0
rect_min_size = Vector2( 240, 180 )

[node name="SourceTextureRect" type="TextureRect" parent="GUILayer/MarginContainer/MarginContainer/VBoxContainer/SourceTextureContainer" groups=["GUI_elts"]]
material = SubResource( 9 )
margin_left = 7.0
margin_top = 7.0
margin_right = 233.0
margin_bottom = 173.0
expand = true
stretch_mode = 6

[node name="RenderViewport" type="Viewport" parent="."]
size = Vector2( 80, 80 )
own_world = true
render_target_v_flip = true

[node name="RenderMesh" type="MeshInstance2D" parent="RenderViewport"]
material = SubResource( 6 )
mesh = SubResource( 3 )

[connection signal="file_selected" from="GUILayer/LoadFileDialog" to="." method="_on_FileDialog_file_selected"]
[connection signal="file_selected" from="GUILayer/SaveFileDialog" to="." method="_on_SaveFileDialog_file_selected"]
[connection signal="toggled" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ShowHideButton" to="." method="_on_ShowHideButton_toggled"]
[connection signal="pressed" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/LoadImageButton" to="." method="_on_LoadImageButton_pressed"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ResContainer/ResXInput" to="." method="_on_ResXInput_text_entered"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ResContainer/ResYInput" to="." method="_on_ResYInput_text_entered"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ZoomContainer/ZoomInput" to="." method="_on_ZoomInput_text_entered"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/SampleContainer/SampleXInput" to="." method="_on_SampleXInput_text_entered"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/SampleContainer/SampleYInput" to="." method="_on_SampleYInput_text_entered"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/OffsetContainer/OffsetXInput" to="." method="_on_OffsetXInput_text_entered"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/OffsetContainer/OffsetYInput" to="." method="_on_OffsetYInput_text_entered"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/ReflectionsInput" to="." method="_on_ReflectionsInput_text_entered"]
[connection signal="value_changed" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/RotationInputSlider" to="." method="_on_RotationInputSlider_value_changed"]
[connection signal="text_entered" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/RotationContainer/RotationInput" to="." method="_on_RotationInput_text_entered"]
[connection signal="pressed" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/SaveImageButton" to="." method="_on_SaveImageButton_pressed"]
[connection signal="gui_input" from="GUILayer/MarginContainer/MarginContainer/VBoxContainer/SourceTextureContainer/SourceTextureRect" to="." method="_on_SourceTextureRect_gui_input"]
       GDSC   $      :   :     ���Ӷ���   �������������Ҷ�   �������������Ҷ�   ����Ӷ��   ����������ݶ   ���������¶�   ��������������ݶ   �����������Ӷ���   �����϶�   �嶶   �������Ӷ���   ����������Ӷ   ���������Ŷ�   ������������Ӷ��   ���ڶ���   �����������Ķ���   ����Ŷ��   ����������ڶ   ���������Ӷ�   �����Ҷ�   ��������Ӷ��   �������Ӷ���   ��������׶��   ����Ӷ��   ����   ����������Ķ   �������������������Ķ���   �������������������Ķ���   ��������������������Ķ��   ����������Ӷ   ���������Ӷ�   �������Ӷ���   ������������Ŷ��   �����Ķ�   �����������������Ķ�   ��������������Ķ      load_handler      HTML5      
   JavaScript        _HTML5FileExchange     �  
	var _HTML5FileExchange = {};
	_HTML5FileExchange.upload = function(gd_callback) {
		canceled = true;
		var input = document.createElement('INPUT'); 
		input.setAttribute("type", "file");
		input.setAttribute("accept", "image/png, image/jpeg, image/webp");
		input.click();
		input.addEventListener('change', event => {
			if (event.target.files.length > 0){
				canceled = false;}
			var file = event.target.files[0];
			var reader = new FileReader();
			this.fileType = file.type;
			// var fileName = file.name;
			reader.readAsArrayBuffer(file);
			reader.onloadend = (evt) => { // Since here's it's arrow function, "this" still refers to _HTML5FileExchange
				if (evt.target.readyState == FileReader.DONE) {
					this.result = evt.target.result;
					gd_callback(); // It's hard to retrieve value from callback argument, so it's just for notification
				}
			}
		  });
	}
	               read_completed        _HTML5FileExchange.result      	   image/png      
   image/jpeg     
   image/webp        Unsupported file format - %s.      4   An error occurred while trying to display the image.      load_completed     
   export.png                                                      	   %   
   6      :      D      E      M      N      S   (   W   )   X   *   _   +   d   ,   e   -   k   .   }   /      0   �   1   �   2   �   3   �   4   �   5   �   6   �   7   �   8   �   9   �   :   �   ;   �   <   �   =   �   >   �   ?   �   @   �   A   �   B   �   C   �   D   �   E   �   F   �   G   �   H   �   I   �   J     K     L     M      N   &  O   /  P   8  Q   3YYB�  YB�  P�  QYY;�  �  T�  PRQSY;�  SYY0�  PQV�  &�	  T�
  PQ�  �	  T�  P�  QV�  �  PQ�  �  �  T�  P�  QSYY0�  PQX=V�  �  �  T�  P�  R�  QYY0�  P�  QV�  �  P�  Q�  Y0�  PQV�  &�	  T�
  PQ�  �	  T�  P�  QV�  .Y�  �  T�  P�  QSY�  APR�  Q�  �  ;�  �  T�  S�  ;�  �  T�  P�  R�  Q�  �  ;�  �  T�  PQ�  ;�  �  /�  V�  �  V�  �  �  T�  P�  Q�  �	  V�  �  �  T�  P�  Q�  �
  V�  �  �  T�  P�  Q�  ;�  V�  �?  P�  �  Q�  .�  �  &�  V�  �?  P�  Q�  �  �  P�  R�  QYY0�  P�  V�  R�  V�  �  QX=V�  &�	  T�
  PQ�  �	  T�  P�  QV�  .�  �  �  T�   PQ�  ;�!  �  T�"  PQ�  �  T�#  P�!  R�  QY`  GDSC            "      �����������ض���   ����������Ӷ   ���������������������ض�   ���������Ӷ�   ������������������������ض��   	   HTML5File      3   res://addons/HTML5FileExchange/HTML5FileExchange.gd                                                     	      
          6Y3YYY0�  PQV�  �  PR�  QYYY0�  PQV�  �  PQY`         [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             GDST@   @            �  WEBPRIFF�  WEBPVP8L�  /?����m��������_"�0@��^�"�v��s�}� �W��<f��Yn#I������wO���M`ҋ���N��m:�
��{-�4b7DԧQ��A �B�P��*B��v��
Q�-����^R�D���!(����T�B�*�*���%E["��M�\͆B�@�U$R�l)���{�B���@%P����g*Ųs�TP��a��dD
�6�9�UR�s����1ʲ�X�!�Ha�ߛ�$��N����i�a΁}c Rm��1��Q�c���fdB�5������J˚>>���s1��}����>����Y��?�TEDױ���s���\�T���4D����]ׯ�(aD��Ѓ!�a'\�G(��$+c$�|'�>����/B��c�v��_oH���9(l�fH������8��vV�m�^�|�m۶m�����q���k2�='���:_>��������á����-wӷU�x�˹�fa���������ӭ�M���SƷ7������|��v��v���m�d���ŝ,��L��Y��ݛ�X�\֣� ���{�#3���
�6������t`�
��t�4O��ǎ%����u[B�����O̲H��o߾��$���f���� �H��\��� �kߡ}�~$�f���N\�[�=�'��Nr:a���si����(9Lΰ���=����q-��W��LL%ɩ	��V����R)�=jM����d`�ԙHT�c���'ʦI��DD�R��C׶�&����|t Sw�|WV&�^��bt5WW,v�Ş�qf���+���Jf�t�s�-BG�t�"&�Ɗ����׵�Ջ�KL�2)gD� ���� NEƋ�R;k?.{L�$�y���{'��`��ٟ��i��{z�5��i������c���Z^�
h�+U�mC��b��J��uE�c�����h��}{�����i�'�9r�����ߨ򅿿��hR�Mt�Rb���C�DI��iZ�6i"�DN�3���J�zڷ#oL����Q �W��D@!'��;�� D*�K�J�%"�0�����pZԉO�A��b%�l�#��$A�W�A�*^i�$�%a��rvU5A�ɺ�'a<��&�DQ��r6ƈZC_B)�N�N(�����(z��y�&H�ض^��1Z4*,RQjԫ׶c����yq��4���?�R�����0�6f2Il9j��ZK�4���է�0؍è�ӈ�Uq�3�=[vQ�d$���±eϘA�����R�^��=%:�G�v��)�ǖ/��RcO���z .�ߺ��S&Q����o,X�`�����|��s�<3Z��lns'���vw���Y��>V����G�nuk:��5�U.�v��|����W���Z���4�@U3U�������|�r�?;�
         [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
              GDST@   @            �  WEBPRIFF�  WEBPVP8Lx  /?� 7�*�$��9f�;k���7�67��HM?x1pN���uu�I�Ue�w�Y�'$&~2��}ϪD %�/%4D �eX��T�D@@$�FB�� �(�@�_��uK �2�}
�����+~)��D"!5hHd���_U,���n<�_o�tUx#�q�N��wVOTE��F�I?U�8O�7:_HB����(7�D8����:ڨ|��($��Jm�(,p��g��$j��&���S�F�ƽ��������8�;��ȟ���@D����H��Z>��GTC!10�/B-�/~���s��T'&�w}�M?��]��7G�)�:mr����L���vz��zr�P�H��`��M�f��9T5���efoq�6��Z4�ϓ?s�5Z�^�e6q�3x����.�)�@��m ���X���N�v����XX#j�m�Y�t�O��2�$6Ms�g�J `�?[S�fo��x���,��n^8m��&-�ٶ���By�/��@ Xd��AR��j�c�|8�ۻ
\�E����Y�dƵ��S� ��..���>������S�r#]�[��@����3Bl���5O=�`;7#?�R�C�=��2 /y@G��V_1�/����J�U��
aDUL�dQb�]rpIj�+82MY��Y!ZF����3͡�Ŧ�Vf�K�wy0>N�e[�mv������aL�{7�����D�m̒j�����tpAYjb��k4<ӗ�n���){����!3�^���j'��MbP$�{�̏��7F~��o4�q;���������#Y����^��`��Zk����܌�[JH�gube  ^0�!/7���g!��Fx��⚴�B�Q�@Rr�����2�F��Tc,&ױz>���W�t6g}5� �V#b�<ȗ�y ,�?9xiȒ�,>�h���Vi��`Ҳ�m[2�C�J���d�^�EL:���+tK% ��)l��T�b�4�o�ı`ikD��7�ő�閱8����@��V"��ɛDsg���&�w^�H�|�17��B(�*�Pի�-3{��WE�S�H��`��M���G�rz�	�<����//B#��!�P4<��_�(����bT��ӣ����\�������8�PH�h�~��8�    [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon2.png-2294dfe885793d4711fc20bee13a3760.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon2.png"
dest_files=[ "res://.import/icon2.png-2294dfe885793d4711fc20bee13a3760.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
           GDST@   @            �  WEBPRIFF�  WEBPVP8L�  /?� '�m$GR���{�����3I��$�U�9�>2�8���  �3㸑$EʮY���!3��WA݀�C@B2@��B T
Ba�"!�H�P�D��[
����H�@	��0`�H�P�
�@�-��!@��6T�J�y����'�=_�/U��=�o����v���5�?�d���*��B�#��RF�������m]-��g����1����ʒ
:c6�R��n�KTH��Mm���{:X`�Bjh�
[ܻ)��Ε7�v����;p�Ƒ�ݽ�3�����d�V��2-.������Ү~v�.�^�#� ��O�!=�HR��7�4��tI�F����<��j�����(嬯��,����jj@�����6��;�-A��l��4'�%�oi>�7���4IR���9{p��=T�vJR!e�㬱�2b �S��+>W�� �>���������<�,'��h��,7"�����O��Ղ(;!Ɔ S�Q5�����e�cv)f��&�&@�@Y� PFD�� *U�<��T&<�TC,�������՜��O�����"Q�D#j���#���C�U��8# �Q�Y���0��a�����v#��@;�a;�J��z��S����?;�AJ���M�y���l��{k7�{�~]vu׊�/����6�vE�`*�˭����q�<m��.#̻�����6�����t��h��
��1��㓧��Xk��w�jʋc��R�Ws[-���J^ҹ�_J��D�q��	����~�]~������u������7��{k7���b�N��+����n��[v���u�U�������v~�fms��4��Q����ڍH��qW>P�z��j �g� U�R���h��Jtt$h�t��o2��إb�7�oXH�d�x&�U@������ *U�<��TL���/��L�ޤ"@���9�B��|���Q��A�cB1�'K|��,���c�n��F�Z ���+>W�v ���|i��No�уC>��a�^o�$5RV:�+)#4[I�[�O�͚�z�lƂ�G^@sR	�e^�9l	�����S��5�}Q�B^|Gc�h���g;�6���'�����$�v>-�Z�rz� ��.Oo0Li8���^�.�veY�������+r$+q�oey�(���,             [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon3.png-43d2171f508ea7fdbd835324de92f715.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon3.png"
dest_files=[ "res://.import/icon3.png-43d2171f508ea7fdbd835324de92f715.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
           GDST@   @            x  WEBPRIFFl  WEBPVP8L_  /?� 7�*�$Ū�{��<O�i�l8l�ȑf��s���/��aFrI�bU��c���Yy��nj�C]� BE�a�lf�"��P	D
QK
�a�V[��{!�Ֆb��[�dK����R[�B(	�ސ����_Y����l��eD2Η���ɲ�%q��c��vQt���^*����F
� �H 0F��<YϓDd*#�A"#���� �����n�M��ʇ�;<'؏d�ch�|��� ���FR$�B-��#������Ǘ�~<�vs��T'&O�]�M?�/����V��)o����ܷ�y��G�Й^����p��S����m����ȍ����͜��s�jQg��^��Smi�h4�'�FRj�Z�6��d�x��N�ћ)\(�S"���W����8���&O�ɱ�D԰��3��c�4�
fKe�I�������D-� �"�ư��H��2��Y��]|p4�"��ZV�m��	�*��� _���@����K��$՜���pطw8�����˓�Ɍs���A��9������y�b�,��|\HW��g&p��\E�M�4�䩇��&���K_Kܣ:/ �Wt$Khu�ے�oc���jU��BQc$��ظ�윒Z�
�LSV.e����v��L�o6�*����9�>�&ּ��2;EDv�@[1���+�P�Sw �6&I5����v:8�,52�i�5���o�u�9e���Z�5d�����6	�(z5@2�%9���~c��F�����G��~�o�:�%I1�-��6VX�V�*��b=7!A�������N� �F>����x������/X�]�6T��C� *HJ'']ۘg�(��j���<Vχò�E�,�.��,O����jD,��2=�E�'/Y��'�3_�"��ZV�mK&��S)|Z��˰�I'w��q�ni���6�u�П*�-��&����,�ba��a�����<�2'>�#��=h�p��J$�:��h�����Ƨ=i^��3�FRB%Z%�z��ff/q�Hw�ɉ�L\~	��;��-������P̫�[��!4����EÛ�t/9�=;��B����8Ο��s���0yz�����B�Es��������-             [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon4.png-58174286a6bda1542d86fe67f6a9a7fa.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon4.png"
dest_files=[ "res://.import/icon4.png-58174286a6bda1542d86fe67f6a9a7fa.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
           GDST@   @            x  WEBPRIFFl  WEBPVP8L_  /?� 7�*�$Ū�{��<O�i�l8l�ȑf��s���/��aFrI�bU��c���Yy��nj�C]� BE�a�lf�"��P	D
QK
�a�V[��{!�Ֆb��[�dK����R[�B(	�ސ����_Y����l��eD2Η���ɲ�%q��c��vQt���^*����F
� �H 0F��<YϓDd*#�A"#���� �����n�M��ʇ�;<'؏d�ch�|��� ���FR$�B-��#������Ǘ�~<�vs��T'&O�]�M?�/����V��)o����ܷ�y��G�Й^����p��S����m����ȍ����͜��s�jQg��^��Smi�h4�'�FRj�Z�6��d�x��N�ћ)\(�S"���W����8���&O�ɱ�D԰��3��c�4�
fKe�I�������D-� �"�ư��H��2��Y��]|p4�"��ZV�m��	�*��� _���@����K��$՜���pطw8�����˓�Ɍs���A��9������y�b�,��|\HW��g&p��\E�M�4�䩇��&���K_Kܣ:/ �Wt$Khu�ے�oc���jU��BQc$��ظ�윒Z�
�LSV.e����v��L�o6�*����9�>�&ּ��2;EDv�@[1���+�P�Sw �6&I5����v:8�,52�i�5���o�u�9e���Z�5d�����6	�(z5@2�%9���~c��F�����G��~�o�:�%I1�-��6VX�V�*��b=7!A�������N� �F>����x������/X�]�6T��C� *HJ'']ۘg�(��j���<Vχò�E�,�.��,O����jD,��2=�E�'/Y��'�3_�"��ZV�mK&��S)|Z��˰�I'w��q�ni���6�u�П*�-��&����,�ba��a�����<�2'>�#��=h�p��J$�:��h�����Ƨ=i^��3�FRB%Z%�z��ff/q�Hw�ɉ�L\~	��;��-������P̫�[��!4����EÛ�t/9�=;��B����8Ο��s���0yz�����B�Es��������-             [remap]

importer="texture"
type="StreamTexture"
path="res://.import/image.png-2de165adb17dfebcee8a7cd6c9833936.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://image.png"
dest_files=[ "res://.import/image.png-2de165adb17dfebcee8a7cd6c9833936.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
           [gd_resource type="ShaderMaterial" load_steps=2 format=2]

[sub_resource type="Shader" id=5]
code = "shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE,UV);
}"

[resource]
shader = SubResource( 5 )
         [remap]

path="res://Main.gdc"
 [remap]

path="res://addons/HTML5FileExchange/HTML5FileExchange.gdc"
           [remap]

path="res://addons/HTML5FileExchange/plugin.gdc"
      �PNG

   IHDR   @   @   �iq�   sRGB ���  �IDATx��ytTU��?�ի%���@ȞY1JZ �iA�i�[P��e��c;�.`Ow+4�>�(}z�EF�Dm�:�h��IHHB�BR!{%�Zߛ?��	U�T�
���:��]~�������-�	Ì�{q*�h$e-
�)��'�d�b(��.�B�6��J�ĩ=;���Cv�j��E~Z��+��CQ�AA�����;�.�	�^P	���ARkUjQ�b�,#;�8�6��P~,� �0�h%*QzE� �"��T��
�=1p:lX�Pd�Y���(:g����kZx ��A���띊3G�Di� !�6����A҆ @�$JkD�$��/�nYE��< Q���<]V�5O!���>2<��f��8�I��8��f:a�|+�/�l9�DEp�-�t]9)C�o��M~�k��tw�r������w��|r�Ξ�	�S�)^� ��c�eg$�vE17ϟ�(�|���Ѧ*����
����^���uD�̴D����h�����R��O�bv�Y����j^�SN֝
������PP���������Y>����&�P��.3+�$��ݷ�����{n����_5c�99�fbסF&�k�mv���bN�T���F���A�9�
(.�'*"��[��c�{ԛmNު8���3�~V� az
�沵�f�sD��&+[���ke3o>r��������T�]����* ���f�~nX�Ȉ���w+�G���F�,U�� D�Դ0赍�!�B�q�c�(
ܱ��f�yT�:��1�� +����C|��-�T��D�M��\|�K�j��<yJ, ����n��1.FZ�d$I0݀8]��Jn_� ���j~����ցV���������1@M�)`F�BM����^x�>
����`��I�˿��wΛ	����W[�����v��E�����u��~��{R�(����3���������y����C��!��nHe�T�Z�����K�P`ǁF´�nH啝���=>id,�>�GW-糓F������m<P8�{o[D����w�Q��=N}�!+�����-�<{[���������w�u�L�����4�����Uc�s��F�륟��c�g�u�s��N��lu���}ן($D��ת8m�Q�V	l�;��(��ڌ���k�
s\��JDIͦOzp��مh����T���IDI���W�Iǧ�X���g��O��a�\:���>����g���%|����i)	�v��]u.�^�:Gk��i)	>��T@k{'	=�������@a�$zZ�;}�󩀒��T�6�Xq&1aWO�,&L�cřT�4P���g[�
p�2��~;� ��Ҭ�29�xri� ��?��)��_��@s[��^�ܴhnɝ4&'
��NanZ4��^Js[ǘ��2���x?Oܷ�$��3�$r����Q��1@�����~��Y�Qܑ�Hjl(}�v�4vSr�iT�1���f������(���A�ᥕ�$� X,�3'�0s����×ƺk~2~'�[�ё�&F�8{2O�y�n�-`^/FPB�?.�N�AO]]�� �n]β[�SR�kN%;>�k��5������]8������=p����Ցh������`}�
�J�8-��ʺ����� �fl˫[8�?E9q�2&������p��<�r�8x� [^݂��2�X��z�V+7N����V@j�A����hl��/+/'5�3�?;9
�(�Ef'Gyҍ���̣�h4RSS� ����������j�Z��jI��x��dE-y�a�X�/�����:��� +k�� �"˖/���+`��],[��UVV4u��P �˻�AA`��)*ZB\\��9lܸ�]{N��礑]6�Hnnqqq-a��Qxy�7�`=8A�Sm&�Q�����u�0hsPz����yJt�[�>�/ޫ�il�����.��ǳ���9��
_
��<s���wT�S������;F����-{k�����T�Z^���z�!t�۰؝^�^*���؝c
���;��7]h^
��PA��+@��gA*+�K��ˌ�)S�1��(Ե��ǯ�h����õ�M�`��p�cC�T")�z�j�w��V��@��D��N�^M\����m�zY��C�Ҙ�I����N�Ϭ��{�9�)����o���C���h�����ʆ.��׏(�ҫ���@�Tf%yZt���wg�4s�]f�q뗣�ǆi�l�⵲3t��I���O��v;Z�g��l��l��kAJѩU^wj�(��������{���)�9�T���KrE�V!�D���aw���x[�I��tZ�0Y �%E�͹���n�G�P�"5FӨ��M�K�!>R���$�.x����h=gϝ�K&@-F��=}�=�����5���s �CFwa���8��u?_����D#���x:R!5&��_�]���*�O��;�)Ȉ�@�g�����ou�Q�v���J�G�6�P�������7��-���	պ^#�C�S��[]3��1���IY��.Ȉ!6\K�:��?9�Ev��S]�l;��?/� ��5�p�X��f�1�;5�S�ye��Ƅ���,Da�>�� O.�AJL(���pL�C5ij޿hBƾ���ڎ�)s��9$D�p���I��e�,ə�+;?�t��v�p�-��&����	V���x���yuo-G&8->�xt�t������Rv��Y�4ZnT�4P]�HA�4�a�T�ǅ1`u\�,���hZ����S������o翿���{�릨ZRq��Y��fat�[����[z9��4�U�V��Anb$Kg������]������8�M0(WeU�H�\n_��¹�C�F�F�}����8d�N��.��]���u�,%Z�F-���E�'����q�L�\������=H�W'�L{�BP0Z���Y�̞���DE��I�N7���c��S���7�Xm�/`�	�+`����X_��KI��^��F\�aD�����~�+M����ㅤ��	SY��/�.�`���:�9Q�c �38K�j�0Y�D�8����W;ܲ�pTt��6P,� Nǵ��Æ�:(���&�N�/ X��i%�?�_P	�n�F�.^�G�E���鬫>?���"@v�2���A~�aԹ_[P, n��N������_rƢ��    IEND�B`�       ECFG	      application/config/name         Kaleidoscoper      application/run/main_scene         res://Main.tscn    application/config/icon         res://icon.png     autoload/HTML5File<      4   *res://addons/HTML5FileExchange/HTML5FileExchange.gd   editor_plugins/enabled8         *   res://addons/HTML5FileExchange/plugin.cfg   )   physics/common/enable_pause_aware_picking         %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2          )   rendering/environment/default_environment          res://default_env.tres                 