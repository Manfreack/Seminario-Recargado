// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Orb"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_1_FresnelColor("1_Fresnel Color", Color) = (0,0,0,0)
		_1_FrenelBias("1_Frenel Bias", Range( 0 , 1)) = 0
		_1_FrenelScale("1_Frenel Scale", Range( 0 , 1)) = 1
		_1_FrenelPower("1_Frenel Power", Range( 0 , 5)) = 5
		_2_FresnelColor("2_Fresnel Color", Color) = (0,0,0,0)
		_2_FrenelBias("2_Frenel Bias", Range( 0 , 1)) = 0
		_2_FresnelScale("2_Fresnel Scale", Range( 0 , 1)) = 1
		_2_FresnelPower("2_Fresnel Power", Range( 0 , 5)) = 5
		_3_FresnelColor("3_Fresnel Color", Color) = (0,0,0,0)
		_3_FresnelBias("3_Fresnel Bias", Range( 0 , 1)) = 0
		_3_FresnelScale("3_Fresnel Scale", Range( 0 , 1)) = 1
		_3_FresnelPower("3_Fresnel Power", Range( 0 , 5)) = 5
		_Snow("Snow", 2D) = "white" {}
		_X("X", Vector) = (1,0,0,0)
		_Y("Y", Vector) = (0,1,0,0)
		_Z("Z", Vector) = (0,0,1,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf StandardCustomLighting keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Snow;
		uniform float3 _X;
		uniform float3 _Y;
		uniform float3 _Z;
		uniform float4 _1_FresnelColor;
		uniform float _1_FrenelBias;
		uniform float _1_FrenelScale;
		uniform float _1_FrenelPower;
		uniform float _2_FrenelBias;
		uniform float _2_FresnelScale;
		uniform float _2_FresnelPower;
		uniform float4 _2_FresnelColor;
		uniform float _3_FresnelBias;
		uniform float _3_FresnelScale;
		uniform float _3_FresnelPower;
		uniform float4 _3_FresnelColor;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 panner40 = ( _Time.y * float2( 0.2,0.1 ) + v.texcoord.xy);
			float2 panner47 = ( _Time.y * float2( 0.1,-0.2 ) + v.texcoord.xy);
			float2 panner48 = ( _Time.y * float2( -0.2,0.1 ) + v.texcoord.xy);
			v.vertex.xyz += saturate( ( ( 0.2 * tex2Dlod( _Snow, float4( panner40, 0, 0.0) ).r * _X ) + ( 0.2 * tex2Dlod( _Snow, float4( panner47, 0, 0.0) ).r * _Y ) + ( 0.2 * tex2Dlod( _Snow, float4( panner48, 0, 0.0) ).r * _Z ) ) );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNDotV5 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode5 = ( _1_FrenelBias + _1_FrenelScale * pow( 1.0 - fresnelNDotV5, _1_FrenelPower ) );
			float fresnelNDotV14 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode14 = ( _2_FrenelBias + _2_FresnelScale * pow( 1.0 - fresnelNDotV14, _2_FresnelPower ) );
			float fresnelNDotV29 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode29 = ( _3_FresnelBias + _3_FresnelScale * pow( 1.0 - fresnelNDotV29, _3_FresnelPower ) );
			float4 temp_output_58_0 = saturate( ( saturate( ( _1_FresnelColor * fresnelNode5 ) ) + saturate( ( fresnelNode14 * _2_FresnelColor ) ) + saturate( ( fresnelNode29 * _3_FresnelColor ) ) ) );
			c.rgb = temp_output_58_0.rgb;
			c.a = temp_output_58_0.r;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNDotV5 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode5 = ( _1_FrenelBias + _1_FrenelScale * pow( 1.0 - fresnelNDotV5, _1_FrenelPower ) );
			float fresnelNDotV14 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode14 = ( _2_FrenelBias + _2_FresnelScale * pow( 1.0 - fresnelNDotV14, _2_FresnelPower ) );
			float fresnelNDotV29 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode29 = ( _3_FresnelBias + _3_FresnelScale * pow( 1.0 - fresnelNDotV29, _3_FresnelPower ) );
			float4 temp_output_58_0 = saturate( ( saturate( ( _1_FresnelColor * fresnelNode5 ) ) + saturate( ( fresnelNode14 * _2_FresnelColor ) ) + saturate( ( fresnelNode29 * _3_FresnelColor ) ) ) );
			o.Emission = temp_output_58_0.rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
896;92;639;655;694.0717;-1998.243;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;43;-1312,1984;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-992,640;Float;False;Property;_2_FresnelPower;2_Fresnel Power;12;0;Create;True;0;0;False;0;5;2.58;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1376,1872;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-992,288;Float;False;Property;_1_FrenelBias;1_Frenel Bias;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-992,352;Float;False;Property;_1_FrenelScale;1_Frenel Scale;7;0;Create;True;0;0;False;0;1;0.413;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-992,928;Float;False;Property;_3_FresnelBias;3_Fresnel Bias;14;0;Create;True;0;0;False;0;0;0.032;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-992,1056;Float;False;Property;_3_FresnelPower;3_Fresnel Power;16;0;Create;True;0;0;False;0;5;2.04;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-992,992;Float;False;Property;_3_FresnelScale;3_Fresnel Scale;15;0;Create;True;0;0;False;0;1;0.09;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-992,576;Float;False;Property;_2_FresnelScale;2_Fresnel Scale;11;0;Create;True;0;0;False;0;1;0.104;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-992,512;Float;False;Property;_2_FrenelBias;2_Frenel Bias;10;0;Create;True;0;0;False;0;0;0.111;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-992,416;Float;False;Property;_1_FrenelPower;1_Frenel Power;8;0;Create;True;0;0;False;0;5;0.03;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;47;-832,1840;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;48;-832,2176;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.2,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;23;-640,800;Float;False;Property;_2_FresnelColor;2_Fresnel Color;9;0;Create;True;0;0;False;0;0,0,0,0;0,1,0.1724138,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;40;-832,1504;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.2,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;12;-640,176;Float;False;Property;_1_FresnelColor;1_Fresnel Color;5;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;29;-672,992;Float;True;Tangent;4;0;FLOAT3;0,0,1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;5;-672,352;Float;True;Tangent;4;0;FLOAT3;0,0,1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-640,1216;Float;False;Property;_3_FresnelColor;3_Fresnel Color;13;0;Create;True;0;0;False;0;0,0,0,0;0.6965518,0,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;14;-672,576;Float;True;Tangent;4;0;FLOAT3;0,0,1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-565.8859,1429.59;Float;False;Constant;_TesselMultiplier;Tessel Multiplier;14;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;34;-528,2032;Float;False;Property;_Y;Y;20;0;Create;True;0;0;False;0;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;32;-659.5635,1504.96;Float;True;Property;_Snow;Snow;18;0;Create;True;0;0;False;0;3e9b0a1a80fa21f4c9144cd923f9a3bc;3e9b0a1a80fa21f4c9144cd923f9a3bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;49;-656,2176;Float;True;Property;_TextureSample1;Texture Sample 1;18;0;Create;True;0;0;False;0;3e9b0a1a80fa21f4c9144cd923f9a3bc;3e9b0a1a80fa21f4c9144cd923f9a3bc;True;0;False;white;Auto;False;Instance;32;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;35;-528,2368;Float;False;Property;_Z;Z;21;0;Create;True;0;0;False;0;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;46;-656,1840;Float;True;Property;_TextureSample0;Texture Sample 0;18;0;Create;True;0;0;False;0;3e9b0a1a80fa21f4c9144cd923f9a3bc;3e9b0a1a80fa21f4c9144cd923f9a3bc;True;0;False;white;Auto;False;Instance;32;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;33;-528,1696;Float;False;Property;_X;X;19;0;Create;True;0;0;False;0;1,0,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-400,352;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-400,576;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-400,992;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-256,1920;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-256,1808;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-256,1696;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;20;-208,576;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;31;-208,992;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;11;-208,352;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-32,1696;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;0,352;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;45;112,1696;Float;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;58;219.9389,349.6413;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;480,160;Float;False;True;6;Float;ASEMaterialInspector;0;0;CustomLighting;MyShaders/Orb;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;17;-1;-1;0;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;41;0
WireConnection;47;1;43;0
WireConnection;48;0;41;0
WireConnection;48;1;43;0
WireConnection;40;0;41;0
WireConnection;40;1;43;0
WireConnection;29;1;26;0
WireConnection;29;2;27;0
WireConnection;29;3;25;0
WireConnection;5;1;6;0
WireConnection;5;2;7;0
WireConnection;5;3;8;0
WireConnection;14;1;19;0
WireConnection;14;2;18;0
WireConnection;14;3;17;0
WireConnection;32;1;40;0
WireConnection;49;1;48;0
WireConnection;46;1;47;0
WireConnection;21;0;12;0
WireConnection;21;1;5;0
WireConnection;22;0;14;0
WireConnection;22;1;23;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;39;0;37;0
WireConnection;39;1;49;1
WireConnection;39;2;35;0
WireConnection;38;0;37;0
WireConnection;38;1;46;1
WireConnection;38;2;34;0
WireConnection;36;0;37;0
WireConnection;36;1;32;1
WireConnection;36;2;33;0
WireConnection;20;0;22;0
WireConnection;31;0;30;0
WireConnection;11;0;21;0
WireConnection;44;0;36;0
WireConnection;44;1;38;0
WireConnection;44;2;39;0
WireConnection;24;0;11;0
WireConnection;24;1;20;0
WireConnection;24;2;31;0
WireConnection;45;0;44;0
WireConnection;58;0;24;0
WireConnection;0;2;58;0
WireConnection;0;9;58;0
WireConnection;0;13;58;0
WireConnection;0;11;45;0
ASEEND*/
//CHKSM=C3420DFCEC25E21C2D6EF562DB90E737CDFEDC2E