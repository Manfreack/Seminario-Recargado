// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Force Field"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 24
		_NoiseSeamless("Noise Seamless", 2D) = "white" {}
		_ColorinWhite("Color in White", Color) = (1,0.9310346,0,0)
		_ColorinBlack("Color in Black", Color) = (1,0,0,0)
		_FillAmount("Fill Amount", Range( 0 , 1)) = 0.5285062
		_BorderAmount("Border Amount", Range( 0 , 0.1)) = 0.05327978
		_BorderColor("Border Color", Color) = (0,0,0,0)
		_BorderOpacity("Border Opacity", Range( 0 , 1)) = 0
		_BGSpeedY("BG Speed Y", Range( -0.1 , 0.1)) = -0.1
		_BGSpeedX("BG Speed X", Range( -0.1 , 0.1)) = 0.1
		_BGSpeedMultiplier("BG Speed Multiplier", Range( 0 , 2)) = 1.137254
		_Flowmap2("Flowmap2", 2D) = "white" {}
		_DepthFadeAmount("Depth Fade Amount", Range( 0 , 1)) = 0.2
		_Waves("Waves", 2D) = "white" {}
		_GlobalOpacity("Global Opacity", Range( 0 , 1)) = 0
		_FlowMapIntensity("FlowMap Intensity", Range( 0 , 1)) = 0
		_Snow("Snow", 2D) = "white" {}
		_MovementIntensity("Movement Intensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _Waves;
		uniform float _MovementIntensity;
		uniform float4 _ColorinBlack;
		uniform float4 _ColorinWhite;
		uniform sampler2D _NoiseSeamless;
		uniform float _BGSpeedX;
		uniform float _BGSpeedMultiplier;
		uniform float _BGSpeedY;
		uniform sampler2D _Flowmap2;
		uniform float _FlowMapIntensity;
		uniform float _FillAmount;
		uniform float _BorderAmount;
		uniform float4 _BorderColor;
		uniform float _BorderOpacity;
		uniform sampler2D _Snow;
		uniform sampler2D _CameraDepthTexture;
		uniform float _DepthFadeAmount;
		uniform float _GlobalOpacity;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 panner102 = ( 1.0 * _Time.y * float2( 0.1,-0.05 ) + v.texcoord.xy);
			float3 ase_vertexNormal = v.normal.xyz;
			float3 FinalVertexOffset124 = ( tex2Dlod( _Waves, float4( panner102, 0, 0.0) ).r * ase_vertexNormal * _MovementIntensity );
			v.vertex.xyz += FinalVertexOffset124;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult26 = (float2(( _BGSpeedX * _BGSpeedMultiplier ) , ( _BGSpeedMultiplier * _BGSpeedY )));
			float2 uv_TexCoord126 = i.uv_texcoord * float2( 4,4 );
			float4 lerpResult52 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _Flowmap2, uv_TexCoord126 ) , _FlowMapIntensity);
			float4 Flowmap77 = lerpResult52;
			float2 panner20 = ( _Time.y * appendResult26 + Flowmap77.rg);
			float BGNoise81 = tex2D( _NoiseSeamless, panner20 ).r;
			float4 lerpResult4 = lerp( _ColorinBlack , _ColorinWhite , BGNoise81);
			float4 BGColor113 = lerpResult4;
			float temp_output_8_0 = ( _FillAmount - BGNoise81 );
			float temp_output_14_0 = saturate( ceil( ( temp_output_8_0 + _BorderAmount ) ) );
			float4 BorderColor74 = _BorderColor;
			float4 FinalAlbedo122 = ( BGColor113 + ( ( temp_output_14_0 - saturate( ceil( temp_output_8_0 ) ) ) * BorderColor74 * _BorderOpacity ) );
			o.Albedo = FinalAlbedo122.rgb;
			float2 appendResult120 = (float2(0.1 , -0.05));
			float2 panner60 = ( 1.0 * _Time.y * appendResult120 + Flowmap77.rg);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth70 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float distanceDepth70 = abs( ( screenDepth70 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeAmount ) );
			float clampResult71 = clamp( distanceDepth70 , 0.0 , 1.0 );
			float4 lerpResult72 = lerp( BorderColor74 , saturate( ( ( 1.0 - ( tex2D( _Snow, panner60 ).r + 0.4 ) ) * BGColor113 ) ) , clampResult71);
			float4 FinalEmission117 = lerpResult72;
			o.Emission = FinalEmission117.rgb;
			float FinalOpacity111 = ( _GlobalOpacity * ( BGNoise81 * temp_output_14_0 ) );
			o.Alpha = FinalOpacity111;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
829;92;727;655;2264.622;1675.145;3.033516;False;False
Node;AmplifyShaderEditor.Vector2Node;127;-2742.268,-12.71045;Float;False;Constant;_Vector0;Vector 0;19;0;Create;True;0;0;False;0;4,4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;126;-2594.268,-72.71045;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-2240,-160;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-2592,288;Float;False;Property;_BGSpeedX;BG Speed X;14;0;Create;True;0;0;False;0;0.1;0.1;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;-2304,-48;Float;True;Property;_Flowmap2;Flowmap2;16;0;Create;True;0;0;False;0;1207a4adcc48386458eb4425a0a3ecba;1207a4adcc48386458eb4425a0a3ecba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-2592,352;Float;False;Property;_BGSpeedMultiplier;BG Speed Multiplier;15;0;Create;True;0;0;False;0;1.137254;0.26;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2592,416;Float;False;Property;_BGSpeedY;BG Speed Y;13;0;Create;True;0;0;False;0;-0.1;-0.1;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2288,144;Float;False;Property;_FlowMapIntensity;FlowMap Intensity;20;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2304,304;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-1920,96;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2304,384;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-2080,336;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-2112,432;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2128,256;Float;False;77;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1744,96;Float;False;Flowmap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;20;-1920,304;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-2464,-304;Float;False;Constant;_Y;Y;19;0;Create;True;0;0;False;0;-0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2464,-368;Float;False;Constant;_X;X;19;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1728,272;Float;True;Property;_NoiseSeamless;Noise Seamless;6;0;Create;True;0;0;False;0;96ae006e06772704bbed55377b01f931;96ae006e06772704bbed55377b01f931;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;120;-2288,-320;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-2352,1040;Float;False;81;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-2464,-432;Float;False;77;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-1408,304;Float;False;BGNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2448,976;Float;False;Property;_FillAmount;Fill Amount;9;0;Create;True;0;0;False;0;0.5285062;0.709;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2448,912;Float;False;Property;_BorderAmount;Border Amount;10;0;Create;True;0;0;False;0;0.05327978;0.0038;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-2160,992;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;60;-2144,-368;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;3;-1407.307,140.4517;Float;False;Property;_ColorinWhite;Color in White;7;0;Create;True;0;0;False;0;1,0.9310346,0,0;1,0.9310346,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;-1824,-208;Float;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-1952,-400;Float;True;Property;_Snow;Snow;21;0;Create;True;0;0;False;0;19ccfdaff4245fb42850b62f3440c776;19ccfdaff4245fb42850b62f3440c776;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-2016,912;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1407.307,-19.54835;Float;False;Property;_ColorinBlack;Color in Black;8;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CeilOpNode;7;-1904,992;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;12;-1904,912;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-1119.306,92.45169;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-1648,-320;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-864,80;Float;False;BGColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;15;-1776,992;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-1632,528;Float;False;Property;_BorderColor;Border Color;11;0;Create;True;0;0;False;0;0,0,0,0;1,0.724138,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-2175.748,1294.779;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-1680,-144;Float;False;Property;_DepthFadeAmount;Depth Fade Amount;17;0;Create;True;0;0;False;0;0.2;0.179;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;-1520,-320;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;103;-2143.748,1406.779;Float;False;Constant;_Vector1;Vector 1;19;0;Create;True;0;0;False;0;0.1,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;14;-1776,912;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-1536,-256;Float;False;113;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-1808,816;Float;False;81;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-1584,976;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;70;-1408,-144;Float;False;True;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1728,1152;Float;False;Property;_BorderOpacity;Border Opacity;12;0;Create;True;0;0;False;0;0;0.635399;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;102;-1919.748,1326.779;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-1408,512;Float;False;BorderColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-1648,1072;Float;False;74;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1344,-272;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-1440,960;Float;False;113;0;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1695.748,1598.779;Float;False;Property;_MovementIntensity;Movement Intensity;22;0;Create;True;0;0;False;0;0;0.099;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;71;-1200,-192;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;66;-1200,-272;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1392,1040;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1632,752;Float;False;Property;_GlobalOpacity;Global Opacity;19;0;Create;True;0;0;False;0;0;0.714;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1584,848;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;101;-1727.748,1294.779;Float;True;Property;_Waves;Waves;18;0;Create;True;0;0;False;0;faaa54b5537f89c4b8ac7b11c506428e;faaa54b5537f89c4b8ac7b11c506428e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;86;-1615.748,1470.779;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;76;-1248,-352;Float;False;74;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1232,1008;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;72;-1024,-288;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-1332.416,1462.283;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1312,800;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-720,800;Float;False;124;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-1104,1456;Float;False;FinalVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-688,576;Float;False;117;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-1168,800;Float;False;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-1104,1008;Float;False;FinalAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-672,720;Float;False;111;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-672,496;Float;False;122;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-864,-288;Float;False;FinalEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-464,512;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Force Field;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;24;1;10;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;126;0;127;0
WireConnection;50;1;126;0
WireConnection;31;0;27;0
WireConnection;31;1;30;0
WireConnection;52;0;21;0
WireConnection;52;1;50;0
WireConnection;52;2;54;0
WireConnection;29;0;30;0
WireConnection;29;1;28;0
WireConnection;26;0;31;0
WireConnection;26;1;29;0
WireConnection;77;0;52;0
WireConnection;20;0;78;0
WireConnection;20;2;26;0
WireConnection;20;1;25;0
WireConnection;5;1;20;0
WireConnection;120;0;118;0
WireConnection;120;1;119;0
WireConnection;81;0;5;1
WireConnection;8;0;9;0
WireConnection;8;1;84;0
WireConnection;60;0;79;0
WireConnection;60;2;120;0
WireConnection;59;1;60;0
WireConnection;11;0;8;0
WireConnection;11;1;10;0
WireConnection;7;0;8;0
WireConnection;12;0;11;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;81;0
WireConnection;63;0;59;1
WireConnection;63;1;64;0
WireConnection;113;0;4;0
WireConnection;15;0;7;0
WireConnection;62;0;63;0
WireConnection;14;0;12;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;70;0;69;0
WireConnection;102;0;104;0
WireConnection;102;2;103;0
WireConnection;74;0;17;0
WireConnection;65;0;62;0
WireConnection;65;1;116;0
WireConnection;71;0;70;0
WireConnection;66;0;65;0
WireConnection;18;0;16;0
WireConnection;18;1;75;0
WireConnection;18;2;32;0
WireConnection;45;0;83;0
WireConnection;45;1;14;0
WireConnection;101;1;102;0
WireConnection;49;0;114;0
WireConnection;49;1;18;0
WireConnection;72;0;76;0
WireConnection;72;1;66;0
WireConnection;72;2;71;0
WireConnection;87;0;101;1
WireConnection;87;1;86;0
WireConnection;87;2;88;0
WireConnection;58;0;57;0
WireConnection;58;1;45;0
WireConnection;124;0;87;0
WireConnection;111;0;58;0
WireConnection;122;0;49;0
WireConnection;117;0;72;0
WireConnection;0;0;123;0
WireConnection;0;2;121;0
WireConnection;0;9;112;0
WireConnection;0;11;125;0
ASEEND*/
//CHKSM=CB6E74F866901F928B2304A7FEC184950554EC3B