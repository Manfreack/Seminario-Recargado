// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/Community/DissolveBurn"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_Albedo("Albedo", 2D) = "white" {}
		_DisolveGuide("Disolve Guide", 2D) = "white" {}
		_BurnRamp("Burn Ramp", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_DissolveTiling("Dissolve Tiling", Range( 0 , 2)) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float _DissolveAmount;
			uniform sampler2D _DisolveGuide;
			uniform float _DissolveTiling;
			uniform sampler2D _Albedo;
			uniform float4 _Albedo_ST;
			uniform sampler2D _BurnRamp;
			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 appendResult135 = (float2(_DissolveTiling , _DissolveTiling));
				float2 uv0136 = IN.texcoord.xy * appendResult135 + float2( 0,0 );
				float clampResult113 = clamp( (-4.0 + (( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DisolveGuide, uv0136 ).r ) - 0.0) * (4.0 - -4.0) / (1.0 - 0.0)) , 0.06 , 1.0 );
				float temp_output_130_0 = ( 1.0 - clampResult113 );
				float2 uv_Albedo = IN.texcoord.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float2 temp_cast_0 = (temp_output_130_0).xx;
				
				half4 color = ( saturate( temp_output_130_0 ) * tex2D( _Albedo, uv_Albedo ) * saturate( tex2D( _BurnRamp, temp_cast_0 ) ) );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16400
0;92;984;655;746.8428;269.3723;1.10789;False;False
Node;AmplifyShaderEditor.CommentaryNode;128;-1199.112,510.0833;Float;False;1139.971;487.7531;Dissolve - Opacity Mask;9;134;135;136;73;111;2;71;133;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1184,800;Float;False;Property;_DissolveTiling;Dissolve Tiling;5;0;Create;True;0;0;False;0;0.5;0.35;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;135;-912,800;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1136,592;Float;False;Property;_DissolveAmount;Dissolve Amount;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;136;-784,800;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;71;-655.2471,583.1434;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-557.5587,798.9492;Float;True;Property;_DisolveGuide;Disolve Guide;2;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;111;-526.4305,583.9279;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;129;-892.9326,49.09825;Float;False;814.5701;432.0292;Burn Effect - Emission;5;113;114;112;130;148;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-319.6845,566.4299;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;112;-878.1525,280.8961;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;113;-797.634,90.31517;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.06;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;130;-627.5982,83.10277;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-422.1431,295.0128;Float;True;Property;_BurnRamp;Burn Ramp;3;0;Create;True;0;0;False;0;None;8acb407038b79b04288829e85b3af56a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;-323.0742,-278.0451;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;00d06e3e9caada04aa3fe4771f61b2e6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;149;-130.8562,310.0542;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;148;-404.5051,133.8996;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;131;-325.7014,-110.6792;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;None;11f03d9db1a617e40b7ece71f0a84f6f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;132;144.1929,26.72195;Float;False;765.1592;493.9802;Created by The Four Headed Cat @fourheadedcat - www.twitter.com/fourheadedcat;1;142;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;133;-864,592;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;50.69139,161.1394;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;147;421.626,532.9007;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;142;593.4966,133.1225;Float;False;True;2;Float;ASEMaterialInspector;0;4;ASESampleShaders/Community/DissolveBurn;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;True;True;True;True;True;0;True;-9;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;135;0;134;0
WireConnection;135;1;134;0
WireConnection;136;0;135;0
WireConnection;71;0;4;0
WireConnection;2;1;136;0
WireConnection;111;0;71;0
WireConnection;73;0;111;0
WireConnection;73;1;2;1
WireConnection;112;0;73;0
WireConnection;113;0;112;0
WireConnection;130;0;113;0
WireConnection;114;1;130;0
WireConnection;149;0;114;0
WireConnection;148;0;130;0
WireConnection;133;0;4;0
WireConnection;126;0;148;0
WireConnection;126;1;78;0
WireConnection;126;2;149;0
WireConnection;142;0;126;0
ASEEND*/
//CHKSM=D66B44F769FA3C08573DD572CA5F5C57F493EE51