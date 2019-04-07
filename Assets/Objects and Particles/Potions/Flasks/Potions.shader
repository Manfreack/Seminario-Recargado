// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Potions"
{
	Properties
	{
		_Color0("Color 0", Color) = (1,0,0,0)
		_FillAmount("Fill Amount", Range( 0 , 100)) = 0
		_Falloff("Falloff", Range( 0 , 0.1)) = 0.02
		_Wavespeed("Wave speed", Range( 0 , 10)) = 0
		_Wavesize("Wave size", Range( 0 , 0.25)) = 0.1
		_ObjectOpacity("Object Opacity", Range( 0 , 1)) = 0
		_FresnelBias("Fresnel Bias", Float) = 0
		_FresnelScale("Fresnel Scale", Float) = 0.16
		_FresnelPower("Fresnel Power", Float) = 0.32
		_Color1("Color 1", Color) = (0.3602941,0.3602941,0.3602941,0.641)
		_FlaskOpacity("Flask Opacity", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Geometry+1" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Color1;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _FlaskOpacity;
		uniform float _Wavespeed;
		uniform float _Wavesize;
		uniform float _FillAmount;
		uniform float _Falloff;
		uniform float4 _Color0;
		uniform float _ObjectOpacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNDotV1 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode1 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNDotV1, _FresnelPower ) );
			float4 temp_output_56_0 = ( _Color1 * ( fresnelNode1 * _FlaskOpacity ) );
			float4 temp_output_58_0 = saturate( temp_output_56_0 );
			float mulTime26 = _Time.y * _Wavespeed;
			float4 transform41 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_output_42_0 = ( transform41 - float4( ase_worldPos , 0.0 ) );
			float4 temp_cast_2 = (( 1.0 - (1.0 + (_FillAmount - 0.0) * (1.5 - 1.0) / (100.0 - 0.0)) )).xxxx;
			float4 temp_output_44_0 = saturate( ( ( ( ( sin( mulTime26 ) * _Wavesize * temp_output_42_0 ) + temp_output_42_0.y ) - temp_cast_2 ) / _Falloff ) );
			o.Emission = ( temp_output_56_0 + ( temp_output_58_0 + ( temp_output_44_0 * _Color0 ) ) ).rgb;
			o.Alpha = ( saturate( ( temp_output_58_0 + temp_output_44_0 ) ) * _ObjectOpacity ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
540;92;985;655;1961.457;855.5678;2.580958;False;False
Node;AmplifyShaderEditor.RangedFloatNode;25;-1857.892,-92.51704;Float;False;Property;_Wavespeed;Wave speed;3;0;Create;True;0;0;False;0;0;0.91;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;40;-1767.893,243.4829;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;41;-1780.701,82.0377;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;26;-1578.773,-87.32869;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1559.95,274.6743;Float;False;Property;_FillAmount;Fill Amount;1;0;Create;True;0;0;False;0;0;23.8;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;42;-1546.895,81.48265;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;28;-1393.895,-86.51704;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1853.188,-13.38406;Float;False;Property;_Wavesize;Wave size;4;0;Create;True;0;0;False;0;0.1;0.1;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1212.895,-30.51712;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;45;-1261.088,280.3866;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;3;FLOAT;1;False;4;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;46;-1322.205,139.3639;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;2;-1204.149,-253.3577;Float;False;Property;_FresnelBias;Fresnel Bias;6;0;Create;True;0;0;False;0;0;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1212.149,-108.358;Float;False;Property;_FresnelPower;Fresnel Power;8;0;Create;True;0;0;False;0;0.32;-3.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1208.149,-179.358;Float;False;Property;_FresnelScale;Fresnel Scale;7;0;Create;True;0;0;False;0;0.16;2.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-1076.431,280.0186;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1028.894,138.4828;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FresnelNode;1;-1009.149,-248.3578;Float;True;Tangent;4;0;FLOAT3;0,0,1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1032.492,-37.57379;Float;False;Property;_FlaskOpacity;Flask Opacity;11;0;Create;True;0;0;False;0;0;0.554;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-828.9299,257.3579;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-957.8689,351.354;Float;False;Property;_Falloff;Falloff;2;0;Create;True;0;0;False;0;0.02;0.0016;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-735.1522,-250.4612;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;61;-1023.232,-421.5765;Float;False;Property;_Color1;Color 1;10;0;Create;True;0;0;False;0;0.3602941,0.3602941,0.3602941,0.641;0.3602941,0.3602941,0.3602941,0.641;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;36;-665.5485,256.2999;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-572.3993,-269.2002;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;58;-549.8014,133.4372;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;44;-534.8827,256.9513;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;39;-600.2324,384.7726;Float;False;Property;_Color0;Color 0;0;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-359.5401,167.8719;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-361.0822,260.2337;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;43.62292,256.9445;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;50;-207.8408,167.2876;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-358.8141,357.9514;Float;False;Property;_ObjectOpacity;Object Opacity;5;0;Create;True;0;0;False;0;0;0.784;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;122.085,86.27242;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-43.03508,169.8698;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;327.9788,28.25076;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Potions;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Front;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;False;1;True;Overlay;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;9;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;25;0
WireConnection;42;0;41;0
WireConnection;42;1;40;0
WireConnection;28;0;26;0
WireConnection;30;0;28;0
WireConnection;30;1;27;0
WireConnection;30;2;42;0
WireConnection;45;0;31;0
WireConnection;46;0;42;0
WireConnection;33;0;45;0
WireConnection;32;0;30;0
WireConnection;32;1;46;1
WireConnection;1;1;2;0
WireConnection;1;2;3;0
WireConnection;1;3;4;0
WireConnection;35;0;32;0
WireConnection;35;1;33;0
WireConnection;63;0;1;0
WireConnection;63;1;62;0
WireConnection;36;0;35;0
WireConnection;36;1;34;0
WireConnection;56;0;61;0
WireConnection;56;1;63;0
WireConnection;58;0;56;0
WireConnection;44;0;36;0
WireConnection;49;0;58;0
WireConnection;49;1;44;0
WireConnection;47;0;44;0
WireConnection;47;1;39;0
WireConnection;60;0;58;0
WireConnection;60;1;47;0
WireConnection;50;0;49;0
WireConnection;64;0;56;0
WireConnection;64;1;60;0
WireConnection;53;0;50;0
WireConnection;53;1;54;0
WireConnection;0;2;64;0
WireConnection;0;9;53;0
ASEEND*/
//CHKSM=E8793854B9E4FD6A822B87BCD543BBB38E2D2F83