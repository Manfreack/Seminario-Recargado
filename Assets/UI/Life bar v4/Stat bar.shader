// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Stat bar"
{
	Properties
	{
		_Splatmap("Splatmap", 2D) = "white" {}
		_BarColor("Bar Color", Color) = (1,0,0,0)
		_Noise("Noise", 2D) = "white" {}
		_NoiseAmount("Noise Amount", Range( 0 , 1)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_HorizontalMovement("Horizontal Movement", Range( 0 , 1)) = 0
		_VerticalMinMovement("Vertical Min Movement", Range( 0 , 1)) = 0
		_VerticalMaxMovement("Vertical Max Movement", Range( 0 , 1)) = 0
		_MovementTimeScale("Movement Time Scale", Float) = 0
		_HealthStamina("Health-Stamina", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
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

		uniform sampler2D _Noise;
		uniform float _MovementTimeScale;
		uniform float _HorizontalMovement;
		uniform float _VerticalMaxMovement;
		uniform float _VerticalMinMovement;
		uniform sampler2D _Texture0;
		uniform float _NoiseAmount;
		uniform float4 _BarColor;
		uniform sampler2D _Splatmap;
		uniform float4 _Splatmap_ST;
		uniform float _HealthStamina;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime24_g1 = _Time.y * _MovementTimeScale;
			float2 appendResult13_g1 = (float2(_HorizontalMovement , (_VerticalMaxMovement + (_SinTime.w - -1.0) * (_VerticalMinMovement - _VerticalMaxMovement) / (1.0 - -1.0))));
			float2 uv_TexCoord10_g1 = i.uv_texcoord * float2( 1,1 );
			float4 lerpResult12_g1 = lerp( float4( uv_TexCoord10_g1, 0.0 , 0.0 ) , tex2D( _Texture0, uv_TexCoord10_g1 ) , 0.3);
			float2 panner21_g1 = ( mulTime24_g1 * appendResult13_g1 + lerpResult12_g1.rg);
			float4 lerpResult7 = lerp( float4( 1,1,1,0 ) , tex2D( _Noise, panner21_g1 ) , _NoiseAmount);
			float2 uv_Splatmap = i.uv_texcoord * _Splatmap_ST.xy + _Splatmap_ST.zw;
			float4 tex2DNode1 = tex2D( _Splatmap, uv_Splatmap );
			float lerpResult19 = lerp( tex2DNode1.r , tex2DNode1.g , _HealthStamina);
			float4 temp_output_3_0 = ( _BarColor * lerpResult19 );
			float4 temp_output_34_0 = floor( ( temp_output_3_0 + 0.74 ) );
			o.Albedo = ( lerpResult7 * temp_output_3_0 * temp_output_34_0 ).rgb;
			float4 break27 = temp_output_34_0;
			o.Alpha = pow( ( break27.r + break27.g ) , 1.0 );
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
0;92;920;655;-75.65656;116.2809;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;23;-624,176;Float;False;Property;_HealthStamina;Health-Stamina;10;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-624,-16;Float;True;Property;_Splatmap;Splatmap;1;0;Create;True;0;0;False;0;2120ef337c09cb744a9fe4511a142b9a;2120ef337c09cb744a9fe4511a142b9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-335,-176;Float;False;Property;_BarColor;Bar Color;2;0;Create;True;0;0;False;0;1,0,0,0;0,0.4338235,0.07479718,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;-304,128;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-112,0;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-172.6475,392.0305;Float;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;0.74;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1072,16;Float;False;Property;_MovementTimeScale;Movement Time Scale;9;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1136,-368;Float;True;Property;_Texture0;Texture 0;5;0;Create;True;0;0;False;0;None;f8b4f631d8791ef41bfd326e68272ebb;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-26.95227,339.7841;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1104,-112;Float;False;Property;_VerticalMaxMovement;Vertical Max Movement;8;0;Create;True;0;0;False;0;0;0.00053;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1104,-48;Float;False;Property;_VerticalMinMovement;Vertical Min Movement;7;0;Create;True;0;0;False;0;0;0.00048;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-928,-304;Float;False;Constant;_UVDistortion;UV Distortion;5;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;12;-912,-448;Float;False;Constant;_Tiling;Tiling;4;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;15;-1104,-176;Float;False;Property;_HorizontalMovement;Horizontal Movement;6;0;Create;True;0;0;False;0;0;0.03;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;34;101.2564,368.7088;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;10;-704,-384;Float;False;FogPanner;-1;;1;73ef78d5d665f3f4fb1758efb7d6df2d;0;7;29;FLOAT2;0,0;False;17;SAMPLER2D;0;False;16;FLOAT;0;False;20;FLOAT;0;False;18;FLOAT;0;False;19;FLOAT;0;False;26;FLOAT;0;False;1;FLOAT2;22
Node;AmplifyShaderEditor.BreakToComponentsNode;27;352,256;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;5;-352,-424;Float;True;Property;_Noise;Noise;3;0;Create;True;0;0;False;0;None;7921f8dc65bddfc4683992a67b3e2335;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-336,-240;Float;False;Property;_NoiseAmount;Noise Amount;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;592,256;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;8.677002,-310.1946;Float;False;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;208,-16;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;28;704,256;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;25;960,-16;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Stat bar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;1;1
WireConnection;19;1;1;2
WireConnection;19;2;23;0
WireConnection;3;0;4;0
WireConnection;3;1;19;0
WireConnection;35;0;3;0
WireConnection;35;1;36;0
WireConnection;34;0;35;0
WireConnection;10;29;12;0
WireConnection;10;17;13;0
WireConnection;10;16;14;0
WireConnection;10;20;15;0
WireConnection;10;18;16;0
WireConnection;10;19;17;0
WireConnection;10;26;18;0
WireConnection;27;0;34;0
WireConnection;5;1;10;22
WireConnection;37;0;27;0
WireConnection;37;1;27;1
WireConnection;7;1;5;0
WireConnection;7;2;8;0
WireConnection;6;0;7;0
WireConnection;6;1;3;0
WireConnection;6;2;34;0
WireConnection;28;0;37;0
WireConnection;25;0;6;0
WireConnection;25;9;28;0
ASEEND*/
//CHKSM=9AEAFE3F6F5CC2B200E27A8530C2800169E271CA