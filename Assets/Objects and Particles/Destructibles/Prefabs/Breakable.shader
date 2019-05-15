// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Breakable"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Color("Color", Color) = (1,0.5217904,0,0)
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_MinWidth("Min Width", Range( 0 , 0.01)) = 0
		_MaxWidth("Max Width", Range( 0 , 0.03)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		
		
		struct Input
		{
			half filler;
		};
		uniform float _Opacity;
		uniform float _MinWidth;
		uniform float _MaxWidth;
		uniform float4 _Color;
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = (_MinWidth + (_Opacity - 0.0) * (_MaxWidth - _MinWidth) / (1.0 - 0.0));
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _Color.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
			clip( 1.0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
1087;73;552;653;895.5934;522.6063;1.452191;False;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-992,320;Float;False;Property;_Opacity;Opacity;2;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-992,448;Float;False;Property;_MaxWidth;Max Width;7;0;Create;True;0;0;False;0;0;0.0157;0;0.03;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-992,384;Float;False;Property;_MinWidth;Min Width;6;0;Create;True;0;0;False;0;0;0.0014;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-928,160;Float;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;1,0.5217904,0,0;0.6792453,0.6792453,0.6792453,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;16;-688,320;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1312,-176;Float;False;Property;_FresnelPower;Fresnel Power;3;0;Create;True;0;0;False;0;5;5.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1312,-240;Float;False;Property;_FresnelScale;Fresnel Scale;4;0;Create;True;0;0;False;0;1;0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1312,-304;Float;False;Property;_FresnelBias;Fresnel Bias;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-1104,-240;Float;False;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;10;-512,160;Float;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-702.7018,-149.0999;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-650.2169,75.59164;Float;False;Constant;_TotalOpacity;Total Opacity;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-288,-112;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Breakable;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;4;0
WireConnection;16;3;18;0
WireConnection;16;4;17;0
WireConnection;1;1;6;0
WireConnection;1;2;7;0
WireConnection;1;3;8;0
WireConnection;10;0;2;0
WireConnection;10;1;16;0
WireConnection;3;0;1;0
WireConnection;3;1;4;0
WireConnection;3;2;2;0
WireConnection;0;10;15;0
WireConnection;0;11;10;0
ASEEND*/
//CHKSM=682091E90F89655346B1BF5E9AF76AC812E6B06B