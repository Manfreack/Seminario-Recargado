// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Rune Stone/Stone"
{
	Properties
	{
		_RuneStone_ALB("Rune Stone_ALB", 2D) = "white" {}
		_RuneStone_NORM("Rune Stone_NORM", 2D) = "bump" {}
		_RuneStone_METAL("Rune Stone_METAL", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_RuneStone_AO("Rune Stone_AO", 2D) = "white" {}
		_AmbientOcclusion("Ambient Occlusion", Range( 0 , 1)) = 0
		_Noise("Noise", 2D) = "white" {}
		_Jara("Jara", 2D) = "white" {}
		_Flowmap("Flowmap", 2D) = "white" {}
		_RuneIntensity("Rune Intensity", Range( 0 , 1)) = 0
		_RuneColorNotUsed("Rune Color Not Used", Color) = (0,0,0,0)
		_RuneColorUsed("Rune Color Used", Color) = (0,0,0,0)
		_RuneusedState("Rune used State", Range( 0 , 1)) = 0
		_UVDistortion("UV Distortion", Range( 0 , 1)) = 0
		_RuneDistortionY("Rune Distortion Y", Range( 0 , 0.25)) = 0
		_RuneDistortionX("Rune Distortion X", Range( 0 , 0.25)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _RuneStone_NORM;
		uniform float4 _RuneStone_NORM_ST;
		uniform sampler2D _RuneStone_ALB;
		uniform float4 _RuneStone_ALB_ST;
		uniform sampler2D _Jara;
		uniform sampler2D _Flowmap;
		uniform float _RuneDistortionX;
		uniform float _RuneDistortionY;
		uniform float _UVDistortion;
		uniform float4 _RuneColorNotUsed;
		uniform float4 _RuneColorUsed;
		uniform float _RuneusedState;
		uniform float _RuneIntensity;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform sampler2D _RuneStone_METAL;
		uniform float4 _RuneStone_METAL_ST;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform sampler2D _RuneStone_AO;
		uniform float4 _RuneStone_AO_ST;
		uniform float _AmbientOcclusion;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_RuneStone_NORM = i.uv_texcoord * _RuneStone_NORM_ST.xy + _RuneStone_NORM_ST.zw;
			o.Normal = UnpackNormal( tex2D( _RuneStone_NORM, uv_RuneStone_NORM ) );
			float2 uv_RuneStone_ALB = i.uv_texcoord * _RuneStone_ALB_ST.xy + _RuneStone_ALB_ST.zw;
			o.Albedo = tex2D( _RuneStone_ALB, uv_RuneStone_ALB ).rgb;
			float4 appendResult23 = (float4(_RuneDistortionX , _RuneDistortionY , 0.0 , 0.0));
			float2 panner20 = ( 1.0 * _Time.y * appendResult23.xy + i.uv_texcoord);
			float4 lerpResult26 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _Flowmap, panner20 ) , _UVDistortion);
			float4 lerpResult42 = lerp( _RuneColorNotUsed , _RuneColorUsed , _RuneusedState);
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			o.Emission = ( tex2D( _Jara, lerpResult26.rg ) * lerpResult42 * _RuneIntensity * saturate( pow( ( tex2D( _Noise, uv_Noise ).r + 0.45 ) , 4.48 ) ) ).rgb;
			float2 uv_RuneStone_METAL = i.uv_texcoord * _RuneStone_METAL_ST.xy + _RuneStone_METAL_ST.zw;
			float4 tex2DNode3 = tex2D( _RuneStone_METAL, uv_RuneStone_METAL );
			float lerpResult5 = lerp( 0.0 , tex2DNode3.r , ( _Metallic * 10.0 ));
			o.Metallic = lerpResult5;
			float lerpResult8 = lerp( 0.0 , tex2DNode3.r , ( _Smoothness * 10.0 ));
			o.Smoothness = lerpResult8;
			float2 uv_RuneStone_AO = i.uv_texcoord * _RuneStone_AO_ST.xy + _RuneStone_AO_ST.zw;
			float lerpResult10 = lerp( 1.0 , tex2D( _RuneStone_AO, uv_RuneStone_AO ).r , ( _AmbientOcclusion * 10.0 ));
			o.Occlusion = lerpResult10;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
0;92;1017;655;975.0483;84.38243;1.425631;True;False
Node;AmplifyShaderEditor.RangedFloatNode;25;-2160,384;Float;False;Property;_RuneDistortionY;Rune Distortion Y;15;0;Create;True;0;0;False;0;0;0.03;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2160,320;Float;False;Property;_RuneDistortionX;Rune Distortion X;16;0;Create;True;0;0;False;0;0;0.015;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-1664,912;Float;True;Property;_Noise;Noise;7;0;Create;True;0;0;False;0;None;f0a9ea1c2a35ccd4cb94fb9bc85e7c49;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1600,1104;Float;False;Constant;_NoiseWhiteAddition;Noise White Addition;16;0;Create;True;0;0;False;0;0.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1984,192;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;23;-1888,320;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1328,928;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;31;-1200,928;Float;False;2;0;FLOAT;0;False;1;FLOAT;4.48;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1184,753;Float;False;Property;_RuneusedState;Rune used State;13;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-1184,592;Float;False;Property;_RuneColorUsed;Rune Color Used;12;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;20;-1728,256;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;17;-1200,416;Float;False;Property;_RuneColorNotUsed;Rune Color Not Used;11;0;Create;True;0;0;False;0;0,0,0,0;1,0.7241379,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-1536,448;Float;False;Property;_UVDistortion;UV Distortion;14;0;Create;True;0;0;False;0;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-1552,256;Float;True;Property;_Flowmap;Flowmap;9;0;Create;True;0;0;False;0;None;a57dbc2ece21ece4ab0a8c7746bdc568;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;42;-832,400;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;34;-1040,928;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1184,832;Float;False;Property;_RuneIntensity;Rune Intensity;10;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;37;-601.3842,294.2028;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;40;-589.8835,319.9187;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-576,576;Float;False;Property;_Metallic;Metallic;3;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;35;-617.3842,276.2028;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-560,1040;Float;False;Property;_AmbientOcclusion;Ambient Occlusion;6;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-560,752;Float;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-1216,192;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-432,832;Float;True;Property;_RuneStone_AO;Rune Stone_AO;5;0;Create;True;0;0;False;0;1232cf2213dd5cd479360796dffa02e4;1232cf2213dd5cd479360796dffa02e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;39;-571.4144,305.0363;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-288,1024;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-288,736;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;38;-580.3842,282.2028;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-448,368;Float;True;Property;_RuneStone_METAL;Rune Stone_METAL;2;0;Create;True;0;0;False;0;6b9245e78e800fd4b83bb0e614e891bf;6b9245e78e800fd4b83bb0e614e891bf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-960,192;Float;True;Property;_Jara;Jara;8;0;Create;True;0;0;False;0;c6795be8d59b30b43835cea2e856bb96;c6795be8d59b30b43835cea2e856bb96;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;36;-599.3842,262.2028;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-304,560;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;-112,832;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-112,368;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;-112,528;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-448,16;Float;True;Property;_RuneStone_NORM;Rune Stone_NORM;1;0;Create;True;0;0;False;0;47ca8065bc6243549ada6b5e62cd4543;47ca8065bc6243549ada6b5e62cd4543;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-448,-176;Float;True;Property;_RuneStone_ALB;Rune Stone_ALB;0;0;Create;True;0;0;False;0;02c07b9196db3bd4ab97a001d885e59d;02c07b9196db3bd4ab97a001d885e59d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-307,200;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;176,144;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Rune Stone/Stone;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;24;0
WireConnection;23;1;25;0
WireConnection;32;0;30;1
WireConnection;32;1;33;0
WireConnection;31;0;32;0
WireConnection;20;0;21;0
WireConnection;20;2;23;0
WireConnection;19;1;20;0
WireConnection;42;0;17;0
WireConnection;42;1;41;0
WireConnection;42;2;43;0
WireConnection;34;0;31;0
WireConnection;37;0;18;0
WireConnection;40;0;34;0
WireConnection;35;0;42;0
WireConnection;26;0;21;0
WireConnection;26;1;19;0
WireConnection;26;2;27;0
WireConnection;39;0;40;0
WireConnection;14;0;11;0
WireConnection;13;0;7;0
WireConnection;38;0;37;0
WireConnection;15;1;26;0
WireConnection;36;0;35;0
WireConnection;12;0;4;0
WireConnection;10;1;9;1
WireConnection;10;2;14;0
WireConnection;5;1;3;1
WireConnection;5;2;12;0
WireConnection;8;1;3;1
WireConnection;8;2;13;0
WireConnection;16;0;15;0
WireConnection;16;1;36;0
WireConnection;16;2;38;0
WireConnection;16;3;39;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;16;0
WireConnection;0;3;5;0
WireConnection;0;4;8;0
WireConnection;0;5;10;0
ASEEND*/
//CHKSM=F1111C9C6B4595E0007611FEB19B6E819AB68B57