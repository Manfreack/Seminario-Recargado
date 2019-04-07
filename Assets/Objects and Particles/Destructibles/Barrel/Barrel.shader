// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Barrel"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 50
		_Barrel_DefaultMaterial_AlbedoTR("Barrel_DefaultMaterial_AlbedoTR", 2D) = "white" {}
		_Barrel_DefaultMaterial_Normal("Barrel_DefaultMaterial_Normal", 2D) = "bump" {}
		_Barrel_DefaultMaterial_MetallicSmth("Barrel_DefaultMaterial_MetallicSmth", 2D) = "white" {}
		_Barrel_DefaultMaterial_AO("Barrel_DefaultMaterial_AO", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Barrel_DefaultMaterial_Height("Barrel_DefaultMaterial_Height", 2D) = "white" {}
		_Height("Height", Range( 0 , 0.2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Barrel_DefaultMaterial_Height;
		uniform float4 _Barrel_DefaultMaterial_Height_ST;
		uniform float _Height;
		uniform sampler2D _Barrel_DefaultMaterial_Normal;
		uniform float4 _Barrel_DefaultMaterial_Normal_ST;
		uniform sampler2D _Barrel_DefaultMaterial_AlbedoTR;
		uniform float4 _Barrel_DefaultMaterial_AlbedoTR_ST;
		uniform sampler2D _Barrel_DefaultMaterial_AO;
		uniform float4 _Barrel_DefaultMaterial_AO_ST;
		uniform sampler2D _Barrel_DefaultMaterial_MetallicSmth;
		uniform float4 _Barrel_DefaultMaterial_MetallicSmth_ST;
		uniform float _Smoothness;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_Barrel_DefaultMaterial_Height = v.texcoord * _Barrel_DefaultMaterial_Height_ST.xy + _Barrel_DefaultMaterial_Height_ST.zw;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( tex2Dlod( _Barrel_DefaultMaterial_Height, float4( uv_Barrel_DefaultMaterial_Height, 0, 0.0) ).r * ase_vertexNormal * _Height );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Barrel_DefaultMaterial_Normal = i.uv_texcoord * _Barrel_DefaultMaterial_Normal_ST.xy + _Barrel_DefaultMaterial_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Barrel_DefaultMaterial_Normal, uv_Barrel_DefaultMaterial_Normal ) );
			float2 uv_Barrel_DefaultMaterial_AlbedoTR = i.uv_texcoord * _Barrel_DefaultMaterial_AlbedoTR_ST.xy + _Barrel_DefaultMaterial_AlbedoTR_ST.zw;
			float2 uv_Barrel_DefaultMaterial_AO = i.uv_texcoord * _Barrel_DefaultMaterial_AO_ST.xy + _Barrel_DefaultMaterial_AO_ST.zw;
			float lerpResult15 = lerp( 1.0 , tex2D( _Barrel_DefaultMaterial_AO, uv_Barrel_DefaultMaterial_AO ).r , 0.0);
			float blendOpSrc16 = tex2D( _Barrel_DefaultMaterial_AlbedoTR, uv_Barrel_DefaultMaterial_AlbedoTR ).r;
			float blendOpDest16 = lerpResult15;
			float3 temp_cast_0 = (( saturate( ( blendOpSrc16 * blendOpDest16 ) ))).xxx;
			o.Albedo = temp_cast_0;
			float2 uv_Barrel_DefaultMaterial_MetallicSmth = i.uv_texcoord * _Barrel_DefaultMaterial_MetallicSmth_ST.xy + _Barrel_DefaultMaterial_MetallicSmth_ST.zw;
			o.Metallic = tex2D( _Barrel_DefaultMaterial_MetallicSmth, uv_Barrel_DefaultMaterial_MetallicSmth ).r;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
948;73;614;653;678.8165;191.1702;1.980391;False;False
Node;AmplifyShaderEditor.SamplerNode;5;-544,320;Float;True;Property;_Barrel_DefaultMaterial_AO;Barrel_DefaultMaterial_AO;9;0;Create;True;0;0;False;0;None;6d2c6e54f713b684fa8a24d9144c3d75;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-512,256;Float;False;Constant;_AOIntensity;AO Intensity;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;15;-208.6579,274.752;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-608,-352;Float;True;Property;_Barrel_DefaultMaterial_AlbedoTR;Barrel_DefaultMaterial_AlbedoTR;6;0;Create;True;0;0;False;0;None;a479de0cf0337b24f814da88f80f5995;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-512,816;Float;False;Property;_Height;Height;12;0;Create;True;0;0;False;0;0;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;12;-432,688;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-576,512;Float;True;Property;_Barrel_DefaultMaterial_Height;Barrel_DefaultMaterial_Height;11;0;Create;True;0;0;False;0;None;28b7da785da48ed46a1a0da4f62e00a9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;16;-96,-128;Float;False;Multiply;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-512,192;Float;False;Property;_Smoothness;Smoothness;10;0;Create;True;0;0;False;0;0;0.357;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-592,0;Float;True;Property;_Barrel_DefaultMaterial_MetallicSmth;Barrel_DefaultMaterial_MetallicSmth;8;0;Create;True;0;0;False;0;None;d30e223cde712bc4bb65d788f8fc0ec4;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-592,-176;Float;True;Property;_Barrel_DefaultMaterial_Normal;Barrel_DefaultMaterial_Normal;7;0;Create;True;0;0;False;0;None;d30e223cde712bc4bb65d788f8fc0ec4;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-144,544;Float;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;208,16;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Barrel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;50;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;1;5;1
WireConnection;15;2;14;0
WireConnection;16;0;2;1
WireConnection;16;1;15;0
WireConnection;13;0;7;1
WireConnection;13;1;12;0
WireConnection;13;2;10;0
WireConnection;0;0;16;0
WireConnection;0;1;3;0
WireConnection;0;3;4;1
WireConnection;0;4;6;0
WireConnection;0;11;13;0
ASEEND*/
//CHKSM=377D62E6492D5EA5AB39A5BE01C3B692E34D023C