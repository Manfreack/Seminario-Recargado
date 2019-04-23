// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Player/Warrior"
{
	Properties
	{
		_WarriorPoseTV2UV_DownArmour_AlbedoTransparency("Warrior PoseT V2(UV)_DownArmour_AlbedoTransparency", 2D) = "white" {}
		_WarriorPoseTV2UV_DownArmour_Normal("Warrior PoseT V2(UV)_DownArmour_Normal", 2D) = "bump" {}
		_WarriorPoseTV2UV_DownArmour_Emission("Warrior PoseT V2(UV)_DownArmour_Emission", 2D) = "white" {}
		_EmmisionColor("Emmision Color", Color) = (0.6792453,0.5276874,0.2851548,0)
		_EmissionIntensity("Emission Intensity", Range( 0 , 1)) = 0
		_WarriorPoseTV2UV_DownArmour_MetallicSmoothness("Warrior PoseT V2(UV)_DownArmour_MetallicSmoothness", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _WarriorPoseTV2UV_DownArmour_Normal;
		uniform float4 _WarriorPoseTV2UV_DownArmour_Normal_ST;
		uniform sampler2D _WarriorPoseTV2UV_DownArmour_AlbedoTransparency;
		uniform float4 _WarriorPoseTV2UV_DownArmour_AlbedoTransparency_ST;
		uniform float4 _EmmisionColor;
		uniform sampler2D _WarriorPoseTV2UV_DownArmour_Emission;
		uniform float4 _WarriorPoseTV2UV_DownArmour_Emission_ST;
		uniform float _EmissionIntensity;
		uniform sampler2D _WarriorPoseTV2UV_DownArmour_MetallicSmoothness;
		uniform float4 _WarriorPoseTV2UV_DownArmour_MetallicSmoothness_ST;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_WarriorPoseTV2UV_DownArmour_Normal = i.uv_texcoord * _WarriorPoseTV2UV_DownArmour_Normal_ST.xy + _WarriorPoseTV2UV_DownArmour_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _WarriorPoseTV2UV_DownArmour_Normal, uv_WarriorPoseTV2UV_DownArmour_Normal ) );
			float2 uv_WarriorPoseTV2UV_DownArmour_AlbedoTransparency = i.uv_texcoord * _WarriorPoseTV2UV_DownArmour_AlbedoTransparency_ST.xy + _WarriorPoseTV2UV_DownArmour_AlbedoTransparency_ST.zw;
			o.Albedo = tex2D( _WarriorPoseTV2UV_DownArmour_AlbedoTransparency, uv_WarriorPoseTV2UV_DownArmour_AlbedoTransparency ).rgb;
			float2 uv_WarriorPoseTV2UV_DownArmour_Emission = i.uv_texcoord * _WarriorPoseTV2UV_DownArmour_Emission_ST.xy + _WarriorPoseTV2UV_DownArmour_Emission_ST.zw;
			o.Emission = ( _EmmisionColor * tex2D( _WarriorPoseTV2UV_DownArmour_Emission, uv_WarriorPoseTV2UV_DownArmour_Emission ) * _EmissionIntensity ).rgb;
			float2 uv_WarriorPoseTV2UV_DownArmour_MetallicSmoothness = i.uv_texcoord * _WarriorPoseTV2UV_DownArmour_MetallicSmoothness_ST.xy + _WarriorPoseTV2UV_DownArmour_MetallicSmoothness_ST.zw;
			float4 tex2DNode7 = tex2D( _WarriorPoseTV2UV_DownArmour_MetallicSmoothness, uv_WarriorPoseTV2UV_DownArmour_MetallicSmoothness );
			float4 lerpResult8 = lerp( float4( 0,0,0,0 ) , tex2DNode7 , _Metallic);
			o.Metallic = lerpResult8.r;
			float4 lerpResult14 = lerp( float4( 0,0,0,0 ) , tex2DNode7 , _Smoothness);
			o.Smoothness = lerpResult14.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
312;188;1025;710;1269.313;-228.4143;1.373993;True;False
Node;AmplifyShaderEditor.SamplerNode;7;-736,576;Float;True;Property;_WarriorPoseTV2UV_DownArmour_MetallicSmoothness;Warrior PoseT V2(UV)_DownArmour_MetallicSmoothness;5;0;Create;True;0;0;False;0;c02e76cfd5cbc4d489515ff26886ca89;c0a559c2ca233054eb74bd4aa76fc8c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-400,688;Float;False;Property;_Metallic;Metallic;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-400,912;Float;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-624,304;Float;False;Property;_EmissionIntensity;Emission Intensity;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-480,384;Float;True;Property;_WarriorPoseTV2UV_DownArmour_Emission;Warrior PoseT V2(UV)_DownArmour_Emission;2;0;Create;True;0;0;False;0;e1bd81564775dbf40b07f4fd948e392b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-368,192;Float;False;Property;_EmmisionColor;Emmision Color;3;0;Create;True;0;0;False;0;0.6792453,0.5276874,0.2851548,0;0.6792453,0.5276874,0.2851548,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;16;-432.0627,790.8646;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-448,-176;Float;True;Property;_WarriorPoseTV2UV_DownArmour_AlbedoTransparency;Warrior PoseT V2(UV)_DownArmour_AlbedoTransparency;0;0;Create;True;0;0;False;0;b447421658834544686936f5b3310ea5;2aaa4b4a7e8b6ef45b0e38fe18d93533;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-448,0;Float;True;Property;_WarriorPoseTV2UV_DownArmour_Normal;Warrior PoseT V2(UV)_DownArmour_Normal;1;0;Create;True;0;0;False;0;b01dcf2a84ee0e84489daa3e647f6eb5;9ee3920ef897d34488411fe6327fdcbb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-115,263;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;8;-128,560;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;-128,784;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;164.1978,216.1978;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Player/Warrior;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;7;0
WireConnection;5;0;4;0
WireConnection;5;1;3;0
WireConnection;5;2;6;0
WireConnection;8;1;7;0
WireConnection;8;2;10;0
WireConnection;14;1;16;0
WireConnection;14;2;13;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;5;0
WireConnection;0;3;8;0
WireConnection;0;4;14;0
ASEEND*/
//CHKSM=C11DDBAD64294B017FA41D215DA27DA5F8BDF506