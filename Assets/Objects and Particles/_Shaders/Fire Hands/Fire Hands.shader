// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Fire Hands"
{
	Properties
	{
		_VertexOffsetIntensity("Vertex Offset Intensity", Float) = 0
		_GlobalOpacity("Global Opacity", Range( 0 , 1)) = 0
		_Waves("Waves", 2D) = "white" {}
		_ColorWhite("Color White", Color) = (0.862069,1,0,0)
		_ColorBlack("Color Black", Color) = (1,0,0,0)
		_VertexOffsetMultiplier("Vertex Offset Multiplier", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _GlobalOpacity;
		uniform sampler2D _Waves;
		uniform float _VertexOffsetIntensity;
		uniform float _VertexOffsetMultiplier;
		uniform float4 _ColorBlack;
		uniform float4 _ColorWhite;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner6 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + v.texcoord.xy);
			float2 panner10 = ( 1.0 * _Time.y * float2( 0,-0.2 ) + v.texcoord.xy);
			float temp_output_20_0 = saturate( ( tex2Dlod( _Waves, float4( panner6, 0, 0.0) ).r + saturate( ( tex2Dlod( _Waves, float4( panner10, 0, 0.0) ).r - 0.5 ) ) ) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( _GlobalOpacity * ( temp_output_20_0 * ase_vertexNormal * _VertexOffsetIntensity * _VertexOffsetMultiplier ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner6 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + i.uv_texcoord);
			float2 panner10 = ( 1.0 * _Time.y * float2( 0,-0.2 ) + i.uv_texcoord);
			float temp_output_20_0 = saturate( ( tex2D( _Waves, panner6 ).r + saturate( ( tex2D( _Waves, panner10 ).r - 0.5 ) ) ) );
			float4 lerpResult4 = lerp( _ColorBlack , _ColorWhite , temp_output_20_0);
			o.Emission = lerpResult4.rgb;
			o.Alpha = ( temp_output_20_0 * _GlobalOpacity );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
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
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
Version=15301
762;92;773;655;302.4951;173.3619;1;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1744,48;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;-1696,304;Float;False;Constant;_SpeedPanner2;Speed Panner 2;4;0;Create;True;0;0;False;0;0,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;10;-1456,304;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-1264,304;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;faaa54b5537f89c4b8ac7b11c506428e;faaa54b5537f89c4b8ac7b11c506428e;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1168,496;Float;False;Constant;_BrightnessFix;Brightness Fix;4;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;8;-1696,160;Float;False;Constant;_SpeedPanner1;Speed Panner 1;4;0;Create;True;0;0;False;0;0,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;6;-1456,128;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-944,304;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;-800,304;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1264,128;Float;True;Property;_Waves;Waves;3;0;Create;True;0;0;False;0;faaa54b5537f89c4b8ac7b11c506428e;faaa54b5537f89c4b8ac7b11c506428e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-640,160;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-528,592;Float;False;Property;_VertexOffsetMultiplier;Vertex Offset Multiplier;6;0;Create;True;0;0;False;0;0;0.078;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;20;-432,160;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-512,528;Float;False;Property;_VertexOffsetIntensity;Vertex Offset Intensity;0;0;Create;True;0;0;False;0;0;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;21;-448,400;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-224,320;Float;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-224,240;Float;False;Property;_GlobalOpacity;Global Opacity;2;0;Create;True;0;0;False;0;0;0.981;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-624,-64;Float;False;Property;_ColorWhite;Color White;4;0;Create;True;0;0;False;0;0.862069,1,0,0;0.862069,1,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-624,-224;Float;False;Property;_ColorBlack;Color Black;5;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;101.5049,336.6381;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;4;-368,-80;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;103.5049,186.6381;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;304,-16;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Fire Hands;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;7;0
WireConnection;10;2;11;0
WireConnection;9;1;10;0
WireConnection;6;0;7;0
WireConnection;6;2;8;0
WireConnection;15;0;9;1
WireConnection;15;1;14;0
WireConnection;17;0;15;0
WireConnection;1;1;6;0
WireConnection;19;0;1;1
WireConnection;19;1;17;0
WireConnection;20;0;19;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;22;2;23;0
WireConnection;22;3;24;0
WireConnection;31;0;26;0
WireConnection;31;1;22;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;20;0
WireConnection;30;0;20;0
WireConnection;30;1;26;0
WireConnection;0;2;4;0
WireConnection;0;9;30;0
WireConnection;0;11;31;0
ASEEND*/
//CHKSM=7231D4A1B654B947587049C1E6F06DE14323FE42