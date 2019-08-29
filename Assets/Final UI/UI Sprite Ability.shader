// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/UI/UI Sprite Ability"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_ColorIntensity("Color Intensity", Float) = 0
		_Noise("Noise", 2D) = "white" {}
		_FlareColor("Flare Color", Color) = (0.764151,0.5839693,0.126157,0)
		_NoiseSpeed("Noise Speed", Float) = 0
		_FlareIntensity("Flare Intensity", Range( 0 , 1)) = 0
		_NoiseIntensity("Noise Intensity", Range( 0 , 1)) = 0
		_State("State", Range( 0 , 1)) = 0
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

		uniform float _FlareIntensity;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _FlareColor;
		uniform float _ColorIntensity;
		uniform sampler2D _Noise;
		uniform float _NoiseSpeed;
		uniform float _NoiseIntensity;
		uniform float _State;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode23 = tex2D( _TextureSample0, uv_TextureSample0 );
			float2 appendResult44 = (float2(_NoiseSpeed , 0.0));
			float2 uv_TexCoord45 = i.uv_texcoord * float2( 0.2,0.2 );
			float2 panner46 = ( 1.0 * _Time.y * appendResult44 + uv_TexCoord45);
			float lerpResult49 = lerp( 1.0 , tex2D( _Noise, panner46 ).r , _NoiseIntensity);
			float4 lerpResult41 = lerp( float4( 0,0,0,0 ) , ( _FlareIntensity * saturate( ( tex2DNode23.r * tex2DNode23.a * _FlareColor * _ColorIntensity * lerpResult49 ) ) ) , _State);
			o.Emission = lerpResult41.rgb;
			o.Alpha = lerpResult41.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
202;73;842;653;324.0638;269.0265;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;43;-1322.083,666.7084;Float;False;Property;_NoiseSpeed;Noise Speed;5;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-1258.083,554.7084;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.2,0.2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;44;-1162.083,666.7084;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;46;-1002.085,554.7084;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;48;-826.0851,554.7084;Float;True;Property;_Noise;Noise;3;0;Create;True;0;0;False;0;f0a9ea1c2a35ccd4cb94fb9bc85e7c49;4ffac82e773499a479e1f785e78fc7aa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-810.0851,746.7084;Float;False;Property;_NoiseIntensity;Noise Intensity;7;0;Create;True;0;0;False;0;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-618.0163,79.65347;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;2ae8226c446a4f94d8027ad5e25cfa85;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;-611.8344,261.4459;Float;False;Property;_FlareColor;Flare Color;4;0;Create;True;0;0;False;0;0.764151,0.5839693,0.126157,0;0.764151,0.5839693,0.1261569,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-563.8344,437.4461;Float;False;Property;_ColorIntensity;Color Intensity;2;0;Create;True;0;0;False;0;0;2.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;49;-490.0851,554.7084;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-295.273,117.9375;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;37;-162.4267,113.3166;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-267.5788,-9.374786;Float;False;Property;_FlareIntensity;Flare Intensity;6;0;Create;True;0;0;False;0;0;0.887;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;67.42612,-5.909279;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-64,192;Float;False;Property;_State;State;8;0;Create;True;0;0;False;0;0;0.932;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;41;240,0;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;500,-48;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;MyShaders/UI/UI Sprite Ability;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;44;0;43;0
WireConnection;46;0;45;0
WireConnection;46;2;44;0
WireConnection;48;1;46;0
WireConnection;49;1;48;1
WireConnection;49;2;47;0
WireConnection;34;0;23;1
WireConnection;34;1;23;4
WireConnection;34;2;35;0
WireConnection;34;3;36;0
WireConnection;34;4;49;0
WireConnection;37;0;34;0
WireConnection;38;0;39;0
WireConnection;38;1;37;0
WireConnection;41;1;38;0
WireConnection;41;2;42;0
WireConnection;5;2;41;0
WireConnection;5;9;41;0
ASEEND*/
//CHKSM=688687D1437808BFB766A1B29112ADCC67F427B1