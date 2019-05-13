// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Medieval Set 1"
{
	Properties
	{
		_Medievalset1_MedievalSet1_AlbedoTR("Medieval set 1_Medieval Set 1_AlbedoTR", 2D) = "white" {}
		_Medievalset1_MedievalSet1_MetallicSmth("Medieval set 1_Medieval Set 1_MetallicSmth", 2D) = "white" {}
		_Medievalset1_MedievalSet1_Normal("Medieval set 1_Medieval Set 1_Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Medievalset1_MedievalSet1_Normal;
		uniform float4 _Medievalset1_MedievalSet1_Normal_ST;
		uniform sampler2D _Medievalset1_MedievalSet1_AlbedoTR;
		uniform float4 _Medievalset1_MedievalSet1_AlbedoTR_ST;
		uniform sampler2D _Medievalset1_MedievalSet1_MetallicSmth;
		uniform float4 _Medievalset1_MedievalSet1_MetallicSmth_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Medievalset1_MedievalSet1_Normal = i.uv_texcoord * _Medievalset1_MedievalSet1_Normal_ST.xy + _Medievalset1_MedievalSet1_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Medievalset1_MedievalSet1_Normal, uv_Medievalset1_MedievalSet1_Normal ) );
			float2 uv_Medievalset1_MedievalSet1_AlbedoTR = i.uv_texcoord * _Medievalset1_MedievalSet1_AlbedoTR_ST.xy + _Medievalset1_MedievalSet1_AlbedoTR_ST.zw;
			o.Albedo = tex2D( _Medievalset1_MedievalSet1_AlbedoTR, uv_Medievalset1_MedievalSet1_AlbedoTR ).rgb;
			float2 uv_Medievalset1_MedievalSet1_MetallicSmth = i.uv_texcoord * _Medievalset1_MedievalSet1_MetallicSmth_ST.xy + _Medievalset1_MedievalSet1_MetallicSmth_ST.zw;
			o.Metallic = tex2D( _Medievalset1_MedievalSet1_MetallicSmth, uv_Medievalset1_MedievalSet1_MetallicSmth ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
603;73;480;341;618.1076;-175.951;1.136633;True;False
Node;AmplifyShaderEditor.SamplerNode;3;-292.6012,482.7936;Float;True;Property;_Medievalset1_MedievalSet1_MetallicSmth;Medieval set 1_Medieval Set 1_MetallicSmth;2;0;Create;True;0;0;False;0;0d06716ed8255db45b78eebd704eef9a;0d06716ed8255db45b78eebd704eef9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-297.2014,678.5122;Float;True;Property;_Medievalset1_MedievalSet1_Normal;Medieval set 1_Medieval Set 1_Normal;3;0;Create;True;0;0;False;0;8bc2eed1e2fa4244aaef8da3ee956d6e;8bc2eed1e2fa4244aaef8da3ee956d6e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-292.6014,292.4687;Float;True;Property;_Medievalset1_MedievalSet1_AlbedoTR;Medieval set 1_Medieval Set 1_AlbedoTR;0;0;Create;True;0;0;False;0;9f9d867cfadd63041a8d74f87c967a24;9f9d867cfadd63041a8d74f87c967a24;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-292.8548,100.9257;Float;True;Property;_Medievalset1_MedievalSet1_Height;Medieval set 1_Medieval Set 1_Height;1;0;Create;True;0;0;False;0;c7b8b35281ca28347af0e2588050a5cb;c7b8b35281ca28347af0e2588050a5cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;336.1925,305.2545;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Medieval Set 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;1;0
WireConnection;0;1;4;0
WireConnection;0;3;3;1
ASEEND*/
//CHKSM=7C217763CF8A0D8FEDD0567F4AE7989A2FBF88D6