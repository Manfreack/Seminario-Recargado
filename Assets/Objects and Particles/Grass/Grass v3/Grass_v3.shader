// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Nature/Grass_v3"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_WindIntensity("Wind Intensity", Range( 0 , 10)) = 0
		_Grass("Grass", 2D) = "white" {}
		_GrassNormal("Grass Normal", 2D) = "bump" {}
		_OpacityFix("Opacity Fix", Float) = 0
		_WindNoise("Wind Noise", 2D) = "white" {}
		_GroundColor("Ground Color", Color) = (0,0,0,0)
		_FullImageGradientColoring("Full Image / Gradient Coloring", Range( 0 , 1)) = 0
		_GroundColorGradient("Ground Color Gradient", Float) = -0.2
		_GroundColorPosition("Ground Color Position", Float) = -6
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _WindNoise;
		uniform float _GroundColorPosition;
		uniform float _GroundColorGradient;
		uniform float _WindIntensity;
		uniform sampler2D _GrassNormal;
		uniform float4 _GrassNormal_ST;
		uniform sampler2D _Grass;
		uniform float4 _Grass_ST;
		uniform float4 _GroundColor;
		uniform float _FullImageGradientColoring;
		uniform float _OpacityFix;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TexCoord16 = v.texcoord.xy * float2( 0.5,0.5 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float UpDownGradient18 = saturate( ( ( ase_vertex3Pos.y + _GroundColorPosition ) * _GroundColorGradient ) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( tex2Dlod( _WindNoise, float4( uv_TexCoord16, 0, 0.0) ).r * ( 1.0 - UpDownGradient18 ) ) * ( ase_vertexNormal * (0.0 + (( sin( _Time.y ) * _WindIntensity ) - 0.0) * (0.1 - 0.0) / (10.0 - 0.0)) ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_GrassNormal = i.uv_texcoord * _GrassNormal_ST.xy + _GrassNormal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _GrassNormal, uv_GrassNormal ) );
			float2 uv_Grass = i.uv_texcoord * _Grass_ST.xy + _Grass_ST.zw;
			float4 tex2DNode1 = tex2D( _Grass, uv_Grass );
			float4 temp_cast_0 = (tex2DNode1.r).xxxx;
			float4 blendOpSrc63 = temp_cast_0;
			float4 blendOpDest63 = _GroundColor;
			float4 temp_cast_1 = (tex2DNode1.r).xxxx;
			float4 blendOpSrc57 = temp_cast_1;
			float4 blendOpDest57 = _GroundColor;
			float4 temp_output_57_0 = ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest57) / blendOpSrc57) ) ));
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float UpDownGradient18 = saturate( ( ( ase_vertex3Pos.y + _GroundColorPosition ) * _GroundColorGradient ) );
			float4 lerpResult59 = lerp( tex2DNode1 , temp_output_57_0 , ( temp_output_57_0 * UpDownGradient18 ));
			float4 lerpResult61 = lerp( ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest63) / blendOpSrc63) ) )) , lerpResult59 , _FullImageGradientColoring);
			o.Albedo = lerpResult61.rgb;
			o.Alpha = tex2DNode1.a;
			clip( distance( tex2DNode1.a , _OpacityFix ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows noshadow exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
1044;92;595;655;-223.2646;-564.7593;1;False;False
Node;AmplifyShaderEditor.RangedFloatNode;6;-144,-224;Float;False;Property;_GroundColorPosition;Ground Color Position;9;0;Create;True;0;0;False;0;-6;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;58;-96,-512;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;5;144,-352;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-144,-160;Float;False;Property;_GroundColorGradient;Ground Color Gradient;8;0;Create;True;0;0;False;0;-0.2;-2.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-176,960;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-515.976,289.6042;Float;True;Property;_Grass;Grass;2;0;Create;True;0;0;False;0;None;df386d8cad5879342935f3ec6bf1b4ea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;256,-352;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-32,960;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;74;-200.5365,359.0259;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;384,-352;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-32,1040;Float;False;Property;_WindIntensity;Wind Intensity;1;0;Create;True;0;0;False;0;0;1.15;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;75;-176.114,343.559;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-464,16;Float;False;Property;_GroundColor;Ground Color;6;0;Create;True;0;0;False;0;0,0,0,0;0.901,0.916,0.851,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;528,-352;Float;False;UpDownGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;17;-80,560;Float;False;Constant;_NoiseTiling;Noise Tiling;7;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinOpNode;27;128,960;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;57;-160,96;Float;False;ColorBurn;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;82;654.5577,345.331;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;67;202.6668,323.9974;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;96,560;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-160,192;Float;False;18;UpDownGradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;240,960;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;224,752;Float;False;18;UpDownGradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;96,176;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;85;685.9952,307.4636;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;320,560;Float;True;Property;_WindNoise;Wind Noise;5;0;Create;True;0;0;False;0;57d2bf093b0797b40ac4594b01e32048;72df5d8eb7d4ae34f8aed24c282958ab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;66;219.7779,305.331;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;22;448,752;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;77;-179.5625,376.2808;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-807.0783,223.7619;Float;True;Property;_GrassNormal;Grass Normal;3;0;Create;True;0;0;False;0;None;1b641dc8e6c2d0d43a057601fbd0d567;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;24;368,832;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;26;368,960;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;59;304,80;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;76;-159.5742,367.9984;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;576,832;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;86;847.9952,295.4636;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;304,192;Float;False;Property;_FullImageGradientColoring;Full Image / Gradient Coloring;7;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;84;839.8881,256.8342;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;624,560;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;544,400;Float;False;Property;_OpacityFix;Opacity Fix;4;0;Create;True;0;0;False;0;0;-0.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;63;-160,0;Float;False;ColorBurn;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceOpNode;53;720,336;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;83;860.595,236.128;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;81;863.5577,278.331;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-96,-368;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;768,560;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;61;624,0;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;944,0;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Nature/Grass_v3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;3;50;1;1;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;1;0,0,0,0;VertexOffset;False;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;58;2
WireConnection;5;1;6;0
WireConnection;9;0;5;0
WireConnection;9;1;8;0
WireConnection;29;0;40;0
WireConnection;74;0;1;4
WireConnection;11;0;9;0
WireConnection;75;0;74;0
WireConnection;18;0;11;0
WireConnection;27;0;29;0
WireConnection;57;0;1;1
WireConnection;57;1;12;0
WireConnection;82;0;75;0
WireConnection;67;0;1;0
WireConnection;16;0;17;0
WireConnection;28;0;27;0
WireConnection;28;1;52;0
WireConnection;13;0;57;0
WireConnection;13;1;19;0
WireConnection;85;0;82;0
WireConnection;15;1;16;0
WireConnection;66;0;67;0
WireConnection;22;0;20;0
WireConnection;77;0;1;4
WireConnection;26;0;28;0
WireConnection;59;0;66;0
WireConnection;59;1;57;0
WireConnection;59;2;13;0
WireConnection;76;0;77;0
WireConnection;43;0;24;0
WireConnection;43;1;26;0
WireConnection;86;0;85;0
WireConnection;84;0;2;0
WireConnection;21;0;15;1
WireConnection;21;1;22;0
WireConnection;63;0;1;1
WireConnection;63;1;12;0
WireConnection;53;0;76;0
WireConnection;53;1;56;0
WireConnection;83;0;84;0
WireConnection;81;0;86;0
WireConnection;23;0;21;0
WireConnection;23;1;43;0
WireConnection;61;0;63;0
WireConnection;61;1;59;0
WireConnection;61;2;64;0
WireConnection;0;0;61;0
WireConnection;0;1;83;0
WireConnection;0;9;81;0
WireConnection;0;10;53;0
WireConnection;0;11;23;0
ASEEND*/
//CHKSM=94E3FE51E9A2ACD5516174EEAAFA57F2C008601C