// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Walls"
{
	Properties
	{
		_Wallsv6AlbedoTR("Walls v6 AlbedoTR", 2D) = "white" {}
		_Wallsv6AO("Walls v6 AO", 2D) = "white" {}
		_Wallsv6Normal("Walls v6 Normal", 2D) = "bump" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Wallsv6Height("Walls v6 Height", 2D) = "white" {}
		_AmblientOcclusionIntensity("Amblient Occlusion Intensity", Range( 0 , 5)) = 0
		_Wallsv6MetallicSmth("Walls v6 MetallicSmth", 2D) = "white" {}
		_TesselIntensity("Tessel Intensity", Range( 0 , 0.25)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Wallsv6Height;
		uniform float4 _Wallsv6Height_ST;
		uniform float _TesselIntensity;
		uniform sampler2D _Wallsv6Normal;
		uniform float4 _Wallsv6Normal_ST;
		uniform sampler2D _Wallsv6AlbedoTR;
		uniform float4 _Wallsv6AlbedoTR_ST;
		uniform sampler2D _Wallsv6AO;
		uniform float4 _Wallsv6AO_ST;
		uniform float _AmblientOcclusionIntensity;
		uniform float _Metallic;
		uniform sampler2D _Wallsv6MetallicSmth;
		uniform float4 _Wallsv6MetallicSmth_ST;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_Wallsv6Height = v.texcoord * _Wallsv6Height_ST.xy + _Wallsv6Height_ST.zw;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( tex2Dlod( _Wallsv6Height, float4( uv_Wallsv6Height, 0, 0.0) ).r * ase_vertexNormal * _TesselIntensity );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Wallsv6Normal = i.uv_texcoord * _Wallsv6Normal_ST.xy + _Wallsv6Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Wallsv6Normal, uv_Wallsv6Normal ) );
			float2 uv_Wallsv6AlbedoTR = i.uv_texcoord * _Wallsv6AlbedoTR_ST.xy + _Wallsv6AlbedoTR_ST.zw;
			float2 uv_Wallsv6AO = i.uv_texcoord * _Wallsv6AO_ST.xy + _Wallsv6AO_ST.zw;
			float lerpResult28 = lerp( 1.0 , tex2D( _Wallsv6AO, uv_Wallsv6AO ).r , _AmblientOcclusionIntensity);
			float4 temp_cast_0 = (saturate( lerpResult28 )).xxxx;
			float4 blendOpSrc25 = tex2D( _Wallsv6AlbedoTR, uv_Wallsv6AlbedoTR );
			float4 blendOpDest25 = temp_cast_0;
			o.Albedo = ( saturate( ( blendOpSrc25 * blendOpDest25 ) )).rgb;
			float2 uv_Wallsv6MetallicSmth = i.uv_texcoord * _Wallsv6MetallicSmth_ST.xy + _Wallsv6MetallicSmth_ST.zw;
			float4 tex2DNode12 = tex2D( _Wallsv6MetallicSmth, uv_Wallsv6MetallicSmth );
			o.Metallic = saturate( ( _Metallic + tex2DNode12.r ) );
			o.Smoothness = saturate( ( _Smoothness + tex2DNode12.r ) );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
-507;73;505;927;1525.207;763.832;2.065537;True;False
Node;AmplifyShaderEditor.SamplerNode;2;-974.8026,-220.2853;Float;True;Property;_Wallsv6AO;Walls v6 AO;6;0;Create;True;0;0;False;0;314cc6a9e4975474e8973f06183678bf;9d8f5958000f53e49be420d73415d8cc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-978.4037,-292.9319;Float;False;Property;_AmblientOcclusionIntensity;Amblient Occlusion Intensity;11;0;Create;True;0;0;False;0;0;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-643.6671,98.24027;Float;False;Property;_Metallic;Metallic;8;0;Create;True;0;0;False;0;0;0.097;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-663.6671,261.2401;Float;True;Property;_Wallsv6MetallicSmth;Walls v6 MetallicSmth;12;0;Create;True;0;0;False;0;49f794fb786600241a94d5c088310ecd;b76c7c900ae3e3745bde0117d294d52d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-518,790;Float;False;Property;_TesselIntensity;Tessel Intensity;13;0;Create;True;0;0;False;0;0;0.205;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-831.6916,-482.0125;Float;True;Property;_Wallsv6AlbedoTR;Walls v6 AlbedoTR;5;0;Create;True;0;0;False;0;25dd9c54b726426459138e4a9083d3af;6306a351d31de434286ab28df0e84285;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-647.6671,181.2402;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;False;0;0;0.247;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;-676.0168,-256.0743;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;29;-517.0168,-211.0743;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;21;-224.047,625.0067;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;30;-404.0168,-244.0743;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-343.8457,210.8071;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;31;-432,656;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-592,464;Float;True;Property;_Wallsv6Height;Walls v6 Height;10;0;Create;True;0;0;False;0;d64e0ad1903bacf4baeb061eb48de920;e247c266172b4fd4895e32c353012fc9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-340.8457,306.8072;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-197,491;Float;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;25;-367.9885,-237.2882;Float;False;Multiply;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-531.7781,-111.316;Float;True;Property;_Wallsv6Normal;Walls v6 Normal;7;0;Create;True;0;0;False;0;768a5f4e34b92d749b7323d7fea594f0;5f9e5b5fbae03074eb65486f6b910d21;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;15;-218.8457,305.8072;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;19;-221.8456,210.8071;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Walls;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;6;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;1;2;1
WireConnection;28;2;27;0
WireConnection;29;0;28;0
WireConnection;21;0;10;0
WireConnection;30;0;1;0
WireConnection;17;0;4;0
WireConnection;17;1;12;1
WireConnection;14;0;5;0
WireConnection;14;1;12;1
WireConnection;9;0;6;1
WireConnection;9;1;31;0
WireConnection;9;2;21;0
WireConnection;25;0;30;0
WireConnection;25;1;29;0
WireConnection;15;0;14;0
WireConnection;19;0;17;0
WireConnection;0;0;25;0
WireConnection;0;1;3;0
WireConnection;0;3;19;0
WireConnection;0;4;15;0
WireConnection;0;11;9;0
ASEEND*/
//CHKSM=930F5DAEDEA31C1B067AF979313BD03F3A033866