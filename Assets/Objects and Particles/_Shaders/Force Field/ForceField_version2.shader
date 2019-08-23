// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Force Field version2"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 24
		_Gradient("Gradient", Float) = 0
		_UpPosition("Up Position", Range( 0 , 1)) = 0
		_DownPosition("Down Position", Range( 0 , 1)) = 0
		_LeftPosition("Left Position", Range( 0 , 1)) = 0
		_RightPosition("Right Position", Range( 0 , 1)) = 0
		_NoiseSeamless("Noise Seamless", 2D) = "white" {}
		_ColorinWhite("Color in White", Color) = (1,0.9310346,0,0)
		_ColorinBlack("Color in Black", Color) = (1,0,0,0)
		_FillAmount("Fill Amount", Range( 0 , 1)) = 0.5285062
		_BorderAmount("Border Amount", Range( 0 , 0.1)) = 0.05327978
		_BorderColor("Border Color", Color) = (0,0,0,0)
		_BGSpeedY("BG Speed Y", Range( -0.1 , 0.1)) = -0.1
		_BGSpeedX("BG Speed X", Range( -0.1 , 0.1)) = 0.1
		_BGSpeedMultiplier("BG Speed Multiplier", Range( 0 , 2)) = 1.137254
		_Flowmap2("Flowmap2", 2D) = "white" {}
		_DepthFadeAmount("Depth Fade Amount", Range( 0 , 1)) = 0.2
		_Waves("Waves", 2D) = "white" {}
		_GlobalOpacity("Global Opacity", Range( 0 , 1)) = 0
		_FlowMapIntensity("FlowMap Intensity", Range( 0 , 1)) = 0
		_Snow("Snow", 2D) = "white" {}
		_MovementIntensity("Movement Intensity", Range( 0 , 1)) = 0
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
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
		};

		uniform sampler2D _Waves;
		uniform float _MovementIntensity;
		uniform float4 _BorderColor;
		uniform sampler2D _Snow;
		uniform sampler2D _Flowmap2;
		uniform float _FlowMapIntensity;
		uniform float4 _ColorinBlack;
		uniform float4 _ColorinWhite;
		uniform sampler2D _NoiseSeamless;
		uniform float _BGSpeedX;
		uniform float _BGSpeedMultiplier;
		uniform float _BGSpeedY;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeAmount;
		uniform float _Gradient;
		uniform float _RightPosition;
		uniform float _LeftPosition;
		uniform float _UpPosition;
		uniform float _DownPosition;
		uniform float _GlobalOpacity;
		uniform float _FillAmount;
		uniform float _BorderAmount;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 panner244 = ( 1.0 * _Time.y * float2( 0.1,-0.05 ) + v.texcoord.xy);
			float3 ase_vertexNormal = v.normal.xyz;
			float3 FinalVertexOffset262 = ( tex2Dlod( _Waves, float4( panner244, 0, 0.0) ).r * ase_vertexNormal * _MovementIntensity );
			v.vertex.xyz += FinalVertexOffset262;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 BorderColor275 = _BorderColor;
			float2 appendResult217 = (float2(0.1 , -0.05));
			float2 uv_TexCoord206 = i.uv_texcoord * float2( 4,4 );
			float4 lerpResult266 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _Flowmap2, uv_TexCoord206 ) , _FlowMapIntensity);
			float4 Flowmap214 = lerpResult266;
			float2 panner222 = ( 1.0 * _Time.y * appendResult217 + Flowmap214.rg);
			float2 appendResult268 = (float2(( _BGSpeedX * _BGSpeedMultiplier ) , ( _BGSpeedMultiplier * _BGSpeedY )));
			float2 panner270 = ( _Time.y * appendResult268 + Flowmap214.rg);
			float BGNoise272 = tex2D( _NoiseSeamless, panner270 ).r;
			float4 lerpResult230 = lerp( _ColorinBlack , _ColorinWhite , BGNoise272);
			float4 BGColor232 = lerpResult230;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth242 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth242 = abs( ( screenDepth242 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeAmount ) );
			float clampResult250 = clamp( distanceDepth242 , 0.0 , 1.0 );
			float4 lerpResult257 = lerp( BorderColor275 , saturate( ( ( 1.0 - ( tex2D( _Snow, panner222 ).r + 0.4 ) ) * BGColor232 ) ) , clampResult250);
			float4 FinalEmission264 = lerpResult257;
			o.Emission = FinalEmission264.rgb;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float Gradient149 = _Gradient;
			float temp_output_136_0 = ( ( ase_vertex3Pos.x * Gradient149 ) + ( Gradient149 / _RightPosition ) );
			float temp_output_178_0 = ( Gradient149 * -1.0 );
			float temp_output_147_0 = ( ( ase_vertex3Pos.x * temp_output_178_0 ) + ( temp_output_178_0 / ( _LeftPosition * -1.0 ) ) );
			float temp_output_196_0 = ( ( ase_vertex3Pos.z * Gradient149 ) + ( Gradient149 / _UpPosition ) );
			float temp_output_186_0 = ( Gradient149 * -1.0 );
			float temp_output_197_0 = ( ( ase_vertex3Pos.z * temp_output_186_0 ) + ( temp_output_186_0 / ( _DownPosition * -1.0 ) ) );
			float temp_output_223_0 = ( _FillAmount - BGNoise272 );
			float temp_output_235_0 = saturate( ceil( ( temp_output_223_0 + _BorderAmount ) ) );
			float FinalOpacity261 = ( _GlobalOpacity * ( BGNoise272 * temp_output_235_0 ) );
			o.Alpha = saturate( ( saturate( temp_output_136_0 ) * saturate( temp_output_147_0 ) * saturate( temp_output_196_0 ) * saturate( temp_output_197_0 ) * FinalOpacity261 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
304;73;1198;588;462.5693;-483.9373;1.3;True;False
Node;AmplifyShaderEditor.Vector2Node;205;-3401.41,348.4813;Float;False;Constant;_Vector0;Vector 0;19;0;Create;True;0;0;False;0;4,4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;206;-3253.41,288.4813;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;208;-2899.142,201.1915;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;207;-2963.142,313.1918;Float;True;Property;_Flowmap2;Flowmap2;21;0;Create;True;0;0;False;0;1207a4adcc48386458eb4425a0a3ecba;1207a4adcc48386458eb4425a0a3ecba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;265;-2947.142,505.1917;Float;False;Property;_FlowMapIntensity;FlowMap Intensity;25;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-3251.142,649.1917;Float;False;Property;_BGSpeedX;BG Speed X;19;0;Create;True;0;0;False;0;0.1;0.1;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;266;-2579.142,457.1917;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-3251.142,713.1917;Float;False;Property;_BGSpeedMultiplier;BG Speed Multiplier;20;0;Create;True;0;0;False;0;1.137254;0.26;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-3251.142,777.1918;Float;False;Property;_BGSpeedY;BG Speed Y;18;0;Create;True;0;0;False;0;-0.1;-0.1;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;-2963.142,745.1918;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;214;-2403.142,457.1917;Float;False;Flowmap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-2963.142,665.1917;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;268;-2739.142,697.1917;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;269;-2787.142,617.1918;Float;False;214;Flowmap;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;267;-2771.142,793.1918;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;270;-2579.142,665.1917;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;271;-2387.142,633.1917;Float;True;Property;_NoiseSeamless;Noise Seamless;10;0;Create;True;0;0;False;0;96ae006e06772704bbed55377b01f931;96ae006e06772704bbed55377b01f931;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;-2067.142,665.1917;Float;False;BGNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-3011.142,1401.191;Float;False;272;BGNoise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-3123.142,57.19155;Float;False;Constant;_Y;Y;19;0;Create;True;0;0;False;0;-0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-3123.142,-6.808558;Float;False;Constant;_X;X;19;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;219;-3107.142,1337.191;Float;False;Property;_FillAmount;Fill Amount;13;0;Create;True;0;0;False;0;0.5285062;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-3107.142,1273.191;Float;False;Property;_BorderAmount;Border Amount;14;0;Create;True;0;0;False;0;0.05327978;0.0873;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;223;-2819.142,1353.191;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;217;-2947.142,41.19155;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;-3123.142,-70.80859;Float;False;214;Flowmap;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;227;-2675.142,1273.191;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1708.187,-226.5453;Float;False;Property;_Gradient;Gradient;5;0;Create;True;0;0;False;0;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;273;-2066.449,501.6434;Float;False;Property;_ColorinWhite;Color in White;11;0;Create;True;0;0;False;0;1,0.9310346,0,0;1,0.9310346,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;222;-2803.142,-6.808558;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;225;-2066.449,341.6434;Float;False;Property;_ColorinBlack;Color in Black;12;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;230;-1778.448,453.6434;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;226;-2611.142,-38.8086;Float;True;Property;_Snow;Snow;26;0;Create;True;0;0;False;0;19ccfdaff4245fb42850b62f3440c776;19ccfdaff4245fb42850b62f3440c776;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;224;-2483.142,153.1915;Float;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-1548.187,-226.5453;Float;False;Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;228;-2563.142,1273.191;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;232;-1523.142,441.1917;Float;False;BGColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;240;-2467.142,1177.192;Float;False;272;BGNoise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;231;-2307.142,41.19155;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-1426,929;Float;False;Property;_LeftPosition;Left Position;8;0;Create;True;0;0;False;0;0;0.463;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-1346.467,1513.932;Float;False;149;Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;235;-2435.142,1273.191;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;-1333,848;Float;False;149;Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-1439.467,1594.932;Float;False;Property;_DownPosition;Down Position;7;0;Create;True;0;0;False;0;0;0.304;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;144;-1184,704;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;191;-1181.466,1193.931;Float;False;149;Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;188;-1197.466,1049.931;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-1130.305,837.5646;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;139;-1184,384;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-1142.466,1599.932;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-1129,934;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;187;-1197.466,1369.932;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;130;-1264,608;Float;False;Property;_RightPosition;Right Position;9;0;Create;True;0;0;False;0;0;0.442;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-1277.466,1273.931;Float;False;Property;_UpPosition;Up Position;6;0;Create;True;0;0;False;0;0;0.573;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;234;-2834.89,1655.97;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;150;-1168,528;Float;False;149;Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;239;-2802.89,1767.97;Float;False;Constant;_Vector1;Vector 1;19;0;Create;True;0;0;False;0;0.1,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-2243.142,1209.192;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-2291.142,1113.192;Float;False;Property;_GlobalOpacity;Global Opacity;24;0;Create;True;0;0;False;0;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;-2195.142,105.1915;Float;False;232;BGColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-1143.771,1503.497;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;237;-2179.142,41.19155;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-2339.142,217.1915;Float;False;Property;_DepthFadeAmount;Depth Fade Amount;22;0;Create;True;0;0;False;0;0.2;0.002;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;274;-2291.142,889.1918;Float;False;Property;_BorderColor;Border Color;16;0;Create;True;0;0;False;0;0,0,0,0;1,0.724138,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;-2067.142,873.1918;Float;False;BorderColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-928,720;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;145;-928,912;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-941.4655,1081.931;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-941.4655,1385.932;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;141;-912,592;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;194;-925.4655,1257.931;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-928,416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;193;-941.4655,1577.932;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;-2003.142,89.19149;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;244;-2578.89,1687.97;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;242;-2067.142,217.1915;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;260;-1971.142,1161.192;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;250;-1859.142,169.1915;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-752,496;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;197;-763.4657,1481.932;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-2354.89,1959.97;Float;False;Property;_MovementIntensity;Movement Intensity;27;0;Create;True;0;0;False;0;0;0.427;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;147;-750,816;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;-765.4657,1161.931;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;256;-1907.142,9.191442;Float;False;275;BorderColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;251;-1859.142,89.19149;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;254;-2386.89,1655.97;Float;True;Property;_Waves;Waves;23;0;Create;True;0;0;False;0;faaa54b5537f89c4b8ac7b11c506428e;faaa54b5537f89c4b8ac7b11c506428e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;255;-2274.89,1831.97;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;261;-1827.142,1161.192;Float;False;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;257;-1683.142,73.19143;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;200;-477.4659,1481.932;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;-1991.558,1823.474;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;148;-464,816;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;201;-477.4659,1161.931;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;138;-464,496;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;278;-499.4692,1692.668;Float;False;261;FinalOpacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;264;-1523.142,73.19143;Float;False;FinalEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;262;-1763.142,1817.191;Float;False;FinalVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-272,1056;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;276;-128,896;Float;False;263;FinalAlbedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;198;-637.4657,1161.931;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-128,1152;Float;False;262;FinalVertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;199;-637.4657,1481.932;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;181;-128,1056;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;183;-624,496;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;180;-624,816;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;249;-2099.142,1321.191;Float;False;232;BGColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;258;-1891.142,1369.191;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-2051.142,1401.191;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;245;-2307.142,1433.191;Float;False;275;BorderColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;243;-2243.142,1337.191;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;241;-2387.142,1513.191;Float;False;Property;_BorderOpacity;Border Opacity;17;0;Create;True;0;0;False;0;0;0.612;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;229;-2563.142,1353.191;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;233;-2435.142,1353.191;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;277;-128,976;Float;False;264;FinalEmission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;263;-1763.142,1369.191;Float;False;FinalAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;160,896;Float;False;True;6;Float;ASEMaterialInspector;0;0;Unlit;MyShaders/Force Field version2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;24;1;10;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;15;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;206;0;205;0
WireConnection;207;1;206;0
WireConnection;266;0;208;0
WireConnection;266;1;207;0
WireConnection;266;2;265;0
WireConnection;213;0;210;0
WireConnection;213;1;211;0
WireConnection;214;0;266;0
WireConnection;212;0;209;0
WireConnection;212;1;210;0
WireConnection;268;0;212;0
WireConnection;268;1;213;0
WireConnection;270;0;269;0
WireConnection;270;2;268;0
WireConnection;270;1;267;0
WireConnection;271;1;270;0
WireConnection;272;0;271;1
WireConnection;223;0;219;0
WireConnection;223;1;218;0
WireConnection;217;0;216;0
WireConnection;217;1;215;0
WireConnection;227;0;223;0
WireConnection;227;1;221;0
WireConnection;222;0;220;0
WireConnection;222;2;217;0
WireConnection;230;0;225;0
WireConnection;230;1;273;0
WireConnection;230;2;272;0
WireConnection;226;1;222;0
WireConnection;149;0;134;0
WireConnection;228;0;227;0
WireConnection;232;0;230;0
WireConnection;231;0;226;1
WireConnection;231;1;224;0
WireConnection;235;0;228;0
WireConnection;178;0;151;0
WireConnection;190;0;184;0
WireConnection;179;0;153;0
WireConnection;253;0;240;0
WireConnection;253;1;235;0
WireConnection;186;0;185;0
WireConnection;237;0;231;0
WireConnection;275;0;274;0
WireConnection;146;0;144;1
WireConnection;146;1;178;0
WireConnection;145;0;178;0
WireConnection;145;1;179;0
WireConnection;195;0;188;3
WireConnection;195;1;191;0
WireConnection;192;0;187;3
WireConnection;192;1;186;0
WireConnection;141;0;150;0
WireConnection;141;1;130;0
WireConnection;194;0;191;0
WireConnection;194;1;189;0
WireConnection;133;0;139;1
WireConnection;133;1;150;0
WireConnection;193;0;186;0
WireConnection;193;1;190;0
WireConnection;246;0;237;0
WireConnection;246;1;238;0
WireConnection;244;0;234;0
WireConnection;244;2;239;0
WireConnection;242;0;236;0
WireConnection;260;0;252;0
WireConnection;260;1;253;0
WireConnection;250;0;242;0
WireConnection;136;0;133;0
WireConnection;136;1;141;0
WireConnection;197;0;192;0
WireConnection;197;1;193;0
WireConnection;147;0;146;0
WireConnection;147;1;145;0
WireConnection;196;0;195;0
WireConnection;196;1;194;0
WireConnection;251;0;246;0
WireConnection;254;1;244;0
WireConnection;261;0;260;0
WireConnection;257;0;256;0
WireConnection;257;1;251;0
WireConnection;257;2;250;0
WireConnection;200;0;197;0
WireConnection;259;0;254;1
WireConnection;259;1;255;0
WireConnection;259;2;247;0
WireConnection;148;0;147;0
WireConnection;201;0;196;0
WireConnection;138;0;136;0
WireConnection;264;0;257;0
WireConnection;262;0;259;0
WireConnection;182;0;138;0
WireConnection;182;1;148;0
WireConnection;182;2;201;0
WireConnection;182;3;200;0
WireConnection;182;4;278;0
WireConnection;198;0;196;0
WireConnection;199;0;197;0
WireConnection;181;0;182;0
WireConnection;183;0;136;0
WireConnection;180;0;147;0
WireConnection;258;0;249;0
WireConnection;258;1;248;0
WireConnection;248;0;243;0
WireConnection;248;1;245;0
WireConnection;248;2;241;0
WireConnection;243;0;235;0
WireConnection;243;1;233;0
WireConnection;229;0;223;0
WireConnection;233;0;229;0
WireConnection;263;0;258;0
WireConnection;0;2;277;0
WireConnection;0;9;181;0
WireConnection;0;11;279;0
ASEEND*/
//CHKSM=823FEA328EB9A7FC2777301064E1BBBCE652C675