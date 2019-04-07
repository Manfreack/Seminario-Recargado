// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Cork"
{
	Properties
	{
		_AlbedoDarkness("Albedo Darkness", Range( -1 , 0)) = -0.75
		_Cork("Cork", 2D) = "white" {}
		_Cork_AO("Cork_AO", 2D) = "white" {}
		_Cork_NORM("Cork_NORM", 2D) = "bump" {}
		_Cork_DISP("Cork_DISP", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Cork_NORM;
		uniform float4 _Cork_NORM_ST;
		uniform float _AlbedoDarkness;
		uniform sampler2D _Cork;
		uniform float4 _Cork_ST;
		uniform sampler2D _Cork_DISP;
		uniform float4 _Cork_DISP_ST;
		uniform sampler2D _Cork_AO;
		uniform float4 _Cork_AO_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Cork_NORM = i.uv_texcoord * _Cork_NORM_ST.xy + _Cork_NORM_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Cork_NORM, uv_Cork_NORM ) );
			float2 uv_Cork = i.uv_texcoord * _Cork_ST.xy + _Cork_ST.zw;
			o.Albedo = ( _AlbedoDarkness + tex2D( _Cork, uv_Cork ) ).rgb;
			float2 uv_Cork_DISP = i.uv_texcoord * _Cork_DISP_ST.xy + _Cork_DISP_ST.zw;
			o.Metallic = tex2D( _Cork_DISP, uv_Cork_DISP ).r;
			float2 uv_Cork_AO = i.uv_texcoord * _Cork_AO_ST.xy + _Cork_AO_ST.zw;
			o.Occlusion = tex2D( _Cork_AO, uv_Cork_AO ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
799;92;726;655;871.0583;201.0464;1;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-582.1802,-7.455457;Float;True;Property;_Cork;Cork;1;0;Create;True;0;0;False;0;7efd2ea130df5bb4a8219c6d55b0eb50;7efd2ea130df5bb4a8219c6d55b0eb50;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-567.0951,-77.41898;Float;False;Property;_AlbedoDarkness;Albedo Darkness;0;0;Create;True;0;0;False;0;-0.75;-0.433;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-582.189,184.8028;Float;True;Property;_Cork_NORM;Cork_NORM;3;0;Create;True;0;0;False;0;5c7c7c775c39b284fa253863596f6d02;5c7c7c775c39b284fa253863596f6d02;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-238.0953,0.2810059;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-585.5329,563.1608;Float;True;Property;_Cork_AO;Cork_AO;2;0;Create;True;0;0;False;0;4072649e8c833864baab838108020f4d;4072649e8c833864baab838108020f4d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-583.189,373.8028;Float;True;Property;_Cork_DISP;Cork_DISP;4;0;Create;True;0;0;False;0;58fc500eb5f180141928e2ff7e55988c;58fc500eb5f180141928e2ff7e55988c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Cork;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;4;1;1;0
WireConnection;0;0;4;0
WireConnection;0;1;7;0
WireConnection;0;3;9;1
WireConnection;0;5;5;1
ASEEND*/
//CHKSM=8F8CC2D6E45A7A05155ECCFDD48EE798C1F75074