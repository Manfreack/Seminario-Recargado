// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Sword Trail 2"
{
	Properties
	{
		_ColorFront("Color Front", Color) = (0.9862069,1,0,0)
		_ColorBack("Color Back", Color) = (1,0,0,0)
		_Intensity("Intensity", Range( 0 , 2)) = 1.047393
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_Smoke("Smoke", 2D) = "white" {}
		_SmokeIntensity("Smoke Intensity", Float) = 3.58
		_Rock("Rock", 2D) = "white" {}
		_TexGrayscale("Tex Grayscale", 2D) = "white" {}
		_Flowmap("Flowmap", 2D) = "white" {}
		_FlowmapIntensity("Flowmap Intensity", Range( 0 , 1)) = 0
		_ExtraBlackinGrayscale("Extra Black in Grayscale", Range( 0 , 1)) = 0.06
		_PannerSpeedX("Panner Speed X", Range( 0 , 1)) = 1
		_PannerSpeedY("Panner Speed Y", Range( 0 , 1)) = 0
		_PannerSpeedMultiplier("Panner Speed Multiplier", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
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

		uniform float4 _ColorBack;
		uniform float4 _ColorFront;
		uniform sampler2D _TexGrayscale;
		uniform float4 _TexGrayscale_ST;
		uniform float _ExtraBlackinGrayscale;
		uniform float _SmokeIntensity;
		uniform sampler2D _Smoke;
		uniform sampler2D _Flowmap;
		uniform float _PannerSpeedX;
		uniform float _PannerSpeedMultiplier;
		uniform float _PannerSpeedY;
		uniform float _FlowmapIntensity;
		uniform sampler2D _Rock;
		uniform float _Intensity;
		uniform float _Opacity;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_TexGrayscale = i.uv_texcoord * _TexGrayscale_ST.xy + _TexGrayscale_ST.zw;
			float4 lerpResult27 = lerp( _ColorBack , _ColorFront , ( tex2D( _TexGrayscale, uv_TexGrayscale ).r - _ExtraBlackinGrayscale ));
			float2 appendResult9 = (float2(( _PannerSpeedX * _PannerSpeedMultiplier ) , ( _PannerSpeedMultiplier * _PannerSpeedY )));
			float2 panner13 = ( _Time.y * appendResult9 + i.uv_texcoord);
			float4 tex2DNode16 = tex2D( _Flowmap, panner13 );
			float4 lerpResult18 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2DNode16 , (0.0 + (_FlowmapIntensity - 0.0) * (0.3 - 0.0) / (1.0 - 0.0)));
			float4 temp_output_34_0 = saturate( ( lerpResult27 * ( _SmokeIntensity * tex2D( _Smoke, lerpResult18.rg ) ) * tex2D( _Rock, tex2DNode16.rg ) * _Intensity ) );
			c.rgb = temp_output_34_0.rgb;
			c.a = ( temp_output_34_0 * _Opacity ).r;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
956;73;631;653;1286.067;45.94829;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;3;-2399.178,350.0262;Float;False;Property;_PannerSpeedX;Panner Speed X;12;0;Create;True;0;0;False;0;1;0.125;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2397.178,494.0262;Float;False;Property;_PannerSpeedY;Panner Speed Y;13;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2378.821,420.3502;Float;False;Property;_PannerSpeedMultiplier;Panner Speed Multiplier;14;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2099.821,455.3502;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2099.821,368.3502;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-1903.178,368.0262;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2121.178,247.0262;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1906.428,464.3018;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;12;-1771.292,140.2988;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;13;-1703.177,248.0262;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1697.233,404.8976;Float;False;Property;_FlowmapIntensity;Flowmap Intensity;10;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;15;-1409.432,410.2976;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;14;-1736.037,131.7983;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;16;-1518.362,219.6675;Float;True;Property;_Flowmap;Flowmap;9;0;Create;True;0;0;False;0;None;7347f1f1f77b15c41bfacb2a8b65dbd0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;18;-1162.378,102.1429;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1493.959,26.95142;Float;False;Property;_ExtraBlackinGrayscale;Extra Black in Grayscale;11;0;Create;True;0;0;False;0;0.06;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-1457.981,-157.7181;Float;True;Property;_TexGrayscale;Tex Grayscale;8;0;Create;True;0;0;False;0;None;521861f25d4b5d340a91bb195bfa8556;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-1149.959,8.951402;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-992.7787,290.6208;Float;True;Property;_Smoke;Smoke;5;0;Create;True;0;0;False;0;None;0000000000000000f000000000000000;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-900.9401,219.7853;Float;False;Property;_SmokeIntensity;Smoke Intensity;6;0;Create;True;0;0;False;0;3.58;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;-1374.565,-328.9355;Float;False;Property;_ColorBack;Color Back;2;0;Create;True;0;0;False;0;1,0,0,0;1,0,0.07227325,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-1376.565,-494.9359;Float;False;Property;_ColorFront;Color Front;1;0;Create;True;0;0;False;0;0.9862069,1,0,0;1,0.7776269,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;27;-959.8128,-113.5094;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;26;-988.0562,480.5332;Float;True;Property;_Rock;Rock;7;0;Create;True;0;0;False;0;None;08905cbd9f9d58843a5d81365ccad4b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-696.9411,273.7853;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-965.6828,669.9706;Float;False;Property;_Intensity;Intensity;3;0;Create;True;0;0;False;0;1.047393;1.88;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-533.8098,251.2475;Float;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-527.3831,463.8703;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;34;-334.3456,250.7988;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-147.3831,296.8703;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;MyShaders/Sword Trail 2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;5;0
WireConnection;7;1;4;0
WireConnection;6;0;3;0
WireConnection;6;1;5;0
WireConnection;9;0;6;0
WireConnection;9;1;7;0
WireConnection;12;0;8;0
WireConnection;13;0;8;0
WireConnection;13;2;9;0
WireConnection;13;1;10;0
WireConnection;15;0;11;0
WireConnection;14;0;12;0
WireConnection;16;1;13;0
WireConnection;18;0;14;0
WireConnection;18;1;16;0
WireConnection;18;2;15;0
WireConnection;24;0;19;1
WireConnection;24;1;17;0
WireConnection;2;1;18;0
WireConnection;27;0;22;0
WireConnection;27;1;23;0
WireConnection;27;2;24;0
WireConnection;26;1;16;0
WireConnection;25;0;21;0
WireConnection;25;1;2;0
WireConnection;28;0;27;0
WireConnection;28;1;25;0
WireConnection;28;2;26;0
WireConnection;28;3;37;0
WireConnection;34;0;28;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;0;9;36;0
WireConnection;0;13;34;0
ASEEND*/
//CHKSM=3BC2841FF59E41FD129E29D48159C9A084B1AC06