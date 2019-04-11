// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Banner"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 20
		_IconTranslation("Icon Translation", Range( 0 , 3)) = 0
		_Apple("Apple", 2D) = "white" {}
		_Castle("Castle", 2D) = "white" {}
		_Lion("Lion", 2D) = "white" {}
		_WaveNoise("Wave Noise", 2D) = "white" {}
		_Border("Border", 2D) = "white" {}
		_InsideColor("Inside Color", Color) = (0,0.751724,1,0)
		_OutsideColor("Outside Color", Color) = (1,0,0,0)
		_BorderColor("Border Color", Color) = (0,0,0,0)
		_WaveSpeed("Wave Speed", Float) = 0
		_Fabric_DISP("Fabric_DISP", 2D) = "white" {}
		_Fabric_NORM("Fabric_NORM", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 1)) = 0
		_AOIntensity("AO Intensity", Range( 0 , 1)) = 0
		_NAbywindPosition("NA by wind Position", Range( 0 , 1)) = 0
		_HorizontalMaxMovement("Horizontal Max Movement", Float) = 0
		_DarkMovementIntensity("Dark Movement Intensity", Range( 0 , 1)) = 0
		_NAbyWindGradient("NA by Wind Gradient", Range( 0 , 1)) = 0.81
		_WaveDirectionMultiplierX("Wave Direction Multiplier X", Range( -1 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _NAbywindPosition;
		uniform float _NAbyWindGradient;
		uniform sampler2D _WaveNoise;
		uniform float _WaveSpeed;
		uniform float _WaveDirectionMultiplierX;
		uniform float _HorizontalMaxMovement;
		uniform sampler2D _Fabric_NORM;
		uniform float4 _Fabric_NORM_ST;
		uniform float _NormalIntensity;
		uniform sampler2D _Border;
		uniform float4 _Border_ST;
		uniform float4 _BorderColor;
		uniform float4 _OutsideColor;
		uniform sampler2D _Apple;
		uniform float4 _Apple_ST;
		uniform float _IconTranslation;
		uniform sampler2D _Castle;
		uniform float4 _Castle_ST;
		uniform sampler2D _Lion;
		uniform float4 _Lion_ST;
		uniform float4 _InsideColor;
		uniform sampler2D _Fabric_DISP;
		uniform float4 _Fabric_DISP_ST;
		uniform float _AOIntensity;
		uniform float _DarkMovementIntensity;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_93_0 = ( 1.0 - ( _NAbywindPosition + ( _NAbyWindGradient * ase_vertex3Pos.y ) ) );
			float2 appendResult82 = (float2(0.0 , _WaveSpeed));
			float2 panner78 = ( 1.0 * _Time.y * appendResult82 + v.texcoord.xy);
			float4 tex2DNode77 = tex2Dlod( _WaveNoise, float4( panner78, 0, 0.0) );
			float3 appendResult150 = (float3(0.0 , 0.0 , (( _HorizontalMaxMovement * -1.0 ) + (_SinTime.w - -1.0) * (_HorizontalMaxMovement - ( _HorizontalMaxMovement * -1.0 )) / (1.0 - -1.0))));
			v.vertex.xyz += ( ( temp_output_93_0 * tex2DNode77.r * ( float3(1,0,0) * _WaveDirectionMultiplierX ) ) + ( temp_output_93_0 * tex2DNode77.r * appendResult150 ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Fabric_NORM = i.uv_texcoord * _Fabric_NORM_ST.xy + _Fabric_NORM_ST.zw;
			float4 lerpResult118 = lerp( float4(0.5019608,0.5019608,1,0) , float4( UnpackNormal( tex2D( _Fabric_NORM, uv_Fabric_NORM ) ) , 0.0 ) , _NormalIntensity);
			o.Normal = lerpResult118.rgb;
			float2 uv_Border = i.uv_texcoord * _Border_ST.xy + _Border_ST.zw;
			float temp_output_68_0 = ( 1.0 - tex2D( _Border, uv_Border ).r );
			float2 uv_Apple = i.uv_texcoord * _Apple_ST.xy + _Apple_ST.zw;
			float lerpResult26 = lerp( 1.0 , tex2D( _Apple, uv_Apple ).r , _IconTranslation);
			float2 uv_Castle = i.uv_texcoord * _Castle_ST.xy + _Castle_ST.zw;
			float lerpResult23 = lerp( lerpResult26 , tex2D( _Castle, uv_Castle ).r , ( _IconTranslation - 1.0 ));
			float2 uv_Lion = i.uv_texcoord * _Lion_ST.xy + _Lion_ST.zw;
			float lerpResult17 = lerp( lerpResult23 , tex2D( _Lion, uv_Lion ).r , ( _IconTranslation - 2.0 ));
			float temp_output_29_0 = saturate( lerpResult17 );
			float2 uv_Fabric_DISP = i.uv_texcoord * _Fabric_DISP_ST.xy + _Fabric_DISP_ST.zw;
			float lerpResult130 = lerp( 1.0 , tex2D( _Fabric_DISP, uv_Fabric_DISP ).r , _AOIntensity);
			float2 appendResult82 = (float2(0.0 , _WaveSpeed));
			float2 panner78 = ( 1.0 * _Time.y * appendResult82 + i.uv_texcoord);
			float4 tex2DNode77 = tex2D( _WaveNoise, panner78 );
			o.Albedo = ( ( ( temp_output_68_0 * _BorderColor ) + ( _OutsideColor * ( temp_output_29_0 - temp_output_68_0 ) ) + ( ( 1.0 - temp_output_29_0 ) * _InsideColor ) ) * lerpResult130 * ( ( 1.0 - _DarkMovementIntensity ) + tex2DNode77.r ) ).rgb;
			o.Occlusion = lerpResult130;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
773;73;640;653;-273.2069;-1924.617;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;76;-788.8801,-717.2262;Float;False;2096.104;1146.268;Banner Color;29;1;24;26;2;27;23;3;25;17;64;68;29;72;69;41;73;42;71;43;40;18;75;50;20;74;44;22;96;97;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1;-738.5805,-413.587;Float;True;Property;_Apple;Apple;6;0;Create;True;0;0;False;0;2c7727759a664e44caf2c1c4f8b5fe06;2c7727759a664e44caf2c1c4f8b5fe06;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-715.6856,167.5308;Float;False;Property;_IconTranslation;Icon Translation;5;0;Create;True;0;0;False;0;0;2;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-420.8569,-407.2697;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-414.4797,-121.7088;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-737.7571,-221.4877;Float;True;Property;_Castle;Castle;7;0;Create;True;0;0;False;0;None;ba0ebd90503bdc44c86bafd9edc0a921;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-215.8943,170.0059;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-736.6725,-27.93476;Float;True;Property;_Lion;Lion;8;0;Create;True;0;0;False;0;None;51da93608d9ca5d4f802d38a416fc186;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;-226.2361,-217.8711;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-48.58583,-27.08326;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;29;302.1339,-116.8335;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;98;-151.2905,863.3979;Float;False;1453.542;1315.027;Waves;22;118;93;77;114;86;123;119;91;78;130;124;87;85;112;116;79;90;92;82;89;83;88;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-126.5048,913.3977;Float;False;Property;_NAbyWindGradient;NA by Wind Gradient;22;0;Create;True;0;0;False;0;0.81;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;41;437.1339,15.16644;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-23.18593,1365.631;Float;False;Property;_WaveSpeed;Wave Speed;14;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-738.8801,-667.2262;Float;True;Property;_Border;Border;10;0;Create;True;0;0;False;0;0c97d7fa79d45e546940fcc50dc08fc8;0c97d7fa79d45e546940fcc50dc08fc8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;88;-77.03027,987.54;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;161;352,2336;Float;False;Property;_HorizontalMaxMovement;Horizontal Max Movement;20;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;192,1008;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;85;536.6831,1922.506;Float;False;Constant;_WaveXDirection;Wave X Direction;11;0;Create;True;0;0;False;0;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;75.81397,1208.631;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;68;302.6241,-642.2675;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;456.683,2067.506;Float;False;Property;_WaveDirectionMultiplierX;Wave Direction Multiplier X;23;0;Create;True;0;0;False;0;0;-1;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;159;480,2208;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;207.0591,937.5953;Float;False;Property;_NAbywindPosition;NA by wind Position;19;0;Create;True;0;0;False;0;0;0.442;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;167.8137,1345.631;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;42;261.1339,31.16638;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;640,2400;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;512,992;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;752,1920;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;160;768,2192;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.1;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;300.0045,86.05959;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;69;488.0128,-568.0048;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;78;340.8137,1271.631;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;72;257.0312,-569.7204;Float;False;Property;_BorderColor;Border Color;13;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;580.1981,-642.6936;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;71;491.6937,-128.9631;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;96;452.3651,148.7191;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;568.6831,1235.506;Float;True;Property;_WaveNoise;Wave Noise;9;0;Create;True;0;0;False;0;None;611322fa830f08a439a04fa2f0521d43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;128;1341.527,1411.872;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;150;976,2240;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;93;640,992;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;250.0908,162.0416;Float;False;Property;_InsideColor;Inside Color;11;0;Create;True;0;0;False;0;0,0.751724,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;124;264.683,1795.506;Float;False;Property;_AOIntensity;AO Intensity;18;0;Create;True;0;0;False;0;0;0.803;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;112;568.6831,1651.506;Float;True;Property;_Fabric_DISP;Fabric_DISP;15;0;Create;True;0;0;False;0;None;9f304c3398b96e34aa7b0168c4156e09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;1555.382,1698.559;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;97;479.5341,173.7677;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;75;982.677,-596.1453;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;548.4494,-117.1288;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;238.1339,-292.8335;Float;False;Property;_OutsideColor;Outside Color;12;0;Create;True;0;0;False;0;1,0,0,0;1,0.616,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;1552,816;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;116;328.683,1619.506;Float;False;Constant;_Color0;Color 0;16;0;Create;True;0;0;False;0;0.5019608,0.5019608,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;155;672,752;Float;False;Property;_DarkMovementIntensity;Dark Movement Intensity;21;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;264.683,1555.506;Float;False;Property;_NormalIntensity;Normal Intensity;17;0;Create;True;0;0;False;0;0;0.187;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;568.6831,1427.506;Float;True;Property;_Fabric_NORM;Fabric_NORM;16;0;Create;True;0;0;False;0;None;1fe2fc3a368fbe647a8c2a173fd22918;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;130;888.6831,1747.506;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;840.4426,-144.3206;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;838.8761,151.6472;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;123;538.754,1618.522;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;156;960,752;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;1973.99,1094.861;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;74;1010.908,-521.851;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;118;955.5989,1582.094;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;1071.224,6.110026;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;153;2208.755,1042.084;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;132;1299.087,1263.665;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;1118.893,761.3832;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;152;1704.981,437.1503;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;131;1344,1264;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;1344,16;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;127;1344,1120;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1776,16;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Banner;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Translucent;0.5;True;False;0;False;Opaque;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;20;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;1;1;1
WireConnection;26;2;24;0
WireConnection;27;0;24;0
WireConnection;25;0;24;0
WireConnection;23;0;26;0
WireConnection;23;1;2;1
WireConnection;23;2;27;0
WireConnection;17;0;23;0
WireConnection;17;1;3;1
WireConnection;17;2;25;0
WireConnection;29;0;17;0
WireConnection;41;0;29;0
WireConnection;90;0;89;0
WireConnection;90;1;88;2
WireConnection;68;0;64;1
WireConnection;82;1;83;0
WireConnection;42;0;41;0
WireConnection;162;0;161;0
WireConnection;91;0;92;0
WireConnection;91;1;90;0
WireConnection;86;0;85;0
WireConnection;86;1;87;0
WireConnection;160;0;159;4
WireConnection;160;3;162;0
WireConnection;160;4;161;0
WireConnection;40;0;42;0
WireConnection;69;0;68;0
WireConnection;78;0;79;0
WireConnection;78;2;82;0
WireConnection;73;0;68;0
WireConnection;73;1;72;0
WireConnection;71;0;69;0
WireConnection;96;0;40;0
WireConnection;77;1;78;0
WireConnection;128;0;86;0
WireConnection;150;2;160;0
WireConnection;93;0;91;0
WireConnection;145;0;93;0
WireConnection;145;1;77;1
WireConnection;145;2;150;0
WireConnection;97;0;96;0
WireConnection;75;0;73;0
WireConnection;50;0;29;0
WireConnection;50;1;71;0
WireConnection;94;0;93;0
WireConnection;94;1;77;1
WireConnection;94;2;128;0
WireConnection;130;1;112;1
WireConnection;130;2;124;0
WireConnection;20;0;18;0
WireConnection;20;1;50;0
WireConnection;44;0;97;0
WireConnection;44;1;43;0
WireConnection;123;0;116;0
WireConnection;156;0;155;0
WireConnection;146;0;94;0
WireConnection;146;1;145;0
WireConnection;74;0;75;0
WireConnection;118;0;123;0
WireConnection;118;1;114;0
WireConnection;118;2;119;0
WireConnection;22;0;74;0
WireConnection;22;1;20;0
WireConnection;22;2;44;0
WireConnection;153;0;146;0
WireConnection;132;0;130;0
WireConnection;154;0;156;0
WireConnection;154;1;77;1
WireConnection;152;0;153;0
WireConnection;131;0;130;0
WireConnection;113;0;22;0
WireConnection;113;1;132;0
WireConnection;113;2;154;0
WireConnection;127;0;118;0
WireConnection;0;0;113;0
WireConnection;0;1;127;0
WireConnection;0;5;131;0
WireConnection;0;11;152;0
ASEEND*/
//CHKSM=1BF384EA875A5BCD5057EB432D0FAB278CC98A45