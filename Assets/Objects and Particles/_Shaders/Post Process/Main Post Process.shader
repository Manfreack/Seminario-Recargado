// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ASETemplateShaders/PostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_InitialFadeAmount("Initial Fade Amount", Range( 0 , 1)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_HitFillAmount("Hit Fill Amount", Range( 0 , 1)) = 0
		_MaskI("Mask I", 2D) = "white" {}
		_FlowMap("FlowMap", 2D) = "white" {}
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
			uniform sampler2D _MaskI;
			uniform sampler2D _FlowMap;
			uniform float4 _FlowMap_ST;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float _HitFillAmount;

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
				float2 uv50 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 uv_FlowMap = i.uv.xy * _FlowMap_ST.xy + _FlowMap_ST.zw;
				float4 lerpResult52 = lerp( float4( uv50, 0.0 , 0.0 ) , tex2D( _FlowMap, uv_FlowMap ) , 0.12);
				float2 panner55 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + lerpResult52.rg);
				float2 uv_TextureSample0 = i.uv.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 tex2DNode12 = tex2D( _TextureSample0, uv_TextureSample0 );
				float4 lerpResult33 = lerp( float4(1,0,0,0) , float4(1,1,1,0) , saturate( ( saturate( ( ( tex2D( _MaskI, panner55 ).r * tex2DNode12.r ) + tex2DNode12.r ) ) + (1.0 + (_HitFillAmount - 0.0) * (0.75 - 1.0) / (1.0 - 0.0)) ) ));
				float4 FinalHit35 = ( lerpResult33 * lerpResult33 );
				

				finalColor = ( FinalFade18 * FinalHit35 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
613;92;922;655;573.8151;323.0057;1.005805;False;False
Node;AmplifyShaderEditor.RangedFloatNode;53;-2080,608;Float;False;Constant;_FlowmapIntensity;Flowmap Intensity;5;0;Create;True;0;0;False;0;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-2112,320;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;49;-2144,416;Float;True;Property;_FlowMap;FlowMap;4;0;Create;True;0;0;False;0;None;f8b4f631d8791ef41bfd326e68272ebb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;52;-1792,320;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;56;-1792,432;Float;False;Constant;_MaskSpeed;Mask Speed;5;0;Create;True;0;0;False;0;0,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;55;-1616,320;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-1424,464;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;92a93c650dc9c5b49a21f93a5ee306cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-1424,288;Float;True;Property;_MaskI;Mask I;3;0;Create;True;0;0;False;0;530294ed3de374e4db3e921adc2e865f;57d2bf093b0797b40ac4594b01e32048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1072,432;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-928,464;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1168,656;Float;False;Property;_HitFillAmount;Hit Fill Amount;2;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-800,464;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;-816,656;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-640,496;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-576,176;Float;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;False;0;1,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-480,-128;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;-576,336;Float;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;42;-512,496;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-336,-128;Float;True;Property;_Screen;Screen;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-320,48;Float;False;Property;_InitialFadeAmount;Initial Fade Amount;0;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-304,320;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;8;16,-64;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-32,320;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;608,304;Float;False;35;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;176,-64;Float;False;FinalFade;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;592,224;Float;False;18;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;192,320;Float;False;FinalHit;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;848,240;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1088,240;Float;False;True;2;Float;ASEMaterialInspector;0;1;ASETemplateShaders/PostProcess;c71b220b631b6344493ea3cf87110c93;0;0;SubShader 0 Pass 0;1;False;False;True;Off;False;False;True;2;True;7;False;True;0;False;0;0;0;False;False;False;False;False;False;False;False;False;True;2;0;0;0;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;52;0;50;0
WireConnection;52;1;49;0
WireConnection;52;2;53;0
WireConnection;55;0;52;0
WireConnection;55;2;56;0
WireConnection;43;1;55;0
WireConnection;48;0;43;1
WireConnection;48;1;12;1
WireConnection;46;0;48;0
WireConnection;46;1;12;1
WireConnection;47;0;46;0
WireConnection;58;0;36;0
WireConnection;39;0;47;0
WireConnection;39;1;58;0
WireConnection;42;0;39;0
WireConnection;4;0;2;0
WireConnection;33;0;34;0
WireConnection;33;1;40;0
WireConnection;33;2;42;0
WireConnection;8;0;4;0
WireConnection;8;2;7;0
WireConnection;57;0;33;0
WireConnection;57;1;33;0
WireConnection;18;0;8;0
WireConnection;35;0;57;0
WireConnection;17;0;20;0
WireConnection;17;1;21;0
WireConnection;0;0;17;0
ASEEND*/
//CHKSM=DE5A70CFC7A87AEB6C656135587D3E5DE4CB3B34