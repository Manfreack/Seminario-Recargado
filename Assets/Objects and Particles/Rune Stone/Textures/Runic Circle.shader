// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Rune Stone/Runic Circle"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 1
		_TessMax( "Tess Max Distance", Float ) = 5
		_VertexOffsetIntensity("Vertex Offset Intensity", Range( -0.1 , 0.1)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_RunicCircle("Runic Circle", 2D) = "white" {}
		_RotationSpeed("Rotation Speed", Range( 0 , 1)) = 0
		_Noise("Noise", 2D) = "white" {}
		_ColorNotUsed1("Color (Not Used) 1", Color) = (0.9598377,1,0.2720588,0)
		_ColorNotUsed2("Color (Not Used) 2", Color) = (0.6470588,0.2275862,0,0)
		_ColorUsed1("Color (Used) 1", Color) = (1,0,0,0)
		_ColorUsed2("Color (Used) 2", Color) = (0.5294118,0,0,0)
		_GlobalOpacity("Global Opacity", Range( 0 , 1)) = 0
		_StoneUsedState("Stone Used State", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Noise;
		uniform float _VertexOffsetIntensity;
		uniform float4 _ColorNotUsed1;
		uniform float4 _ColorNotUsed2;
		uniform float4 _ColorUsed1;
		uniform float4 _ColorUsed2;
		uniform float _StoneUsedState;
		uniform sampler2D _RunicCircle;
		uniform float _RotationSpeed;
		uniform float _GlobalOpacity;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 panner7 = ( 1.0 * _Time.y * float2( 0.05,0.03 ) + v.texcoord.xy);
			float Noise6 = tex2Dlod( _Noise, float4( panner7, 0, 0.0) ).r;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( Noise6 * ase_vertexNormal * _VertexOffsetIntensity );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner7 = ( 1.0 * _Time.y * float2( 0.05,0.03 ) + i.uv_texcoord);
			float Noise6 = tex2D( _Noise, panner7 ).r;
			float4 lerpResult10 = lerp( _ColorNotUsed1 , _ColorNotUsed2 , Noise6);
			float4 lerpResult31 = lerp( _ColorUsed1 , _ColorUsed2 , Noise6);
			float4 lerpResult35 = lerp( lerpResult10 , lerpResult31 , _StoneUsedState);
			float mulTime20 = _Time.y * _RotationSpeed;
			float cos12 = cos( mulTime20 );
			float sin12 = sin( mulTime20 );
			float2 rotator12 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos12 , -sin12 , sin12 , cos12 )) + float2( 0.5,0.5 );
			float4 tex2DNode1 = tex2D( _RunicCircle, rotator12 );
			o.Emission = ( lerpResult35 * tex2DNode1.r ).rgb;
			o.Alpha = 1;
			clip( ( tex2DNode1.r * (0.49 + (_GlobalOpacity - 0.0) * (0.55 - 0.49) / (1.0 - 0.0)) ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
982;73;480;578;486.5244;122.8329;1.306291;False;False
Node;AmplifyShaderEditor.RangedFloatNode;19;-1440,256;Float;False;Property;_RotationSpeed;Rotation Speed;8;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;9;-734.5464,-764.3888;Float;False;Constant;_NoiseSpeed;Noise Speed;3;0;Create;True;0;0;False;0;0.05,0.03;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-769.5767,-884.6977;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1232,16;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;18;-1184,128;Float;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;7;-494.5481,-876.389;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-1168,256;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-287.8806,-896.7229;Float;True;Property;_Noise;Noise;9;0;Create;True;0;0;False;0;None;611322fa830f08a439a04fa2f0521d43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;12;-944,0;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-656,-32;Float;True;Property;_RunicCircle;Runic Circle;7;0;Create;True;0;0;False;0;e6551f9059f4f3445926331f86b671de;e6551f9059f4f3445926331f86b671de;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-1552,-304;Float;False;Property;_ColorUsed1;Color (Used) 1;12;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;17.45146,-876.389;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-1568,-512;Float;False;Property;_ColorNotUsed1;Color (Not Used) 1;10;0;Create;True;0;0;False;0;0.9598377,1,0.2720588,0;0.9598377,1,0.2720588,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;11;-1152,-384;Float;False;6;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;25;-76.53656,33.45866;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1152,-176;Float;False;6;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-1360,-448;Float;False;Property;_ColorNotUsed2;Color (Not Used) 2;11;0;Create;True;0;0;False;0;0.6470588,0.2275862,0,0;0.6470588,0.2275862,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;-1360,-240;Float;False;Property;_ColorUsed2;Color (Used) 2;13;0;Create;True;0;0;False;0;0.5294118,0,0,0;0.5294118,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;37;-1167.92,-269.0046;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;38;-1168.92,-475.0046;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;10;-928,-464;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;31;-928,-256;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-512,160;Float;False;Property;_GlobalOpacity;Global Opacity;14;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-928,-144;Float;False;Property;_StoneUsedState;Stone Used State;15;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;26;-63.00449,49.99072;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;-641,-186;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;27;-388.187,499.0499;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;23;-224,208;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.49;False;4;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-384,432;Float;False;6;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;24;-60.0045,142.8847;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-448,639;Float;False;Property;_VertexOffsetIntensity;Vertex Offset Intensity;5;0;Create;True;0;0;False;0;0;0.05;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-32,160;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-343.9461,-65.39722;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-144,464;Float;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;144,-64;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Rune Stone/Runic Circle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;32;1;5;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;6;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;8;0
WireConnection;7;2;9;0
WireConnection;20;0;19;0
WireConnection;5;1;7;0
WireConnection;12;0;13;0
WireConnection;12;1;18;0
WireConnection;12;2;20;0
WireConnection;1;1;12;0
WireConnection;6;0;5;1
WireConnection;25;0;1;1
WireConnection;37;0;33;0
WireConnection;38;0;3;0
WireConnection;10;0;38;0
WireConnection;10;1;4;0
WireConnection;10;2;11;0
WireConnection;31;0;37;0
WireConnection;31;1;34;0
WireConnection;31;2;32;0
WireConnection;26;0;25;0
WireConnection;35;0;10;0
WireConnection;35;1;31;0
WireConnection;35;2;36;0
WireConnection;23;0;22;0
WireConnection;24;0;26;0
WireConnection;21;0;24;0
WireConnection;21;1;23;0
WireConnection;2;0;35;0
WireConnection;2;1;1;1
WireConnection;29;0;28;0
WireConnection;29;1;27;0
WireConnection;29;2;30;0
WireConnection;0;2;2;0
WireConnection;0;10;21;0
WireConnection;0;11;29;0
ASEEND*/
//CHKSM=D58FDEE3131F73139D7C895604D2B095F4A9B94E