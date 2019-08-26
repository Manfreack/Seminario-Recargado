// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Landmark"
{
	Properties
	{
		_Landmark_DefaultMaterial_AlbedoTR("Landmark_DefaultMaterial_AlbedoTR", 2D) = "white" {}
		_LandmarkEmission("Landmark Emission", 2D) = "white" {}
		_EmissionColor1("Emission Color 1", Color) = (0.7169812,0,0.4608798,0)
		_EmissionColor2("Emission Color 2", Color) = (0.3312552,1,0,0)
		_EmissionIntensity("Emission Intensity", Range( 0 , 3)) = 0
		_TimeScale("Time Scale", Float) = 1
		_TimeScale2("Time Scale 2", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Landmark_DefaultMaterial_AlbedoTR;
		uniform float4 _Landmark_DefaultMaterial_AlbedoTR_ST;
		uniform sampler2D _LandmarkEmission;
		uniform float4 _LandmarkEmission_ST;
		uniform float _EmissionIntensity;
		uniform float4 _EmissionColor1;
		uniform float4 _EmissionColor2;
		uniform float _TimeScale;
		uniform float _TimeScale2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Landmark_DefaultMaterial_AlbedoTR = i.uv_texcoord * _Landmark_DefaultMaterial_AlbedoTR_ST.xy + _Landmark_DefaultMaterial_AlbedoTR_ST.zw;
			o.Albedo = tex2D( _Landmark_DefaultMaterial_AlbedoTR, uv_Landmark_DefaultMaterial_AlbedoTR ).rgb;
			float2 uv_LandmarkEmission = i.uv_texcoord * _LandmarkEmission_ST.xy + _LandmarkEmission_ST.zw;
			float mulTime24 = _Time.y * _TimeScale;
			float4 lerpResult21 = lerp( _EmissionColor1 , _EmissionColor2 , (0.0 + (sin( mulTime24 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)));
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float mulTime33 = _Time.y * _TimeScale2;
			o.Emission = saturate( ( tex2D( _LandmarkEmission, uv_LandmarkEmission ).r * _EmissionIntensity * ( lerpResult21 * ( ( ase_vertex3Pos.z * 1.0 ) + (-1.0 + (sin( mulTime33 ) - -1.0) * (0.0 - -1.0) / (1.0 - -1.0)) ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
883;73;547;648;783.196;466.3532;2.032005;True;False
Node;AmplifyShaderEditor.RangedFloatNode;25;-1423.504,747.8268;Float;False;Property;_TimeScale;Time Scale;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1560.495,1208.968;Float;False;Property;_TimeScale2;Time Scale 2;9;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;24;-1242.504,747.8268;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-1379.495,1208.968;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;23;-1043.504,743.8268;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1320.652,1111.616;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;27;-1354.65,963.2163;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;34;-1180.495,1204.968;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-724,424;Float;False;Property;_EmissionColor1;Emission Color 1;5;0;Create;True;0;0;False;0;0.7169812,0,0.4608798,0;0.7169812,0,0.4608798,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;26;-842.5034,778.8268;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;35;-979.4941,1239.968;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1127.557,967.3358;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-719.2105,597.4229;Float;False;Property;_EmissionColor2;Emission Color 2;6;0;Create;True;0;0;False;0;0.3312552,1,0,0;0.04557894,0.7264151,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-869.4093,958.1644;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-454.3625,468.2375;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;14;-576,160;Float;True;Property;_LandmarkEmission;Landmark Emission;4;0;Create;True;0;0;False;0;df97beaf6342e8d4db27ffade94e79a4;df97beaf6342e8d4db27ffade94e79a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-560,352;Float;False;Property;_EmissionIntensity;Emission Intensity;7;0;Create;True;0;0;False;0;0;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-265.1006,471.9587;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-240,192;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-481.3,1183.215;Float;True;Property;_Landmark_DefaultMaterial_AO;Landmark_DefaultMaterial_AO;1;0;Create;True;0;0;False;0;e2f27cb4c53bc4d4d92dfc876cac91d0;e2f27cb4c53bc4d4d92dfc876cac91d0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-497.2999,989.2086;Float;True;Property;_Landmark_DefaultMaterial_MetallicSmth;Landmark_DefaultMaterial_MetallicSmth;2;0;Create;True;0;0;False;0;d9e945234d60d2b42b508eea6e4d0421;d9e945234d60d2b42b508eea6e4d0421;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-608,-32;Float;True;Property;_Landmark_DefaultMaterial_Normal;Landmark_DefaultMaterial_Normal;3;0;Create;True;0;0;False;0;fef1ffc045d42c6448c93355ad0559c2;fef1ffc045d42c6448c93355ad0559c2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;37;-84.43805,217.5896;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-608,-224;Float;True;Property;_Landmark_DefaultMaterial_AlbedoTR;Landmark_DefaultMaterial_AlbedoTR;0;0;Create;True;0;0;False;0;3980cc15d119b1c4bbe263f0c5827a7c;3980cc15d119b1c4bbe263f0c5827a7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;104,-5;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Landmark;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;25;0
WireConnection;33;0;32;0
WireConnection;23;0;24;0
WireConnection;34;0;33;0
WireConnection;26;0;23;0
WireConnection;35;0;34;0
WireConnection;29;0;27;3
WireConnection;29;1;28;0
WireConnection;30;0;29;0
WireConnection;30;1;35;0
WireConnection;21;0;17;0
WireConnection;21;1;18;0
WireConnection;21;2;26;0
WireConnection;36;0;21;0
WireConnection;36;1;30;0
WireConnection;15;0;14;1
WireConnection;15;1;16;0
WireConnection;15;2;36;0
WireConnection;37;0;15;0
WireConnection;0;0;1;0
WireConnection;0;2;37;0
ASEEND*/
//CHKSM=A59831743ABF264D255FCB7B3161886A3208948B