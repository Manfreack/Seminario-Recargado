// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Enemy/Blood Pool"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_FillAmount("Fill Amount", Range( 0 , 1)) = 0
		_Vanish("Vanish", Range( 0 , 1)) = 0
		_SplatColor("Splat Color", Color) = (0.6617647,0.01481564,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_VertexOffsetIntensity("Vertex Offset Intensity", Range( 0 , 5)) = 0
		_BloodPool02("Blood Pool 02", 2D) = "white" {}
		_BLOOD_ALB("BLOOD_ALB", 2D) = "white" {}
		_BLOOD_NORM("BLOOD_NORM", 2D) = "bump" {}
		_BLOOD_DISP("BLOOD_DISP", 2D) = "white" {}
		_FlowMap("FlowMap", 2D) = "white" {}
		_UVDistortion("UV Distortion", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BloodPool02;
		uniform float4 _BloodPool02_ST;
		uniform float _VertexOffsetIntensity;
		uniform sampler2D _BLOOD_NORM;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _UVDistortion;
		uniform float4 _SplatColor;
		uniform sampler2D _BLOOD_ALB;
		uniform float _FillAmount;
		uniform sampler2D _BLOOD_DISP;
		uniform float4 _BLOOD_DISP_ST;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Vanish;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_BloodPool02 = v.texcoord * _BloodPool02_ST.xy + _BloodPool02_ST.zw;
			float4 tex2DNode6 = tex2Dlod( _BloodPool02, float4( uv_BloodPool02, 0, 0.0) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( tex2DNode6.r * ase_vertexNormal * _VertexOffsetIntensity );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float4 lerpResult29 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _FlowMap, uv_FlowMap ) , _UVDistortion);
			float2 panner21 = ( 1.0 * _Time.y * float2( 0.005,0.002 ) + lerpResult29.rg);
			float3 NormalMap33 = UnpackNormal( tex2D( _BLOOD_NORM, panner21 ) );
			o.Normal = NormalMap33;
			float4 Albedo34 = ( _SplatColor * tex2D( _BLOOD_ALB, panner21 ).r );
			float2 uv_BloodPool02 = i.uv_texcoord * _BloodPool02_ST.xy + _BloodPool02_ST.zw;
			float4 tex2DNode6 = tex2D( _BloodPool02, uv_BloodPool02 );
			float temp_output_10_0 = floor( ( tex2DNode6.r + (0.6 + (_FillAmount - 0.0) * (0.99 - 0.6) / (1.0 - 0.0)) ) );
			o.Albedo = ( Albedo34 * temp_output_10_0 ).rgb;
			float2 uv_BLOOD_DISP = i.uv_texcoord * _BLOOD_DISP_ST.xy + _BLOOD_DISP_ST.zw;
			float4 tex2DNode35 = tex2D( _BLOOD_DISP, uv_BLOOD_DISP );
			float4 lerpResult36 = lerp( float4( 0,0,0,0 ) , tex2DNode35 , _Metallic);
			float4 Metallic41 = lerpResult36;
			o.Metallic = Metallic41.r;
			float4 lerpResult39 = lerp( float4( 0,0,0,0 ) , tex2DNode35 , _Smoothness);
			float4 Smoothness40 = lerpResult39;
			o.Smoothness = Smoothness40.r;
			o.Alpha = 1;
			clip( ( temp_output_10_0 * ceil( ( tex2D( _BLOOD_DISP, uv_BLOOD_DISP ).r - _Vanish ) ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
1151;73;480;653;875.3928;-33.04581;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;30;-2576,288;Float;False;Property;_UVDistortion;UV Distortion;12;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-2528,0;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-2592,112;Float;True;Property;_FlowMap;FlowMap;11;0;Create;True;0;0;False;0;1207a4adcc48386458eb4425a0a3ecba;1207a4adcc48386458eb4425a0a3ecba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;-2240,0;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;21;-2096,0;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0.005,0.002;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1130.001,262.9001;Float;False;Property;_FillAmount;Fill Amount;1;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-1840,-32;Float;True;Property;_BLOOD_ALB;BLOOD_ALB;8;0;Create;True;0;0;False;0;aafac60e3f8b8d14e8b4c2fd22f4d486;aafac60e3f8b8d14e8b4c2fd22f4d486;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;-1776,-192;Float;False;Property;_SplatColor;Splat Color;3;0;Create;True;0;0;False;0;0.6617647,0.01481564,0,0;0.6617647,0.01481564,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;53;-848,256;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.6;False;4;FLOAT;0.99;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1888,640;Float;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-1904,368;Float;True;Property;_BLOOD_DISP;BLOOD_DISP;10;0;Create;True;0;0;False;0;3b29471e3fa17e14b931c51ab2b62eb9;3b29471e3fa17e14b931c51ab2b62eb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-1888,560;Float;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-960,64;Float;True;Property;_BloodPool02;Blood Pool 02;7;0;Create;True;0;0;False;0;faeec6e22ab5f3f46b64c0a0d2606f92;faeec6e22ab5f3f46b64c0a0d2606f92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1520,-32;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-704,832;Float;False;Property;_Vanish;Vanish;2;0;Create;True;0;0;False;0;0;0.01736122;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;-720,640;Float;True;Property;_Blood_DISP;Blood_DISP;10;0;Create;True;0;0;False;0;3b29471e3fa17e14b931c51ab2b62eb9;3b29471e3fa17e14b931c51ab2b62eb9;True;0;False;white;Auto;False;Instance;35;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1376,-32;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;20;-1840,160;Float;True;Property;_BLOOD_NORM;BLOOD_NORM;9;0;Create;True;0;0;False;0;1b158e9df7465544391f7baab0a3b5c6;1b158e9df7465544391f7baab0a3b5c6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;51;-400,672;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;39;-1536,544;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;36;-1536,432;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-512,240;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;49;-240,672;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;10;-256,240;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-304,-80;Float;False;34;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-1376,432;Float;False;Metallic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-1376,544;Float;False;Smoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;13;-848,416;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-928,560;Float;False;Property;_VertexOffsetIntensity;Vertex Offset Intensity;6;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1376,160;Float;False;NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-96,16;Float;False;33;NormalMap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-96,-80;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-528,336;Float;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-16,240;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-80,80;Float;False;41;Metallic;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-96,144;Float;False;40;Smoothness;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;192,16;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Enemy/Blood Pool;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;29;2;30;0
WireConnection;21;0;29;0
WireConnection;18;1;21;0
WireConnection;53;0;9;0
WireConnection;31;0;32;0
WireConnection;31;1;18;1
WireConnection;34;0;31;0
WireConnection;20;1;21;0
WireConnection;51;0;47;1
WireConnection;51;1;50;0
WireConnection;39;1;35;0
WireConnection;39;2;38;0
WireConnection;36;1;35;0
WireConnection;36;2;37;0
WireConnection;8;0;6;1
WireConnection;8;1;53;0
WireConnection;49;0;51;0
WireConnection;10;0;8;0
WireConnection;41;0;36;0
WireConnection;40;0;39;0
WireConnection;33;0;20;0
WireConnection;12;0;42;0
WireConnection;12;1;10;0
WireConnection;14;0;6;1
WireConnection;14;1;13;0
WireConnection;14;2;15;0
WireConnection;52;0;10;0
WireConnection;52;1;49;0
WireConnection;0;0;12;0
WireConnection;0;1;43;0
WireConnection;0;3;44;0
WireConnection;0;4;45;0
WireConnection;0;10;52;0
WireConnection;0;11;14;0
ASEEND*/
//CHKSM=DA5630B46E3565D102D1AA15DEFCFA278606A515