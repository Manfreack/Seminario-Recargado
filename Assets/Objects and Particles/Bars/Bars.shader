// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Bars"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Cuttingperfection("Cutting perfection", Float) = 0
		_Position("Position", Float) = 0
		_Barsv2("Bars v2", 2D) = "white" {}
		_OpacityCutout("Opacity Cutout", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Cuttingperfection;
		uniform float _Position;
		uniform sampler2D _Barsv2;
		uniform float4 _Barsv2_ST;
		uniform float _OpacityCutout;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_24_0 = saturate( ( ( ase_worldPos.y * _Cuttingperfection ) + _Position ) );
			float2 uv_Barsv2 = i.uv_texcoord * _Barsv2_ST.xy + _Barsv2_ST.zw;
			float4 tex2DNode26 = tex2D( _Barsv2, uv_Barsv2 );
			o.Albedo = ( temp_output_24_0 * tex2DNode26 ).rgb;
			o.Alpha = 1;
			clip( saturate( ( tex2DNode26.r * _OpacityCutout * temp_output_24_0 ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
838;92;719;655;315.3346;-5.7258;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;17;-1008,320;Float;False;Property;_Cuttingperfection;Cutting perfection;1;0;Create;True;0;0;False;0;0;-500;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-1072,48;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;-1053,224;Float;False;Property;_Position;Position;2;0;Create;True;0;0;False;0;0;720.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-774,94;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-384,96;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-82.33456,591.7258;Float;False;Property;_OpacityCutout;Opacity Cutout;4;0;Create;True;0;0;False;0;2;4.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;24;-113.5928,150.9295;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-247.7709,380.8098;Float;True;Property;_Barsv2;Bars v2;3;0;Create;True;0;0;False;0;a6df941bd64198341b33d24bf5be411d;66ba7812f6602574b9f7ebf99fff7a75;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;116.6654,446.7258;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;-617,232;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;50.69995,74.23566;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;29;256,448;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-770,302;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;432,73;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Bars;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;14;2
WireConnection;16;1;17;0
WireConnection;18;0;16;0
WireConnection;18;1;22;0
WireConnection;24;0;18;0
WireConnection;27;0;26;1
WireConnection;27;1;28;0
WireConnection;27;2;24;0
WireConnection;20;0;22;0
WireConnection;20;3;21;0
WireConnection;20;4;17;0
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;29;0;27;0
WireConnection;21;0;17;0
WireConnection;0;0;25;0
WireConnection;0;10;29;0
ASEEND*/
//CHKSM=98B69302799CA4C901034D5E73C994B77FCF356A