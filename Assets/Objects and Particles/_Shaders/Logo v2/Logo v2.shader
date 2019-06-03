// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Logo v2"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Life("Life", Range( 0 , 1)) = 0
		_TextImage("Text Image", 2D) = "white" {}
		_Tiling("Tiling", Float) = 0
		_NoiseImage("Noise Image", 2D) = "white" {}
		_BorderAmount("Border Amount", Range( 0 , 0.2)) = 0
		_BorderColor("Border Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextImage;
		uniform float4 _TextImage_ST;
		uniform sampler2D _NoiseImage;
		uniform float _Tiling;
		uniform float _Life;
		uniform float _BorderAmount;
		uniform float4 _BorderColor;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextImage = i.uv_texcoord * _TextImage_ST.xy + _TextImage_ST.zw;
			float4 TextOpacity37 = tex2D( _TextImage, uv_TextImage );
			float2 appendResult46 = (float2(_Tiling , _Tiling));
			float2 uv_TexCoord3 = i.uv_texcoord * appendResult46;
			float temp_output_8_0 = ( tex2D( _NoiseImage, uv_TexCoord3 ).r + _Life );
			float temp_output_29_0 = saturate( floor( temp_output_8_0 ) );
			float temp_output_30_0 = saturate( floor( ( temp_output_8_0 + _BorderAmount ) ) );
			o.Emission = ( ( TextOpacity37 * temp_output_29_0 ) + ( ( temp_output_30_0 - temp_output_29_0 ) * _BorderColor ) ).rgb;
			o.Alpha = 1;
			clip( ( TextOpacity37.a * temp_output_30_0 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
747;92;715;655;1168.458;785.8077;2.826941;False;False
Node;AmplifyShaderEditor.RangedFloatNode;48;-1312,240;Float;False;Property;_Tiling;Tiling;3;0;Create;True;0;0;False;0;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-1152,224;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1008,208;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-784,176;Float;True;Property;_NoiseImage;Noise Image;4;0;Create;True;0;0;False;0;None;611322fa830f08a439a04fa2f0521d43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-768,368;Float;False;Property;_Life;Life;1;0;Create;True;0;0;False;0;0;0.734;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-768,448;Float;False;Property;_BorderAmount;Border Amount;5;0;Create;True;0;0;False;0;0;0.002;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-480,176;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-304,432;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;6;-288,176;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;28;-192,432;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-774.5,-74.5;Float;True;Property;_TextImage;Text Image;2;0;Create;True;0;0;False;0;a96a95d3006320d4084eaaf1961b7d26;cf0001a048767894a82cbc22d236847c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;30;-64,432;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-496,-80;Float;False;TextOpacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;29;-64,368;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;128,480;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-96,144;Float;False;37;TextOpacity;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;496,384;Float;False;37;TextOpacity;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;36;-704,526.465;Float;False;Property;_BorderColor;Border Color;6;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;112,160;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;304,512;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;41;704,320;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;944,400;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;480,160;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1104,112;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;MyShaders/Logo v2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;48;0
WireConnection;46;1;48;0
WireConnection;3;0;46;0
WireConnection;2;1;3;0
WireConnection;8;0;2;1
WireConnection;8;1;7;0
WireConnection;27;0;8;0
WireConnection;27;1;11;0
WireConnection;6;0;8;0
WireConnection;28;0;27;0
WireConnection;30;0;28;0
WireConnection;37;0;1;0
WireConnection;29;0;6;0
WireConnection;31;0;30;0
WireConnection;31;1;29;0
WireConnection;9;0;38;0
WireConnection;9;1;29;0
WireConnection;35;0;31;0
WireConnection;35;1;36;0
WireConnection;41;0;40;0
WireConnection;34;0;41;3
WireConnection;34;1;30;0
WireConnection;21;0;9;0
WireConnection;21;1;35;0
WireConnection;0;2;21;0
WireConnection;0;10;34;0
ASEEND*/
//CHKSM=0CDB08E3465C44A91AE1EEE440BDCAD4F66774FE