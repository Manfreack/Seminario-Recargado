// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Snowy Rock"
{
	Properties
	{
		_RockAlbedo("Rock Albedo", 2D) = "white" {}
		_RockNormal("Rock Normal", 2D) = "bump" {}
		_SnowVertexOffsetIntensity("Snow Vertex Offset Intensity", Float) = 0
		_SnowAlbedo("Snow Albedo", 2D) = "white" {}
		_Position("Position", Float) = -0.62
		_Gradient("Gradient", Float) = 4.42
		_snow_normal("snow_normal", 2D) = "bump" {}
		_Noise("Noise", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _Gradient;
		uniform float _Position;
		uniform float _SnowVertexOffsetIntensity;
		uniform sampler2D _RockNormal;
		uniform float4 _RockNormal_ST;
		uniform sampler2D _snow_normal;
		uniform float4 _snow_normal_ST;
		uniform sampler2D _RockAlbedo;
		uniform float4 _RockAlbedo_ST;
		uniform sampler2D _SnowAlbedo;
		uniform float4 _SnowAlbedo_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_Noise = v.texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform25 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float4 SnowAmount18 = saturate( ( tex2Dlod( _Noise, float4( uv_Noise, 0, 0.0) ) * ( ( transform25.y * _Gradient ) + _Position ) ) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( SnowAmount18 * float4( ase_vertexNormal , 0.0 ) * _SnowVertexOffsetIntensity ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_RockNormal = i.uv_texcoord * _RockNormal_ST.xy + _RockNormal_ST.zw;
			float3 tex2DNode4 = UnpackNormal( tex2D( _RockNormal, uv_RockNormal ) );
			float2 uv_snow_normal = i.uv_texcoord * _snow_normal_ST.xy + _snow_normal_ST.zw;
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform25 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float4 SnowAmount18 = saturate( ( tex2D( _Noise, uv_Noise ) * ( ( transform25.y * _Gradient ) + _Position ) ) );
			float3 lerpResult22 = lerp( tex2DNode4 , BlendNormals( tex2DNode4 , UnpackNormal( tex2D( _snow_normal, uv_snow_normal ) ) ) , SnowAmount18.rgb);
			o.Normal = lerpResult22;
			float2 uv_RockAlbedo = i.uv_texcoord * _RockAlbedo_ST.xy + _RockAlbedo_ST.zw;
			float2 uv_SnowAlbedo = i.uv_texcoord * _SnowAlbedo_ST.xy + _SnowAlbedo_ST.zw;
			float4 lerpResult17 = lerp( tex2D( _RockAlbedo, uv_RockAlbedo ) , tex2D( _SnowAlbedo, uv_SnowAlbedo ) , SnowAmount18);
			o.Albedo = lerpResult17.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
934;92;595;522;214.717;-89.38861;1;False;False
Node;AmplifyShaderEditor.PosVertexDataNode;11;-385.282,-876.2504;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-143.7825,-717.5502;Float;False;Property;_Gradient;Gradient;5;0;Create;True;0;0;False;0;4.42;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;25;-177.2815,-876.2504;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;30.71869,-716.2502;Float;False;Property;_Position;Position;4;0;Create;True;0;0;False;0;-0.62;-0.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;30.71869,-812.2502;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;41.97415,-1014.155;Float;True;Property;_Noise;Noise;7;0;Create;True;0;0;False;0;None;96ae006e06772704bbed55377b01f931;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;206.7186,-812.2502;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;368,-832;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-96,-103;Float;True;Property;_RockNormal;Rock Normal;1;0;Create;True;0;0;False;0;d231ba82266856e4eab9480949f47e0b;d231ba82266856e4eab9480949f47e0b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;24;512,-832;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;20;176,73;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-368,89;Float;True;Property;_snow_normal;snow_normal;6;0;Create;True;0;0;False;0;24e31ecbf813d9e49bf7a1e0d4034916;24e31ecbf813d9e49bf7a1e0d4034916;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;656,-832;Float;False;SnowAmount;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;21;-32,73;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;9;-96,-375;Float;True;Property;_SnowAlbedo;Snow Albedo;3;0;Create;True;0;0;False;0;4112a019314dad94f9ffc2f8481f31bc;4112a019314dad94f9ffc2f8481f31bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;19;0,121;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;240,256;Float;False;18;SnowAmount;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-16,-183;Float;False;18;SnowAmount;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-16,217;Float;False;18;SnowAmount;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-96,-567;Float;True;Property;_RockAlbedo;Rock Albedo;0;0;Create;True;0;0;False;0;d2a55648dab9b73458261ff9789d5b55;d2a55648dab9b73458261ff9789d5b55;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;5;240,336;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;128,480;Float;False;Property;_SnowVertexOffsetIntensity;Snow Vertex Offset Intensity;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;336,-423;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;462,261;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;22;368,9;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;610,-14;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Snowy Rock;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;11;0
WireConnection;12;0;25;2
WireConnection;12;1;14;0
WireConnection;13;0;12;0
WireConnection;13;1;15;0
WireConnection;29;0;28;0
WireConnection;29;1;13;0
WireConnection;24;0;29;0
WireConnection;20;0;4;0
WireConnection;18;0;24;0
WireConnection;21;0;20;0
WireConnection;19;0;21;0
WireConnection;19;1;10;0
WireConnection;17;0;1;0
WireConnection;17;1;9;0
WireConnection;17;2;23;0
WireConnection;6;0;27;0
WireConnection;6;1;5;0
WireConnection;6;2;7;0
WireConnection;22;0;4;0
WireConnection;22;1;19;0
WireConnection;22;2;26;0
WireConnection;0;0;17;0
WireConnection;0;1;22;0
WireConnection;0;11;6;0
ASEEND*/
//CHKSM=1052C48CCEBA2FE7A38881B8B5B29C5314022CA4