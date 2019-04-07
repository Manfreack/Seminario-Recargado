// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Bars"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_IronBars("Iron Bars", 2D) = "white" {}
		_Grey("Grey", Range( 0 , 1)) = 0.5225803
		_Gradient("Gradient", Float) = -0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _IronBars;
		uniform float4 _IronBars_ST;
		uniform float _Gradient;
		uniform float _Grey;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_IronBars = i.uv_texcoord * _IronBars_ST.xy + _IronBars_ST.zw;
			float4 tex2DNode1 = tex2D( _IronBars, uv_IronBars );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 temp_cast_0 = (( tex2DNode1.r * saturate( ( ( ase_vertex3Pos.y * _Gradient ) + _Grey ) ) )).xxx;
			o.Albedo = temp_cast_0;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
882;73;671;653;1679.383;792.2558;3.491413;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-909.4443,368.6765;Float;False;Property;_Gradient;Gradient;3;0;Create;True;0;0;False;0;-0.5;-2.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-965.4748,28.35812;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-706.6245,218.9286;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1015.273,440.5202;Float;False;Property;_Grey;Grey;2;0;Create;True;0;0;False;0;0.5225803;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-447.2154,419.95;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-474.2199,44.49811;Float;True;Property;_IronBars;Iron Bars;1;0;Create;True;0;0;False;0;be55814650ebe724fa509b29a79cd9d7;be55814650ebe724fa509b29a79cd9d7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;12;-188.6976,449.0607;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-142.2058,69.79758;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;129.3253,5.147519;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Bars;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;11;2
WireConnection;6;1;5;0
WireConnection;8;0;6;0
WireConnection;8;1;9;0
WireConnection;12;0;8;0
WireConnection;10;0;1;1
WireConnection;10;1;12;0
WireConnection;0;0;10;0
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=2BCE7F1D17A608B2230B93B7F747D9A065A0180C