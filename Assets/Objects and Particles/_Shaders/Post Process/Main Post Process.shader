// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ASETemplateShaders/PostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_InitialFadeAmount("Initial Fade Amount", Range( 0 , 1)) = 0
		_HitGradient("Hit Gradient", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_FlowMap("FlowMap", 2D) = "white" {}
		_HitFillAmount("Hit Fill Amount", Range( 0 , 1)) = 0
		_HitBaseOverlay("Hit Base Overlay", Range( 0 , 1)) = 0
		_HitOverlayExtraIntensity("Hit Overlay Extra Intensity", Range( 0 , 0.1)) = 0
		_SinTimeScale("Sin Time Scale", Float) = 0
		_SinExtraAmount("Sin Extra Amount", Float) = 0
		_MaxHitOverlay("Max Hit Overlay", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _InitialFadeAmount;
			uniform sampler2D _HitGradient;
			uniform float4 _HitGradient_ST;
			uniform float _SinTimeScale;
			uniform float _SinExtraAmount;
			uniform sampler2D _Mask;
			uniform sampler2D _FlowMap;
			uniform float4 _FlowMap_ST;
			uniform float _HitBaseOverlay;
			uniform float _HitOverlayExtraIntensity;
			uniform float _HitFillAmount;
			uniform float _MaxHitOverlay;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 lerpResult8 = lerp( tex2D( _MainTex, uv_MainTex ) , float4( 0,0,0,0 ) , _InitialFadeAmount);
				float4 FinalFade18 = lerpResult8;
				float2 uv_HitGradient = i.uv.xy * _HitGradient_ST.xy + _HitGradient_ST.zw;
				float mulTime81 = _Time.y * _SinTimeScale;
				float2 uv050 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 uv_FlowMap = i.uv.xy * _FlowMap_ST.xy + _FlowMap_ST.zw;
				float4 lerpResult52 = lerp( float4( uv050, 0.0 , 0.0 ) , tex2D( _FlowMap, uv_FlowMap ) , 0.12);
				float2 panner55 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + lerpResult52.rg);
				float temp_output_62_0 = ( ( ( 1.0 - _HitBaseOverlay ) * tex2D( _HitGradient, uv_HitGradient ).r ) - _HitOverlayExtraIntensity );
				float4 lerpResult33 = lerp( float4(1,0,0,0) , float4( 1,1,1,0 ) , saturate( ( saturate( ( saturate( ( tex2D( _HitGradient, uv_HitGradient ).r * (0.0 + ((0.0 + (( sin( mulTime81 ) + 1.0 ) - 0.0) * (1.0 - 0.0) / (2.0 - 0.0)) - 0.0) * (0.5 - 0.0) / (1.0 - 0.0)) * _SinExtraAmount ) ) + ( tex2D( _Mask, panner55 ).r * temp_output_62_0 ) + temp_output_62_0 ) ) + (1.0 + (_HitFillAmount - 0.0) * ((1.0 + (_MaxHitOverlay - 0.0) * (0.75 - 1.0) / (1.0 - 0.0)) - 1.0) / (1.0 - 0.0)) ) ));
				float4 FinalHit35 = ( lerpResult33 * lerpResult33 );
				

				finalColor = ( FinalFade18 * FinalHit35 * FinalHit35 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16400
0;92;920;655;1928.612;-302.4661;1;False;False
Node;AmplifyShaderEditor.RangedFloatNode;105;-2542.857,7.705913;Float;False;Property;_SinTimeScale;Sin Time Scale;7;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-1488,640;Float;False;Property;_HitOverlayExtraIntensity;Hit Overlay Extra Intensity;6;0;Create;True;0;0;False;0;0;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1888,560;Float;False;Property;_HitBaseOverlay;Hit Base Overlay;5;0;Create;True;0;0;False;0;0;0.394;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;81;-2350.857,7.705913;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;96;-2174.857,7.705913;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-2190.857,71.70623;Float;False;Constant;_SinFix;Sin Fix;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1904,637.6522;Float;True;Property;_HitGradient;Hit Gradient;1;0;Create;True;0;0;False;0;None;ee9904b77bb100848946e286b28d624d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;111;-1232,624;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;69;-1616,496;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2240,608;Float;False;Constant;_FlowmapIntensity;Flowmap Intensity;5;0;Create;True;0;0;False;0;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-2304,416;Float;True;Property;_FlowMap;FlowMap;3;0;Create;True;0;0;False;0;None;f8b4f631d8791ef41bfd326e68272ebb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-2272,320;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;110;-1296,592;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1456,496;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-2030.86,7.705913;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;56;-1952,432;Float;False;Constant;_MaskSpeed;Mask Speed;5;0;Create;True;0;0;False;0;0,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;100;-1902.86,7.705913;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;-1280,496;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-1952,320;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;92;-1710.86,7.705913;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;76;-1168,464;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;55;-1776,320;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;115;-1824,-192;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;ee9904b77bb100848946e286b28d624d;True;0;False;white;Auto;False;Instance;12;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;102;-1744,176;Float;False;Property;_SinExtraAmount;Sin Extra Amount;8;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-1584,288;Float;True;Property;_Mask;Mask;2;0;Create;True;0;0;False;0;530294ed3de374e4db3e921adc2e865f;57d2bf093b0797b40ac4594b01e32048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1408.313,-12.65116;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;75;-1264,448;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-1472,800;Float;False;Property;_MaxHitOverlay;Max Hit Overlay;10;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;103;-1200.86,-12.29398;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1232,368;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;114;-1168,800;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-928,368;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1472,720;Float;False;Property;_HitFillAmount;Hit Fill Amount;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;-838.7364,573.5817;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-728,370;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-640,496;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;42;-437,499;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-576,176;Float;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;False;0;1,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-480,-128;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;33;-304,320;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-336,-128;Float;True;Property;_Screen;Screen;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-320,48;Float;False;Property;_InitialFadeAmount;Initial Fade Amount;0;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;16,-64;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-32,320;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;176,-64;Float;False;FinalFade;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;243,315;Float;False;FinalHit;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;592,224;Float;False;18;FinalFade;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;601,345;Float;False;35;FinalHit;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;601.7006,421.3083;Float;False;35;FinalHit;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;848,240;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;40;-576,336;Float;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1088,240;Float;False;True;2;Float;ASEMaterialInspector;0;2;ASETemplateShaders/PostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;81;0;105;0
WireConnection;96;0;81;0
WireConnection;111;0;60;0
WireConnection;69;0;63;0
WireConnection;110;0;111;0
WireConnection;72;0;69;0
WireConnection;72;1;12;1
WireConnection;98;0;96;0
WireConnection;98;1;99;0
WireConnection;100;0;98;0
WireConnection;62;0;72;0
WireConnection;62;1;110;0
WireConnection;52;0;50;0
WireConnection;52;1;49;0
WireConnection;52;2;53;0
WireConnection;92;0;100;0
WireConnection;76;0;62;0
WireConnection;55;0;52;0
WireConnection;55;2;56;0
WireConnection;43;1;55;0
WireConnection;90;0;115;1
WireConnection;90;1;92;0
WireConnection;90;2;102;0
WireConnection;75;0;76;0
WireConnection;103;0;90;0
WireConnection;48;0;43;1
WireConnection;48;1;75;0
WireConnection;114;0;109;0
WireConnection;46;0;103;0
WireConnection;46;1;48;0
WireConnection;46;2;62;0
WireConnection;58;0;36;0
WireConnection;58;4;114;0
WireConnection;47;0;46;0
WireConnection;39;0;47;0
WireConnection;39;1;58;0
WireConnection;42;0;39;0
WireConnection;33;0;34;0
WireConnection;33;2;42;0
WireConnection;4;0;2;0
WireConnection;8;0;4;0
WireConnection;8;2;7;0
WireConnection;57;0;33;0
WireConnection;57;1;33;0
WireConnection;18;0;8;0
WireConnection;35;0;57;0
WireConnection;17;0;20;0
WireConnection;17;1;21;0
WireConnection;17;2;77;0
WireConnection;0;0;17;0
ASEEND*/
//CHKSM=6816CE8A328751911E2BA5C8EE36FF64EC2107BD