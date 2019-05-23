// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Snowy Nature"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_SnowyImage("Snowy Image", 2D) = "white" {}
		_Gradient("Gradient", Float) = 0
		_RegularImage("Regular Image", 2D) = "white" {}
		_Position("Position", Float) = 0
		_NormalMap("Normal Map", 2D) = "bump" {}
		_WindIntensity("Wind Intensity", Range( 0 , 0.05)) = 0
		_SnowGradient("Snow Gradient", Range( 0 , 5)) = 0.52
		_SnowPosition("Snow Position", Range( -2 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _Gradient;
		uniform float _Position;
		uniform float _WindIntensity;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _RegularImage;
		uniform float4 _RegularImage_ST;
		uniform sampler2D _SnowyImage;
		uniform float4 _SnowyImage_ST;
		uniform float _SnowGradient;
		uniform float _SnowPosition;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform13 = mul(unity_WorldToObject,float4( ase_vertex3Pos , 0.0 ));
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_cast_1 = (( saturate( ( ( transform13.y * _Gradient ) + _Position ) ) * ( ase_vertexNormal.x * _WindIntensity * sin( _Time.y ) ) )).xxx;
			v.vertex.xyz += temp_cast_1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_RegularImage = i.uv_texcoord * _RegularImage_ST.xy + _RegularImage_ST.zw;
			float4 tex2DNode2 = tex2D( _RegularImage, uv_RegularImage );
			float2 uv_SnowyImage = i.uv_texcoord * _SnowyImage_ST.xy + _SnowyImage_ST.zw;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform6 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float4 lerpResult4 = lerp( tex2DNode2 , tex2D( _SnowyImage, uv_SnowyImage ) , saturate( ( ( transform6.y * _SnowGradient ) + _SnowPosition ) ));
			o.Albedo = lerpResult4.rgb;
			o.Alpha = 1;
			clip( tex2DNode2.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
972;73;480;653;263.4387;-806.3934;1;False;False
Node;AmplifyShaderEditor.PosVertexDataNode;5;-672,192;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;12;-854.1932,712.5393;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-542,334;Float;False;Property;_SnowGradient;Snow Gradient;7;0;Create;True;0;0;False;0;0.52;3.98;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-614.1934,872.5394;Float;False;Property;_Gradient;Gradient;2;0;Create;True;0;0;False;0;0;247.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;6;-480,176;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;13;-662.1934,712.5393;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-443.8973,718.5405;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-327.4078,1227.807;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-320,400;Float;False;Property;_SnowPosition;Snow Position;8;0;Create;True;0;0;False;0;0;0.52;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-245.4521,189.1216;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-448.8973,801.9123;Float;False;Property;_Position;Position;4;0;Create;True;0;0;False;0;0;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-267.8973,1150.541;Float;False;Property;_WindIntensity;Wind Intensity;6;0;Create;True;0;0;False;0;0;0.005;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-32,192;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;23;-161.3192,1219.103;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;21;-186.5341,1017.708;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-299.8973,718.5405;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;-171.8974,718.5405;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-480,-17;Float;True;Property;_RegularImage;Regular Image;3;0;Create;True;0;0;False;0;16d1f834cd0d9d4418e5808e654719be;375df5d06b2fb7948abd22e7aa22801c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;173.5381,193.6637;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-480,-192;Float;True;Property;_SnowyImage;Snowy Image;1;0;Create;True;0;0;False;0;2ac1eec7ef095d64a88c429a19d77f19;d9f7b81c864dbcf4186f9b602a79c369;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;52.10265,926.5405;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-336,496;Float;True;Property;_NormalMap;Normal Map;5;0;Create;True;0;0;False;0;56c8f6f7deb891648a2452a8ab530196;ac3812f221ef6c949a000ed8fb85a2c6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;4;-96,0;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-144.934,929.3077;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;196.1026,718.5405;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;503.1157,-30.69476;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/Snowy Nature;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;13;0;12;0
WireConnection;15;0;13;2
WireConnection;15;1;14;0
WireConnection;8;0;6;2
WireConnection;8;1;7;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;23;0;20;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;11;0;9;0
WireConnection;24;0;21;1
WireConnection;24;1;22;0
WireConnection;24;2;23;0
WireConnection;4;0;2;0
WireConnection;4;1;1;0
WireConnection;4;2;11;0
WireConnection;19;0;18;0
WireConnection;19;1;24;0
WireConnection;0;0;4;0
WireConnection;0;1;3;0
WireConnection;0;10;2;4
WireConnection;0;11;19;0
ASEEND*/
//CHKSM=E9D66B080CCF3B1F3EA1DEF3F1226270F8335E1F