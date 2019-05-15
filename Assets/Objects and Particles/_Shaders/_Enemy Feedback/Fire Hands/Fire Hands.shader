// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Fire Hands"
{
	Properties
	{
		_VertexOffsetIntensity("Vertex Offset Intensity", Float) = 0
		_MeleeFireOpacity("Melee Fire Opacity", Range( 0 , 1)) = 1
		_RangedFireOpacity("Ranged Fire Opacity", Range( 0 , 1)) = 0
		_ColorWhite("Color White", Color) = (0.862069,1,0,0)
		_ColorBlack("Color Black", Color) = (1,0,0,0)
		_VertexOffsetMultiplier("Vertex Offset Multiplier", Range( 0 , 1)) = 0
		_WavesTexture("Waves Texture", 2D) = "white" {}
		_ColorRamp("Color Ramp", 2D) = "white" {}
		_NoiseTexture("Noise Texture", 2D) = "white" {}
		_Dissolve("Dissolve", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
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

		uniform float _RangedFireOpacity;
		uniform sampler2D _WavesTexture;
		uniform float _VertexOffsetIntensity;
		uniform float _VertexOffsetMultiplier;
		uniform float4 _ColorBlack;
		uniform float4 _ColorWhite;
		uniform sampler2D _ColorRamp;
		uniform sampler2D _NoiseTexture;
		uniform sampler2D _Dissolve;
		uniform float4 _Dissolve_ST;
		uniform float _MeleeFireOpacity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner6 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + v.texcoord.xy);
			float Panner150 = tex2Dlod( _WavesTexture, float4( panner6, 0, 0.0) ).r;
			float2 panner10 = ( 1.0 * _Time.y * float2( 0,-0.2 ) + v.texcoord.xy);
			float Panner252 = tex2Dlod( _WavesTexture, float4( panner10, 0, 0.0) ).r;
			float temp_output_20_0 = saturate( ( Panner150 + saturate( ( Panner252 - 0.5 ) ) ) );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 RangedHandsVertexOffset81 = ( (0.05 + (_RangedFireOpacity - 0.0) * (1.0 - 0.05) / (1.0 - 0.0)) * ( temp_output_20_0 * ase_vertexNormal * _VertexOffsetIntensity * _VertexOffsetMultiplier ) );
			v.vertex.xyz += RangedHandsVertexOffset81;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner6 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + i.uv_texcoord);
			float Panner150 = tex2D( _WavesTexture, panner6 ).r;
			float2 panner10 = ( 1.0 * _Time.y * float2( 0,-0.2 ) + i.uv_texcoord);
			float Panner252 = tex2D( _WavesTexture, panner10 ).r;
			float temp_output_20_0 = saturate( ( Panner150 + saturate( ( Panner252 - 0.5 ) ) ) );
			float4 lerpResult4 = lerp( _ColorBlack , _ColorWhite , temp_output_20_0);
			float4 RangedHandsOutput74 = ( lerpResult4 * _RangedFireOpacity );
			float2 panner62 = ( 1.0 * _Time.y * float2( 0,-0.05 ) + i.uv_texcoord);
			float Panner366 = tex2D( _NoiseTexture, panner62 ).r;
			float2 temp_cast_0 = (( Panner366 + 0.1 )).xx;
			float2 uv_Dissolve = i.uv_texcoord * _Dissolve_ST.xy + _Dissolve_ST.zw;
			float4 MeleeHandsOutput73 = ( ( tex2D( _ColorRamp, temp_cast_0 ) * 0.6 ) * saturate( ceil( saturate( ( tex2D( _Dissolve, uv_Dissolve ).r + (-1.0 + (_MeleeFireOpacity - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) ) ) );
			o.Emission = saturate( ( RangedHandsOutput74 + MeleeHandsOutput73 ) ).rgb;
			float RangedHandsOpacity78 = ( temp_output_20_0 * _RangedFireOpacity );
			o.Alpha = saturate( ( MeleeHandsOutput73 + RangedHandsOpacity78 ) ).r;
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
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
202;73;1254;653;1511.965;-143.6506;1.721338;False;False
Node;AmplifyShaderEditor.CommentaryNode;89;314.6254,-737.7696;Float;False;1061;712;Panners;13;11;7;10;65;9;8;62;6;52;63;1;66;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;364.6254,-687.7695;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;412.6252,-431.7696;Float;False;Constant;_SpeedPanner2;Speed Panner 2;4;0;Create;True;0;0;False;0;0,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;10;652.6251,-431.7696;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;8;412.6252,-575.7696;Float;False;Constant;_SpeedPanner1;Speed Panner 1;4;0;Create;True;0;0;False;0;0,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;9;844.6252,-431.7696;Float;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;faaa54b5537f89c4b8ac7b11c506428e;faaa54b5537f89c4b8ac7b11c506428e;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;65;412.6252,-271.7696;Float;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;1132.626,-399.7695;Float;False;Panner2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;652.6251,-607.7696;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;62;636.6251,-255.7696;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1824,496;Float;False;52;Panner2;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1840,576;Float;False;Constant;_BrightnessFix;Brightness Fix;4;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;844.6252,-607.7696;Float;True;Property;_WavesTexture;Waves Texture;7;0;Create;True;0;0;False;0;faaa54b5537f89c4b8ac7b11c506428e;faaa54b5537f89c4b8ac7b11c506428e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;848,-240;Float;True;Property;_NoiseTexture;Noise Texture;9;0;Create;True;0;0;False;0;None;f0a9ea1c2a35ccd4cb94fb9bc85e7c49;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1536,1584;Float;False;Property;_MeleeFireOpacity;Melee Fire Opacity;2;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;-1360,1360;Float;True;Property;_Dissolve;Dissolve;10;0;Create;True;0;0;False;0;e28dc97a9541e3642a48c0e3886688c5;dae0de7931aca94459db2375c7425b0d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;1132.626,-575.7696;Float;False;Panner1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;1132.626,-223.7697;Float;False;Panner3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-1632,512;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;95;-1248,1568;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;-1488,512;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1344,1248;Float;False;Constant;_Fix;Fix;10;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-992,1184;Float;False;Constant;_Fix2;Fix2;10;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-1026.784,1583.557;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1520,432;Float;False;50;Panner1;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1344,1168;Float;False;66;Panner3;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1168,1168;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;42;-1264,976;Float;True;Property;_ColorRamp;Color Ramp;8;0;Create;True;0;0;False;0;None;cda330af280bcb84ca2ea94d8860c805;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SaturateNode;102;-896.1116,1534.851;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1328,432;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;72;-832,1168;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-1120,240;Float;False;Property;_ColorWhite;Color White;4;0;Create;True;0;0;False;0;0.862069,1,0,0;0.862069,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;40;-944,992;Float;True;Property;_Noise;Noise;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;71;-672,1136;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-944,496;Float;False;Property;_RangedFireOpacity;Ranged Fire Opacity;3;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;96;-720,1376;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;20;-1120,432;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1120,80;Float;False;Property;_ColorBlack;Color Black;5;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;83;-684,559;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-640,992;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.6029412;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;97;-544,1408;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-736,224;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1264,784;Float;False;Property;_VertexOffsetIntensity;Vertex Offset Intensity;0;0;Create;True;0;0;False;0;0;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;82;-772,629;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-544,432;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-560,224;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-496,992;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;21;-1200,656;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-1280,848;Float;False;Property;_VertexOffsetMultiplier;Vertex Offset Multiplier;6;0;Create;True;0;0;False;0;0;0.026;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-351.6999,990.7;Float;True;MeleeHandsOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-896,768;Float;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-400,224;Float;True;RangedHandsOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-400,432;Float;True;RangedHandsOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;77;-736,640;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.05;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-544,736;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;464,304;Float;False;78;RangedHandsOpacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;464,144;Float;False;74;RangedHandsOutput;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;480,224;Float;False;73;MeleeHandsOutput;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;752,160;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-400,736;Float;True;RangedHandsVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;752,320;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;48;880,320;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;432,384;Float;False;81;RangedHandsVertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;46;880,160;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1040,112;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Fire Hands;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;7;0
WireConnection;10;2;11;0
WireConnection;9;1;10;0
WireConnection;52;0;9;1
WireConnection;6;0;7;0
WireConnection;6;2;8;0
WireConnection;62;0;7;0
WireConnection;62;2;65;0
WireConnection;1;1;6;0
WireConnection;63;1;62;0
WireConnection;50;0;1;1
WireConnection;66;0;63;1
WireConnection;15;0;54;0
WireConnection;15;1;14;0
WireConnection;95;0;43;0
WireConnection;17;0;15;0
WireConnection;103;0;100;1
WireConnection;103;1;95;0
WireConnection;68;0;67;0
WireConnection;68;1;69;0
WireConnection;102;0;103;0
WireConnection;19;0;53;0
WireConnection;19;1;17;0
WireConnection;72;0;70;0
WireConnection;40;0;42;0
WireConnection;40;1;68;0
WireConnection;71;0;72;0
WireConnection;96;0;102;0
WireConnection;20;0;19;0
WireConnection;83;0;26;0
WireConnection;60;0;40;0
WireConnection;60;1;71;0
WireConnection;97;0;96;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;20;0
WireConnection;82;0;83;0
WireConnection;30;0;20;0
WireConnection;30;1;26;0
WireConnection;49;0;4;0
WireConnection;49;1;26;0
WireConnection;44;0;60;0
WireConnection;44;1;97;0
WireConnection;73;0;44;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;22;2;23;0
WireConnection;22;3;24;0
WireConnection;74;0;49;0
WireConnection;78;0;30;0
WireConnection;77;0;82;0
WireConnection;31;0;77;0
WireConnection;31;1;22;0
WireConnection;45;0;88;0
WireConnection;45;1;87;0
WireConnection;81;0;31;0
WireConnection;47;0;87;0
WireConnection;47;1;85;0
WireConnection;48;0;47;0
WireConnection;46;0;45;0
WireConnection;0;2;46;0
WireConnection;0;9;48;0
WireConnection;0;11;84;0
ASEEND*/
//CHKSM=06F11A07ECB0C23E66A4C1D5E47E4B39EEF9D5C9