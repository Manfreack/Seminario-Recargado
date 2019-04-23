// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Fog2"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_EmissionSubstractor("Emission Substractor", Range( 0 , 1)) = 0
		_UVTiling("UV Tiling", Vector) = (0,0,0,0)
		_BaseFog("Base Fog", 2D) = "white" {}
		_Flowmap("Flowmap", 2D) = "white" {}
		_UVDistortion_1("UV Distortion_1", Range( 0 , 1)) = 0.3
		_FogBrightness_1("Fog Brightness_1", Float) = 0
		_HMovement_1("H Movement_1", Range( -0.0005 , 0.0005)) = 0
		_VMinMovement_1("V Min Movement_1", Range( 0 , -0.001)) = 0
		_VMaxMovement_1("V Max Movement_1", Range( 0 , 0.001)) = 0
		_UVDistortion_2("UV Distortion_2", Range( 0 , 1)) = 0.3
		_FogBrightness_2("Fog Brightness_2", Float) = 0
		_HMovement_2("H Movement_2", Range( -0.0005 , 0.0005)) = 0
		_VMinMovement_2("V Min Movement_2", Range( 0 , 0.001)) = 0
		_VMaxMovement_2("V Max Movement_2", Range( 0 , 0.001)) = 0
		_UVDistortion_3("UV Distortion_3", Range( 0 , 1)) = 0.3
		_FogBrightness_3("Fog Brightness_3", Float) = 0
		_HMovement_3("H Movement_3", Range( -0.0005 , 0.0005)) = 0
		_VMinMovement_3("V Min Movement_3", Range( 0 , 0.001)) = 0
		_VMaxMovement_3("V Max Movement_3", Range( 0 , 0.001)) = 0
		_VertexOffsetMultiplier("Vertex Offset Multiplier", Float) = 0
		_MidGradient("Mid Gradient", Range( 0 , 0.5)) = 0
		_MidPosition("Mid Position", Range( 0 , 2)) = 0
		_EndGradient("End Gradient", Range( -0.5 , 0.5)) = 0
		_EndPosition("End Position", Range( 0 , 2)) = 0
		_MidEndLerp("Mid-End Lerp", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		BlendOp Add , Add
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _FogBrightness_1;
		uniform sampler2D _BaseFog;
		uniform float _HMovement_1;
		uniform float _VMinMovement_1;
		uniform float _VMaxMovement_1;
		uniform float2 _UVTiling;
		uniform sampler2D _Flowmap;
		uniform float _UVDistortion_1;
		uniform float _FogBrightness_2;
		uniform float _HMovement_2;
		uniform float _VMinMovement_2;
		uniform float _VMaxMovement_2;
		uniform float _UVDistortion_2;
		uniform float _FogBrightness_3;
		uniform float _HMovement_3;
		uniform float _VMinMovement_3;
		uniform float _VMaxMovement_3;
		uniform float _UVDistortion_3;
		uniform float _VertexOffsetMultiplier;
		uniform float _EmissionSubstractor;
		uniform float _MidGradient;
		uniform float _MidPosition;
		uniform float _EndGradient;
		uniform float _EndPosition;
		uniform float _MidEndLerp;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 appendResult13_g20 = (float2(_HMovement_1 , (_VMinMovement_1 + (_SinTime.w - -1.0) * (_VMaxMovement_1 - _VMinMovement_1) / (1.0 - -1.0))));
			float2 uv_TexCoord10_g20 = v.texcoord.xy * _UVTiling;
			float4 lerpResult12_g20 = lerp( float4( uv_TexCoord10_g20, 0.0 , 0.0 ) , tex2Dlod( _Flowmap, float4( uv_TexCoord10_g20, 0, 0.0) ) , _UVDistortion_1);
			float2 panner21_g20 = ( _Time.y * appendResult13_g20 + lerpResult12_g20.rg);
			float2 appendResult13_g21 = (float2(_HMovement_2 , (_VMinMovement_2 + (_SinTime.w - -1.0) * (_VMaxMovement_2 - _VMinMovement_2) / (1.0 - -1.0))));
			float2 uv_TexCoord10_g21 = v.texcoord.xy * _UVTiling;
			float4 lerpResult12_g21 = lerp( float4( uv_TexCoord10_g21, 0.0 , 0.0 ) , tex2Dlod( _Flowmap, float4( uv_TexCoord10_g21, 0, 0.0) ) , _UVDistortion_2);
			float2 panner21_g21 = ( _Time.y * appendResult13_g21 + lerpResult12_g21.rg);
			float2 appendResult13_g22 = (float2(_HMovement_3 , (_VMinMovement_3 + (_SinTime.w - -1.0) * (_VMaxMovement_3 - _VMinMovement_3) / (1.0 - -1.0))));
			float2 uv_TexCoord10_g22 = v.texcoord.xy * _UVTiling;
			float4 lerpResult12_g22 = lerp( float4( uv_TexCoord10_g22, 0.0 , 0.0 ) , tex2Dlod( _Flowmap, float4( uv_TexCoord10_g22, 0, 0.0) ) , _UVDistortion_3);
			float2 panner21_g22 = ( _Time.y * appendResult13_g22 + lerpResult12_g22.rg);
			float temp_output_49_0 = saturate( ( ( ( _FogBrightness_1 + tex2Dlod( _BaseFog, float4( panner21_g20, 0, 0.0) ).r ) / 3.0 ) + ( ( _FogBrightness_2 + tex2Dlod( _BaseFog, float4( panner21_g21, 0, 0.0) ).r ) / 3.0 ) + ( ( _FogBrightness_3 + tex2Dlod( _BaseFog, float4( panner21_g22, 0, 0.0) ).r ) / 3.0 ) ) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( temp_output_49_0 * ase_vertexNormal * _VertexOffsetMultiplier );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult13_g20 = (float2(_HMovement_1 , (_VMinMovement_1 + (_SinTime.w - -1.0) * (_VMaxMovement_1 - _VMinMovement_1) / (1.0 - -1.0))));
			float2 uv_TexCoord10_g20 = i.uv_texcoord * _UVTiling;
			float4 lerpResult12_g20 = lerp( float4( uv_TexCoord10_g20, 0.0 , 0.0 ) , tex2D( _Flowmap, uv_TexCoord10_g20 ) , _UVDistortion_1);
			float2 panner21_g20 = ( _Time.y * appendResult13_g20 + lerpResult12_g20.rg);
			float2 appendResult13_g21 = (float2(_HMovement_2 , (_VMinMovement_2 + (_SinTime.w - -1.0) * (_VMaxMovement_2 - _VMinMovement_2) / (1.0 - -1.0))));
			float2 uv_TexCoord10_g21 = i.uv_texcoord * _UVTiling;
			float4 lerpResult12_g21 = lerp( float4( uv_TexCoord10_g21, 0.0 , 0.0 ) , tex2D( _Flowmap, uv_TexCoord10_g21 ) , _UVDistortion_2);
			float2 panner21_g21 = ( _Time.y * appendResult13_g21 + lerpResult12_g21.rg);
			float2 appendResult13_g22 = (float2(_HMovement_3 , (_VMinMovement_3 + (_SinTime.w - -1.0) * (_VMaxMovement_3 - _VMinMovement_3) / (1.0 - -1.0))));
			float2 uv_TexCoord10_g22 = i.uv_texcoord * _UVTiling;
			float4 lerpResult12_g22 = lerp( float4( uv_TexCoord10_g22, 0.0 , 0.0 ) , tex2D( _Flowmap, uv_TexCoord10_g22 ) , _UVDistortion_3);
			float2 panner21_g22 = ( _Time.y * appendResult13_g22 + lerpResult12_g22.rg);
			float temp_output_49_0 = saturate( ( ( ( _FogBrightness_1 + tex2D( _BaseFog, panner21_g20 ).r ) / 3.0 ) + ( ( _FogBrightness_2 + tex2D( _BaseFog, panner21_g21 ).r ) / 3.0 ) + ( ( _FogBrightness_3 + tex2D( _BaseFog, panner21_g22 ).r ) / 3.0 ) ) );
			float3 temp_cast_6 = (temp_output_49_0).xxx;
			o.Albedo = temp_cast_6;
			float3 temp_cast_7 = (saturate( ( temp_output_49_0 - _EmissionSubstractor ) )).xxx;
			o.Emission = temp_cast_7;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float lerpResult108 = lerp( saturate( ( ( ase_vertex3Pos.z * _MidGradient ) + _MidPosition ) ) , saturate( ( ( ase_vertex3Pos.x * _EndGradient ) + _EndPosition ) ) , _MidEndLerp);
			o.Alpha = saturate( ( temp_output_49_0 * lerpResult108 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
931;92;480;650;2504.887;376.7916;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;56;-2432,-224;Float;True;Property;_Flowmap;Flowmap;9;0;Create;True;0;0;False;0;a57dbc2ece21ece4ab0a8c7746bdc568;a57dbc2ece21ece4ab0a8c7746bdc568;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;122;-2186.818,205.992;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;72;-2208,-736;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-2016,478.9096;Float;False;Property;_VMaxMovement_3;V Max Movement_3;24;0;Create;True;0;0;False;0;0;0;0;0.001;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2016,270.9096;Float;False;Property;_UVDistortion_3;UV Distortion_3;20;0;Create;True;0;0;False;0;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-2016,350.9096;Float;False;Property;_HMovement_3;H Movement_3;22;0;Create;True;0;0;False;0;0;0.05;-0.0005;0.0005;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-1920,574.9096;Float;False;Constant;_TimeScale_3;Time Scale_3;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1920,144;Float;False;Constant;_TimeScale_2;Time Scale_2;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;123;-2157.547,238.9229;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-2016,48;Float;False;Property;_VMaxMovement_2;V Max Movement_2;19;0;Create;True;0;0;False;0;0;0;0;0.001;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2016,-16;Float;False;Property;_VMinMovement_2;V Min Movement_2;18;0;Create;True;0;0;False;0;0;9E-06;0;0.001;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2016,-160;Float;False;Property;_UVDistortion_2;UV Distortion_2;15;0;Create;True;0;0;False;0;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;74;-2176,-752;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-2016,-464;Float;False;Property;_VMinMovement_1;V Min Movement_1;13;0;Create;True;0;0;False;0;0;-3.3E-05;0;-0.001;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-2016,-400;Float;False;Property;_VMaxMovement_1;V Max Movement_1;14;0;Create;True;0;0;False;0;0;0;0;0.001;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1920,-304;Float;False;Constant;_TimeScale_1;Time Scale_1;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2016,-80;Float;False;Property;_HMovement_2;H Movement_2;17;0;Create;True;0;0;False;0;0;0.05;-0.0005;0.0005;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-2016,414.9096;Float;False;Property;_VMinMovement_3;V Min Movement_3;23;0;Create;True;0;0;False;0;0;9E-06;0;0.001;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-2016,-528;Float;False;Property;_HMovement_1;H Movement_1;12;0;Create;True;0;0;False;0;0;1.8E-05;-0.0005;0.0005;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2016,-608;Float;False;Property;_UVDistortion_1;UV Distortion_1;10;0;Create;True;0;0;False;0;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;130;-2410.399,19.54437;Float;False;Property;_UVTiling;UV Tiling;7;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;128;-1632,-224;Float;False;FogPanner;-1;;21;73ef78d5d665f3f4fb1758efb7d6df2d;0;7;29;FLOAT2;0,0;False;17;SAMPLER2D;0;False;16;FLOAT;0;False;20;FLOAT;0;False;18;FLOAT;0;False;19;FLOAT;0;False;26;FLOAT;0;False;1;FLOAT2;22
Node;AmplifyShaderEditor.FunctionNode;127;-1632,-784;Float;False;FogPanner;-1;;20;73ef78d5d665f3f4fb1758efb7d6df2d;0;7;29;FLOAT2;0,0;False;17;SAMPLER2D;0;False;16;FLOAT;0;False;20;FLOAT;0;False;18;FLOAT;0;False;19;FLOAT;0;False;26;FLOAT;0;False;1;FLOAT2;22
Node;AmplifyShaderEditor.FunctionNode;129;-1632,206.9096;Float;False;FogPanner;-1;;22;73ef78d5d665f3f4fb1758efb7d6df2d;0;7;29;FLOAT2;0,0;False;17;SAMPLER2D;0;False;16;FLOAT;0;False;20;FLOAT;0;False;18;FLOAT;0;False;19;FLOAT;0;False;26;FLOAT;0;False;1;FLOAT2;22
Node;AmplifyShaderEditor.RangedFloatNode;103;-960,1088;Float;False;Property;_EndGradient;End Gradient;28;0;Create;True;0;0;False;0;0;0.271;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-960,800;Float;False;Property;_MidGradient;Mid Gradient;26;0;Create;True;0;0;False;0;0;0.271;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;94;-880,656;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1216,-896;Float;False;Property;_FogBrightness_1;Fog Brightness_1;11;0;Create;True;0;0;False;0;0;0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-1296,-256;Float;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;False;0;None;7921f8dc65bddfc4683992a67b3e2335;True;0;False;white;Auto;False;Instance;28;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-1216,-336;Float;False;Property;_FogBrightness_2;Fog Brightness_2;16;0;Create;True;0;0;False;0;0;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;115;-1296,174.9096;Float;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;False;0;None;7921f8dc65bddfc4683992a67b3e2335;True;0;False;white;Auto;False;Instance;28;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;121;-1216,94.90959;Float;False;Property;_FogBrightness_3;Fog Brightness_3;21;0;Create;True;0;0;False;0;0;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;102;-880,944;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-1296,-816;Float;True;Property;_BaseFog;Base Fog;8;0;Create;True;0;0;False;0;7921f8dc65bddfc4683992a67b3e2335;7921f8dc65bddfc4683992a67b3e2335;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-960,-816;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-976,-256;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-960,864;Float;False;Property;_MidPosition;Mid Position;27;0;Create;True;0;0;False;0;0;1.14;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-960,1152;Float;False;Property;_EndPosition;End Position;29;0;Create;True;0;0;False;0;0;1.14;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-672,960;Float;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-976,174.9096;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-672,672;Float;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;85;-832,-816;Float;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;86;-848,-256;Float;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;120;-848,174.9096;Float;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-528,672;Float;False;2;2;0;FLOAT;0.63;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-528,960;Float;False;2;2;0;FLOAT;0.63;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;98;-400,672;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;107;-400,960;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-528,1056;Float;False;Property;_MidEndLerp;Mid-End Lerp;30;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-464,128;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;25.86242,242.4141;Float;False;Property;_EmissionSubstractor;Emission Substractor;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;108;-160,672;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;49;-336,128;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;87;-352,400;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;110;-416,544;Float;False;Property;_VertexOffsetMultiplier;Vertex Offset Multiplier;25;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;124;304,176;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;80,336;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-96,416;Float;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;92;240,336;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;125;464,176;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;608,128;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Fog2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;122;0;56;0
WireConnection;72;0;56;0
WireConnection;123;0;122;0
WireConnection;74;0;72;0
WireConnection;128;29;130;0
WireConnection;128;17;56;0
WireConnection;128;16;57;0
WireConnection;128;20;59;0
WireConnection;128;18;60;0
WireConnection;128;19;58;0
WireConnection;128;26;61;0
WireConnection;127;29;130;0
WireConnection;127;17;74;0
WireConnection;127;16;70;0
WireConnection;127;20;66;0
WireConnection;127;18;67;0
WireConnection;127;19;68;0
WireConnection;127;26;69;0
WireConnection;129;29;130;0
WireConnection;129;17;123;0
WireConnection;129;16;112;0
WireConnection;129;20;113;0
WireConnection;129;18;116;0
WireConnection;129;19;117;0
WireConnection;129;26;118;0
WireConnection;64;1;128;22
WireConnection;115;1;129;22
WireConnection;28;1;127;22
WireConnection;43;0;45;0
WireConnection;43;1;28;1
WireConnection;2;0;3;0
WireConnection;2;1;64;1
WireConnection;105;0;102;1
WireConnection;105;1;103;0
WireConnection;119;0;121;0
WireConnection;119;1;115;1
WireConnection;95;0;94;3
WireConnection;95;1;99;0
WireConnection;85;0;43;0
WireConnection;86;0;2;0
WireConnection;120;0;119;0
WireConnection;97;0;95;0
WireConnection;97;1;101;0
WireConnection;106;0;105;0
WireConnection;106;1;104;0
WireConnection;98;0;97;0
WireConnection;107;0;106;0
WireConnection;46;0;85;0
WireConnection;46;1;86;0
WireConnection;46;2;120;0
WireConnection;108;0;98;0
WireConnection;108;1;107;0
WireConnection;108;2;109;0
WireConnection;49;0;46;0
WireConnection;124;0;49;0
WireConnection;124;1;126;0
WireConnection;91;0;49;0
WireConnection;91;1;108;0
WireConnection;88;0;49;0
WireConnection;88;1;87;0
WireConnection;88;2;110;0
WireConnection;92;0;91;0
WireConnection;125;0;124;0
WireConnection;0;0;49;0
WireConnection;0;2;125;0
WireConnection;0;9;92;0
WireConnection;0;11;88;0
ASEEND*/
//CHKSM=62959458C175F8AB2336FF75DDCA5ACED697A221