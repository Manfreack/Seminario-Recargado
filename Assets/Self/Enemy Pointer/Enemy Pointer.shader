// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Enemy Feedback/Enemy Pointer"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_EnemyPointerSplatmap("Enemy Pointer Splatmap", 2D) = "white" {}
		_OpacityFix("Opacity Fix", Float) = 0.1
		_GlowColorI("Glow Color I", Color) = (0.7132353,0.5164807,0,0)
		_ArrowColor("Arrow Color", Color) = (1,0,0,0)
		_GlowBeatTimeScale("Glow Beat Time Scale", Float) = 0
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
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _ArrowColor;
		uniform sampler2D _EnemyPointerSplatmap;
		uniform float4 _EnemyPointerSplatmap_ST;
		uniform float4 _GlowColorI;
		uniform float _GlowBeatTimeScale;
		uniform float _OpacityFix;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_EnemyPointerSplatmap = i.uv_texcoord * _EnemyPointerSplatmap_ST.xy + _EnemyPointerSplatmap_ST.zw;
			float4 tex2DNode1 = tex2D( _EnemyPointerSplatmap, uv_EnemyPointerSplatmap );
			float4 temp_output_6_0 = ( _ArrowColor * tex2DNode1.r );
			o.Albedo = temp_output_6_0.rgb;
			float mulTime23 = _Time.y * _GlowBeatTimeScale;
			float4 temp_output_10_0 = ( _GlowColorI * (0.0 + (sin( mulTime23 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) * ( tex2DNode1.g + tex2DNode1.b ) );
			o.Emission = saturate( temp_output_10_0 ).rgb;
			o.Alpha = ( temp_output_10_0 + temp_output_6_0 ).r;
			clip( pow( ( tex2DNode1.r + tex2DNode1.g + tex2DNode1.b ) , _OpacityFix ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
960;92;596;655;945.3365;300.9756;1.246668;False;False
Node;AmplifyShaderEditor.RangedFloatNode;22;-1488,-208;Float;False;Property;_GlowBeatTimeScale;Glow Beat Time Scale;5;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-1248,-208;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1136,256;Float;True;Property;_EnemyPointerSplatmap;Enemy Pointer Splatmap;1;0;Create;True;0;0;False;0;b6160b08a16fb354e949449759ebf067;b6160b08a16fb354e949449759ebf067;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;21;-1077.938,-206.2864;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-805.7087,23.15812;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-944,-208;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;27;-634.7648,-70.53755;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;19;-637.519,-28.47552;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;25;-614.91,-39.06403;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;17;-647.4971,145.8596;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;28;-612.7648,-58.63757;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;16;-547,212.7801;Float;False;325;261.2199;Negrada del Opacity;3;3;4;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;20;-415.519,-38.47552;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;26;-413.7648,-56.63757;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-592,-208;Float;False;Property;_GlowColorI;Glow Color I;3;0;Create;True;0;0;False;0;0.7132353,0.5164807,0,0;0.4705882,0.3991886,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;18;-618.4971,132.8596;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-592,-16;Float;False;Property;_ArrowColor;Arrow Color;4;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-536,401;Float;False;Property;_OpacityFix;Opacity Fix;2;0;Create;True;0;0;False;0;0.1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-496,288;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-353.2317,79.03896;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-349,-97;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-146.0982,194.9094;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;13;-208,-96;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;3;-368,288;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;64,32;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Enemy Feedback/Enemy Pointer;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;22;0
WireConnection;21;0;23;0
WireConnection;30;0;1;2
WireConnection;30;1;1;3
WireConnection;24;0;21;0
WireConnection;27;0;24;0
WireConnection;19;0;30;0
WireConnection;25;0;19;0
WireConnection;17;0;1;1
WireConnection;28;0;27;0
WireConnection;20;0;25;0
WireConnection;26;0;28;0
WireConnection;18;0;17;0
WireConnection;2;0;1;1
WireConnection;2;1;1;2
WireConnection;2;2;1;3
WireConnection;6;0;5;0
WireConnection;6;1;18;0
WireConnection;10;0;7;0
WireConnection;10;1;26;0
WireConnection;10;2;20;0
WireConnection;29;0;10;0
WireConnection;29;1;6;0
WireConnection;13;0;10;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;0;0;6;0
WireConnection;0;2;13;0
WireConnection;0;9;29;0
WireConnection;0;10;3;0
ASEEND*/
//CHKSM=C1912E67AB99C91AED5CB69761082A509FCF95D3