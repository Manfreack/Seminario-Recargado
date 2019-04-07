// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Blood Splash"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_BloodSplat("Blood Splat", 2D) = "white" {}
		_TesselDirection("Tessel Direction", Vector) = (1,0,0,0)
		_Gradient("Gradient", 2D) = "white" {}
		_Lifetime("Lifetime", Range( -1 , 1)) = 0
		_PerlinNoise("Perlin Noise", 2D) = "white" {}
		_PerlinBrightFix("Perlin Bright Fix", Range( 0 , 1)) = 0
		_TesselIntensity("Tessel Intensity", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Gradient;
		uniform float4 _Gradient_ST;
		uniform float _Lifetime;
		uniform sampler2D _PerlinNoise;
		uniform float4 _PerlinNoise_ST;
		uniform float _PerlinBrightFix;
		uniform float3 _TesselDirection;
		uniform float _TesselIntensity;
		uniform sampler2D _BloodSplat;
		uniform float4 _BloodSplat_ST;
		uniform float _Cutoff = 0.5;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_Gradient = v.texcoord * _Gradient_ST.xy + _Gradient_ST.zw;
			float2 uv_PerlinNoise = v.texcoord * _PerlinNoise_ST.xy + _PerlinNoise_ST.zw;
			float temp_output_47_0 = ( ( tex2Dlod( _Gradient, float4( uv_Gradient, 0, 0.0) ).r - saturate( (0.0 + (_Lifetime - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) ) ) * saturate( ( tex2Dlod( _PerlinNoise, float4( uv_PerlinNoise, 0, 0.0) ).r - _PerlinBrightFix ) ) );
			float4 transform53 = mul(unity_WorldToObject,float4( _TesselDirection , 0.0 ));
			v.vertex.xyz += ( temp_output_47_0 * transform53 * _TesselIntensity ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BloodSplat = i.uv_texcoord * _BloodSplat_ST.xy + _BloodSplat_ST.zw;
			float2 uv_Gradient = i.uv_texcoord * _Gradient_ST.xy + _Gradient_ST.zw;
			float2 uv_PerlinNoise = i.uv_texcoord * _PerlinNoise_ST.xy + _PerlinNoise_ST.zw;
			float temp_output_47_0 = ( ( tex2D( _Gradient, uv_Gradient ).r - saturate( (0.0 + (_Lifetime - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) ) ) * saturate( ( tex2D( _PerlinNoise, uv_PerlinNoise ).r - _PerlinBrightFix ) ) );
			float4 temp_output_36_0 = ( tex2D( _BloodSplat, uv_BloodSplat ) * saturate( ( ceil( temp_output_47_0 ) - saturate( (0.0 + (_Lifetime - 0.0) * (1.0 - 0.0) / (-1.0 - 0.0)) ) ) ) );
			o.Albedo = temp_output_36_0.rgb;
			o.Alpha = 1;
			clip( temp_output_36_0.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
750;92;806;655;1677.303;-917.9926;2.140277;False;False
Node;AmplifyShaderEditor.RangedFloatNode;23;-1168,400;Float;False;Property;_Lifetime;Lifetime;12;0;Create;True;0;0;False;0;0;0.5417697;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;63;-848,400;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-832,752;Float;False;Property;_PerlinBrightFix;Perlin Bright Fix;16;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-848,560;Float;True;Property;_PerlinNoise;Perlin Noise;14;0;Create;True;0;0;False;0;57d2bf093b0797b40ac4594b01e32048;57d2bf093b0797b40ac4594b01e32048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;60;-576,400;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-496,528;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-848,208;Float;True;Property;_Gradient;Gradient;11;0;Create;True;0;0;False;0;92a93c650dc9c5b49a21f93a5ee306cd;92a93c650dc9c5b49a21f93a5ee306cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-368,288;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;50;-336,528;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;68;-848,896;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;-1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-128,288;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;-454.18,951.4502;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;26;96,288;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;52;-361,651;Float;False;Property;_TesselDirection;Tessel Direction;8;0;Create;True;0;0;False;0;1,0,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;420.6494,873.1348;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-848,16;Float;True;Property;_BloodSplat;Blood Splat;7;0;Create;True;0;0;False;0;c93e7ce6654a85e49a5631eaa2eed054;c93e7ce6654a85e49a5631eaa2eed054;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;53;-160,656;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-240,816;Float;False;Property;_TesselIntensity;Tessel Intensity;19;0;Create;True;0;0;False;0;0;-0.26;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;49;432,288;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;81;-496,2288;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;83;-400,1984;Float;False;Property;_Vector1;Vector 1;9;0;Create;True;0;0;False;0;1,0,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;613.4803,1493.425;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;95,632;Float;True;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;75;-538.0297,1786.874;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;79;-896,2224;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;-1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;-896,1888;Float;True;Property;_TextureSample3;Texture Sample 3;15;0;Create;True;0;0;False;0;57d2bf093b0797b40ac4594b01e32048;57d2bf093b0797b40ac4594b01e32048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;94;-1008,1664;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;-1201.665,1710.976;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1616,1707.904;Float;False;Constant;_Float3;Float 3;16;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-880,2080;Float;False;Property;_Float4;Float 4;17;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;100;-768,1664;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;92;-1344,1600;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;86;-208,1984;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-288,2144;Float;False;Property;_Float5;Float 5;18;0;Create;True;0;0;False;0;0;-0.26;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;48,1968;Float;True;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;84;368,2208;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;76;-890.0297,1466.874;Float;True;Property;_TextureSample4;Texture Sample 4;10;0;Create;True;0;0;False;0;92a93c650dc9c5b49a21f93a5ee306cd;92a93c650dc9c5b49a21f93a5ee306cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-1282.91,2264.006;Float;False;Property;_Lifetime2;Lifetime 2;13;0;Create;True;0;0;False;0;0;0.5721119;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-170.0296,1546.874;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;85;-890.0297,1274.874;Float;True;Property;_TextureSample5;Texture Sample 5;6;0;Create;True;0;0;False;0;c93e7ce6654a85e49a5631eaa2eed054;c93e7ce6654a85e49a5631eaa2eed054;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;88;389.9703,1546.874;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;655.51,234.5514;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;78;-378.0297,1786.874;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;99;116.3331,1553.648;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-559.3758,1496.064;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1008,240;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Blood Splash;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;23;0
WireConnection;60;0;63;0
WireConnection;48;0;39;1
WireConnection;48;1;45;0
WireConnection;25;0;2;1
WireConnection;25;1;60;0
WireConnection;50;0;48;0
WireConnection;68;0;23;0
WireConnection;47;0;25;0
WireConnection;47;1;50;0
WireConnection;69;0;68;0
WireConnection;26;0;47;0
WireConnection;62;0;26;0
WireConnection;62;1;69;0
WireConnection;53;0;52;0
WireConnection;49;0;62;0
WireConnection;81;0;79;0
WireConnection;89;0;85;0
WireConnection;89;1;88;0
WireConnection;51;0;47;0
WireConnection;51;1;53;0
WireConnection;51;2;54;0
WireConnection;75;0;73;1
WireConnection;75;1;74;0
WireConnection;79;0;71;0
WireConnection;94;0;92;0
WireConnection;94;2;95;0
WireConnection;95;0;93;0
WireConnection;100;0;94;0
WireConnection;92;2;93;0
WireConnection;86;0;83;0
WireConnection;90;0;80;0
WireConnection;90;1;86;0
WireConnection;90;2;87;0
WireConnection;84;1;81;0
WireConnection;80;0;96;0
WireConnection;80;1;78;0
WireConnection;88;0;84;0
WireConnection;36;0;1;0
WireConnection;36;1;49;0
WireConnection;78;0;75;0
WireConnection;99;0;80;0
WireConnection;96;0;76;1
WireConnection;96;1;100;0
WireConnection;0;0;36;0
WireConnection;0;10;36;0
WireConnection;0;11;51;0
ASEEND*/
//CHKSM=A4C3B9A0EBBBF334E4816E09116CEDA817FB4F50