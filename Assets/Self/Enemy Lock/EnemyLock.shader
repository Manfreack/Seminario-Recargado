// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Enemy Lock"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Splatmap("Splatmap", 2D) = "white" {}
		_OutterColor("Outter Color", Color) = (0,0,0,0)
		_InnerColor("Inner Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _InnerColor;
		uniform sampler2D _Splatmap;
		uniform float4 _OutterColor;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 _Anchor = float2(0.5,0.5);
			float cos36 = cos( _Time.y );
			float sin36 = sin( _Time.y );
			float2 rotator36 = mul( i.uv_texcoord - _Anchor , float2x2( cos36 , -sin36 , sin36 , cos36 )) + _Anchor;
			float temp_output_34_0 = floor( tex2D( _Splatmap, rotator36 ).r );
			float mulTime46 = _Time.y * ( 1.0 - 1.0 );
			float cos41 = cos( mulTime46 );
			float sin41 = sin( mulTime46 );
			float2 rotator41 = mul( i.uv_texcoord - _Anchor , float2x2( cos41 , -sin41 , sin41 , cos41 )) + _Anchor;
			float temp_output_33_0 = floor( tex2D( _Splatmap, rotator41 ).g );
			o.Emission = ( ( _InnerColor * temp_output_34_0 ) + ( temp_output_33_0 * _OutterColor ) ).rgb;
			o.Alpha = 1;
			clip( ( temp_output_34_0 + temp_output_33_0 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
960;92;596;655;2276.377;1226.525;3.457364;False;False
Node;AmplifyShaderEditor.RangedFloatNode;87;-3360,-64;Float;False;Constant;_BeatTimeScale;Beat Time Scale;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;86;-3159.696,-58.13087;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1949,54;Float;False;Constant;_RotatorTimeScale;Rotator Time Scale;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;85;-2999.192,-61.236;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;97;-1736.361,152.6518;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;84;-2862.534,-123.7886;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;90;-2865.357,43.67301;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;43;-2176,320;Float;False;Constant;_Anchor;Anchor;4;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;98;-1915.361,394.6518;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;-2638.411,-78.97504;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;92;-2632.511,17.63588;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;88;-2448,320;Float;False;Constant;_OutterTiling;Outter Tiling;4;0;Create;True;0;0;False;0;-0.5,-0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;99;-1992.071,19.81592;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;96;-1872,432;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;89;-2416,208;Float;False;Constant;_InnerTiling;Inner Tiling;4;0;Create;True;0;0;False;0;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-2215.511,27.63587;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-2224,208;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;46;-1712,432;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;100;-1954.071,-20.18408;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;48;-1714.776,58.60499;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;41;-1538.776,298.605;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;36;-1538.776,-85.39503;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;40;-1232,272;Float;True;Property;_SplatmapReference;Splatmap Reference;1;0;Create;True;0;0;False;0;473e99b7374e6854995d065b43c29697;473e99b7374e6854995d065b43c29697;True;0;False;white;Auto;False;Instance;28;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-1225.487,76.8086;Float;True;Property;_Splatmap;Splatmap;1;0;Create;True;0;0;False;0;473e99b7374e6854995d065b43c29697;473e99b7374e6854995d065b43c29697;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;33;-912,272;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;34;-912,48;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-944,-112;Float;False;Property;_InnerColor;Inner Color;3;0;Create;True;0;0;False;0;0,0,0,0;1,0.9018255,0.8382353,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;62;-709,500;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;60;-720,528;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-944,480;Float;False;Property;_OutterColor;Outter Color;2;0;Create;True;0;0;False;0;0,0,0,0;0.5661765,0.5661765,0.5661765,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-672,32;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;61;-688,544;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;63;-684,520;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-672,272;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-272,496;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-282.6686,131.7591;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;MyShaders/Enemy Lock;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;86;0;87;0
WireConnection;85;0;86;0
WireConnection;97;0;49;0
WireConnection;84;0;85;0
WireConnection;90;0;85;0
WireConnection;98;0;97;0
WireConnection;91;0;84;0
WireConnection;91;1;84;0
WireConnection;92;0;90;0
WireConnection;92;1;90;0
WireConnection;99;0;43;0
WireConnection;96;0;98;0
WireConnection;64;0;91;0
WireConnection;64;1;92;0
WireConnection;42;0;89;0
WireConnection;42;1;88;0
WireConnection;46;0;96;0
WireConnection;100;0;99;0
WireConnection;48;0;49;0
WireConnection;41;0;42;0
WireConnection;41;1;43;0
WireConnection;41;2;46;0
WireConnection;36;0;64;0
WireConnection;36;1;100;0
WireConnection;36;2;48;0
WireConnection;40;1;41;0
WireConnection;28;1;36;0
WireConnection;33;0;40;2
WireConnection;34;0;28;1
WireConnection;62;0;34;0
WireConnection;60;0;33;0
WireConnection;29;0;30;0
WireConnection;29;1;34;0
WireConnection;61;0;60;0
WireConnection;63;0;62;0
WireConnection;32;0;33;0
WireConnection;32;1;31;0
WireConnection;59;0;63;0
WireConnection;59;1;61;0
WireConnection;58;0;29;0
WireConnection;58;1;32;0
WireConnection;0;2;58;0
WireConnection;0;10;59;0
ASEEND*/
//CHKSM=B1441BC2C5DDA36522D14BADEFB5D934BE3B8DCA