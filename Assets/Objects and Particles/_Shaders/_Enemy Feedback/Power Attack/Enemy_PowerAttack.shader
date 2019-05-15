// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Enemy/Power Attack"
{
	Properties
	{
		_FresnelColor("Fresnel Color", Color) = (0,0,0,0)
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_OpacityMax("Opacity Max", Range( 0 , 1)) = 0
		_Dissolve("Dissolve", 2D) = "white" {}
		_Flowmap("Flowmap", 2D) = "white" {}
		_UVDistortion("UV Distortion", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Dissolve;
		uniform sampler2D _Flowmap;
		uniform float4 _Flowmap_ST;
		uniform float _UVDistortion;
		uniform float4 _FresnelColor;
		uniform float _Opacity;
		uniform float _OpacityMax;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Flowmap = i.uv_texcoord * _Flowmap_ST.xy + _Flowmap_ST.zw;
			float4 lerpResult50 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _Flowmap, uv_Flowmap ) , _UVDistortion);
			float2 panner44 = ( _Time.y * float2( 0.075,0 ) + lerpResult50.rg);
			float clampResult32 = clamp( _Opacity , 0.0 , _OpacityMax );
			float4 temp_output_31_0 = ( pow( tex2D( _Dissolve, panner44 ) , 1.5 ) * _FresnelColor * clampResult32 );
			o.Albedo = temp_output_31_0.rgb;
			o.Emission = temp_output_31_0.rgb;
			o.Alpha = clampResult32;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows noshadow 

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
671;73;968;653;922.5143;85.22653;1.038095;False;False
Node;AmplifyShaderEditor.RangedFloatNode;51;-1216,176;Float;False;Property;_UVDistortion;UV Distortion;10;0;Create;True;0;0;False;0;0;0.39;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-1232,-16;Float;True;Property;_Flowmap;Flowmap;9;0;Create;True;0;0;False;0;None;1207a4adcc48386458eb4425a0a3ecba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1168,-128;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;50;-832,-128;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;45;-864,-16;Float;False;Constant;_PannerSpeed;Panner Speed;9;0;Create;True;0;0;False;0;0.075,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;47;-848,96;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;30;-496,304;Float;False;428.4196;193.5309;Opacity: 0 = apagado   1 = prendido;3;32;33;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;44;-672,48;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-484,416;Float;False;Property;_OpacityMax;Opacity Max;7;0;Create;True;0;0;False;0;0;0.55;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-486,352;Float;False;Property;_Opacity;Opacity;6;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-496,16;Float;True;Property;_Dissolve;Dissolve;8;0;Create;True;0;0;False;0;dae0de7931aca94459db2375c7425b0d;dae0de7931aca94459db2375c7425b0d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;27;-49.76427,-629.13;Float;False;810.1542;260.1726;0 = apagado   0,5 = prendido   1 = apagado;5;7;28;10;9;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;1;-688,176;Float;False;Property;_FresnelColor;Fresnel Color;1;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;48;-208,16;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1.5;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;32;-208,368;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;28;234.1575,-577.0836;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;450.7355,-465.5573;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-634.5062,-538.6842;Float;False;Property;_FresnelScale;Fresnel Scale;3;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-634.5062,-474.6842;Float;False;Property;_FresnelPower;Fresnel Power;4;0;Create;True;0;0;False;0;5;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;606.2897,-579.1301;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-37.84253,-577.0836;Float;False;Property;_Life;Life ;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;450.7355,-577.5574;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;2;-330.5054,-602.6842;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-634.5062,-602.6842;Float;False;Property;_FresnelBias;Fresnel Bias;2;0;Create;True;0;0;False;0;0;0.09;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-32,160;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;128,160;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Enemy/Power Attack;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;50;0;43;0
WireConnection;50;1;49;0
WireConnection;50;2;51;0
WireConnection;44;0;50;0
WireConnection;44;2;45;0
WireConnection;44;1;47;0
WireConnection;34;1;44;0
WireConnection;48;0;34;0
WireConnection;32;0;26;0
WireConnection;32;2;33;0
WireConnection;28;0;7;0
WireConnection;11;0;28;0
WireConnection;10;0;9;0
WireConnection;10;2;11;0
WireConnection;9;2;28;0
WireConnection;2;1;3;0
WireConnection;2;2;4;0
WireConnection;2;3;5;0
WireConnection;31;0;48;0
WireConnection;31;1;1;0
WireConnection;31;2;32;0
WireConnection;0;0;31;0
WireConnection;0;2;31;0
WireConnection;0;9;32;0
ASEEND*/
//CHKSM=3A184E7F0D081AE50BEB9A71E718CA93678C6800