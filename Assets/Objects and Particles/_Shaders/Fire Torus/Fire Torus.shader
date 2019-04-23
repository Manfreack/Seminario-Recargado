// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Fire Torus"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 6
		_VertexOffsetIntensity("Vertex Offset Intensity", Range( 0 , 1)) = 0
		_Waves("Waves", 2D) = "white" {}
		_Fire("Fire", 2D) = "white" {}
		_FlowMap("FlowMap", 2D) = "white" {}
		_UVDistortion("UV Distortion", Range( 0 , 1)) = 0
		_ColorWhite("Color White", Color) = (0.862069,1,0,0)
		_AboutToFire("About To Fire", Range( 0 , 1)) = 0
		_ColorBlack("Color Black", Color) = (1,0,0,0)
		_MaxOpacity("Max Opacity", Float) = 0
		_OverallOpacity("Overall Opacity", Range( 0 , 1)) = 0
		_EmissionIntensity("Emission Intensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Fire;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _UVDistortion;
		uniform float4 _ColorBlack;
		uniform float4 _ColorWhite;
		uniform float _AboutToFire;
		uniform sampler2D _Waves;
		uniform float _VertexOffsetIntensity;
		uniform float _EmissionIntensity;
		uniform float _OverallOpacity;
		uniform float _MaxOpacity;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_FlowMap = v.texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float4 lerpResult5 = lerp( float4( v.texcoord.xy, 0.0 , 0.0 ) , tex2Dlod( _FlowMap, float4( uv_FlowMap, 0, 0.0) ) , _UVDistortion);
			float2 panner2 = ( 1.0 * _Time.y * float2( 0.01,-0.05 ) + lerpResult5.rg);
			float4 tex2DNode1 = tex2Dlod( _Fire, float4( panner2, 0, 0.0) );
			float4 lerpResult52 = lerp( _ColorWhite , _ColorBlack , _AboutToFire);
			float2 panner34 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + v.texcoord.xy);
			float2 panner30 = ( 1.0 * _Time.y * float2( 0,-0.2 ) + v.texcoord.xy);
			float4 lerpResult42 = lerp( _ColorBlack , lerpResult52 , saturate( ( tex2Dlod( _Waves, float4( panner34, 0, 0.0) ).r + saturate( ( tex2Dlod( _Fire, float4( panner30, 0, 0.0) ).r - 0.5 ) ) ) ));
			float4 FinalWaveColor44 = lerpResult42;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( saturate( ( tex2DNode1.r * tex2DNode1.r * tex2DNode1.r * tex2DNode1.r * FinalWaveColor44 ) ) * float4( ase_vertexNormal , 0.0 ) * _VertexOffsetIntensity ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 lerpResult52 = lerp( _ColorWhite , _ColorBlack , _AboutToFire);
			float2 panner34 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + i.uv_texcoord);
			float2 panner30 = ( 1.0 * _Time.y * float2( 0,-0.2 ) + i.uv_texcoord);
			float4 lerpResult42 = lerp( _ColorBlack , lerpResult52 , saturate( ( tex2D( _Waves, panner34 ).r + saturate( ( tex2D( _Fire, panner30 ).r - 0.5 ) ) ) ));
			float4 FinalWaveColor44 = lerpResult42;
			o.Albedo = FinalWaveColor44.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV22 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode22 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV22, 5.0 ) );
			float4 temp_output_26_0 = ( saturate( fresnelNode22 ) * FinalWaveColor44 );
			o.Emission = ( saturate( ( _EmissionIntensity * ( temp_output_26_0 + temp_output_26_0 ) * FinalWaveColor44 ) ) + FinalWaveColor44 ).rgb;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float4 lerpResult5 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _FlowMap, uv_FlowMap ) , _UVDistortion);
			float2 panner2 = ( 1.0 * _Time.y * float2( 0.01,-0.05 ) + lerpResult5.rg);
			float4 tex2DNode1 = tex2D( _Fire, panner2 );
			float Opacity43 = ( (0.0 + (_OverallOpacity - 0.0) * (_MaxOpacity - 0.0) / (1.0 - 0.0)) * tex2DNode1.r );
			o.Alpha = Opacity43;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
521;92;1014;650;2657.311;212.4165;1.327426;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-2928,304;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;29;-2896,560;Float;False;Constant;_SpeedPanner2;Speed Panner 2;4;0;Create;True;0;0;False;0;0,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;30;-2656,560;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2352,736;Float;False;Constant;_BrightnessFix;Brightness Fix;4;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;33;-2896,416;Float;False;Constant;_SpeedPanner1;Speed Panner 1;4;0;Create;True;0;0;False;0;0,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;31;-2464,560;Float;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;False;0;faaa54b5537f89c4b8ac7b11c506428e;faaa54b5537f89c4b8ac7b11c506428e;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-2176,592;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;34;-2656,384;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-2464,384;Float;True;Property;_Waves;Waves;7;0;Create;True;0;0;False;0;faaa54b5537f89c4b8ac7b11c506428e;faaa54b5537f89c4b8ac7b11c506428e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;36;-2032,528;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;-2288,192;Float;False;Property;_ColorBlack;Color Black;14;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-2468.817,50.41386;Float;False;Property;_AboutToFire;About To Fire;13;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1904,416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-2096,288;Float;False;Property;_ColorWhite;Color White;12;0;Create;True;0;0;False;0;0.862069,1,0,0;0.862069,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;52;-2097.137,66.34297;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;41;-1792,416;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;42;-1664,272;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-1873.314,-48;Float;True;Property;_FlowMap;FlowMap;10;0;Create;True;0;0;False;0;None;f8b4f631d8791ef41bfd326e68272ebb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1856,144;Float;False;Property;_UVDistortion;UV Distortion;11;0;Create;True;0;0;False;0;0;0.489;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1504,304;Float;False;FinalWaveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;22;-576,-288;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1808,-160;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;7;-1488,160;Float;False;Constant;_FireSpeed;Fire Speed;3;0;Create;True;0;0;False;0;0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;5;-1440,48;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-416,-80;Float;False;44;FinalWaveColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;23;-288,-288;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1344,-32;Float;False;Property;_MaxOpacity;Max Opacity;15;0;Create;True;0;0;False;0;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1440,-112;Float;False;Property;_OverallOpacity;Overall Opacity;16;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;2;-1280,64;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-144,-288;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;48;-1168,-112;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1280,48;Float;True;Property;_Fire;Fire;9;0;Create;True;0;0;False;0;None;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-144,-368;Float;False;Property;_EmissionIntensity;Emission Intensity;17;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;0,-288;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-960,-32;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;144,-304;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-944,96;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;13;-784,176;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-912,384;Float;False;Property;_VertexOffsetIntensity;Vertex Offset Intensity;6;0;Create;True;0;0;False;0;0;0.19;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;25;288,-304;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;8;-832,256;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;47;-190.9226,-21.82782;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-816,-32;Float;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;432,-112;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;592,176;Float;False;43;Opacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;46;-158.2196,2.291388;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-608,240;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;784,-32;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Fire Torus;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;6;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;28;0
WireConnection;30;2;29;0
WireConnection;31;1;30;0
WireConnection;35;0;31;1
WireConnection;35;1;32;0
WireConnection;34;0;28;0
WireConnection;34;2;33;0
WireConnection;37;1;34;0
WireConnection;36;0;35;0
WireConnection;38;0;37;1
WireConnection;38;1;36;0
WireConnection;52;0;39;0
WireConnection;52;1;40;0
WireConnection;52;2;53;0
WireConnection;41;0;38;0
WireConnection;42;0;40;0
WireConnection;42;1;52;0
WireConnection;42;2;41;0
WireConnection;44;0;42;0
WireConnection;5;0;4;0
WireConnection;5;1;3;0
WireConnection;5;2;6;0
WireConnection;23;0;22;0
WireConnection;2;0;5;0
WireConnection;2;2;7;0
WireConnection;26;0;23;0
WireConnection;26;1;45;0
WireConnection;48;0;16;0
WireConnection;48;4;50;0
WireConnection;1;1;2;0
WireConnection;24;0;26;0
WireConnection;24;1;26;0
WireConnection;17;0;48;0
WireConnection;17;1;1;1
WireConnection;14;0;15;0
WireConnection;14;1;24;0
WireConnection;14;2;45;0
WireConnection;11;0;1;1
WireConnection;11;1;1;1
WireConnection;11;2;1;1
WireConnection;11;3;1;1
WireConnection;11;4;44;0
WireConnection;13;0;11;0
WireConnection;25;0;14;0
WireConnection;47;0;45;0
WireConnection;43;0;17;0
WireConnection;27;0;25;0
WireConnection;27;1;45;0
WireConnection;46;0;47;0
WireConnection;9;0;13;0
WireConnection;9;1;8;0
WireConnection;9;2;10;0
WireConnection;0;0;46;0
WireConnection;0;2;27;0
WireConnection;0;9;49;0
WireConnection;0;11;9;0
ASEEND*/
//CHKSM=09D40067724713F60835E9D9D3EC08DA62D17CC2