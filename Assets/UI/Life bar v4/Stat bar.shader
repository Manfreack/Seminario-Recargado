// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Stat bar"
{
	Properties
	{
		_Splatmap("Splatmap", 2D) = "white" {}
		_BarColor("Bar Color", Color) = (1,0,0,0)
		_Noise("Noise", 2D) = "white" {}
		_NoiseAmount("Noise Amount", Range( 0 , 1)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_HorizontalMovement("Horizontal Movement", Range( 0 , 1)) = 0
		_VerticalMinMovement("Vertical Min Movement", Range( 0 , 1)) = 0
		_VerticalMaxMovement("Vertical Max Movement", Range( 0 , 1)) = 0
		_MovementTimeScale("Movement Time Scale", Float) = 0
		_HealthStamina("Health-Stamina", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		BlendOp Max
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform sampler2D _Noise;
			uniform float _MovementTimeScale;
			uniform float _HorizontalMovement;
			uniform float _VerticalMaxMovement;
			uniform float _VerticalMinMovement;
			uniform sampler2D _Texture0;
			uniform float _NoiseAmount;
			uniform float4 _BarColor;
			uniform sampler2D _Splatmap;
			uniform float4 _Splatmap_ST;
			uniform float _HealthStamina;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				float3 vertexValue =  float3(0,0,0) ;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float mulTime24_g1 = _Time.y * _MovementTimeScale;
				float2 appendResult13_g1 = (float2(_HorizontalMovement , (_VerticalMaxMovement + (_SinTime.w - -1.0) * (_VerticalMinMovement - _VerticalMaxMovement) / (1.0 - -1.0))));
				float2 uv010_g1 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 lerpResult12_g1 = lerp( float4( uv010_g1, 0.0 , 0.0 ) , tex2D( _Texture0, uv010_g1 ) , 0.3);
				float2 panner21_g1 = ( mulTime24_g1 * appendResult13_g1 + lerpResult12_g1.rg);
				float4 lerpResult7 = lerp( float4( 1,1,1,0 ) , tex2D( _Noise, panner21_g1 ) , _NoiseAmount);
				float2 uv_Splatmap = i.ase_texcoord.xy * _Splatmap_ST.xy + _Splatmap_ST.zw;
				float4 tex2DNode1 = tex2D( _Splatmap, uv_Splatmap );
				float lerpResult19 = lerp( tex2DNode1.r , tex2DNode1.g , _HealthStamina);
				
				
				finalColor = ( lerpResult7 * ( _BarColor * lerpResult19 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16400
7;307;1025;704;2203.836;934.9697;2.803898;True;False
Node;AmplifyShaderEditor.Vector2Node;12;-912,-448;Float;False;Constant;_Tiling;Tiling;4;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1136,-368;Float;True;Property;_Texture0;Texture 0;4;0;Create;True;0;0;False;0;1207a4adcc48386458eb4425a0a3ecba;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1072,16;Float;False;Property;_MovementTimeScale;Movement Time Scale;8;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1104,-176;Float;False;Property;_HorizontalMovement;Horizontal Movement;5;0;Create;True;0;0;False;0;0;0.03;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-928,-304;Float;False;Constant;_UVDistortion;UV Distortion;5;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1104,-48;Float;False;Property;_VerticalMinMovement;Vertical Min Movement;6;0;Create;True;0;0;False;0;0;0.00048;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1104,-112;Float;False;Property;_VerticalMaxMovement;Vertical Max Movement;7;0;Create;True;0;0;False;0;0;0.00051;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-624,-16;Float;True;Property;_Splatmap;Splatmap;0;0;Create;True;0;0;False;0;2120ef337c09cb744a9fe4511a142b9a;2120ef337c09cb744a9fe4511a142b9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-624,176;Float;False;Property;_HealthStamina;Health-Stamina;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;10;-704,-384;Float;False;FogPanner;-1;;1;73ef78d5d665f3f4fb1758efb7d6df2d;0;7;29;FLOAT2;0,0;False;17;SAMPLER2D;0;False;16;FLOAT;0;False;20;FLOAT;0;False;18;FLOAT;0;False;19;FLOAT;0;False;26;FLOAT;0;False;1;FLOAT2;22
Node;AmplifyShaderEditor.SamplerNode;5;-352,-424;Float;True;Property;_Noise;Noise;2;0;Create;True;0;0;False;0;7921f8dc65bddfc4683992a67b3e2335;7921f8dc65bddfc4683992a67b3e2335;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-335,-176;Float;False;Property;_BarColor;Bar Color;1;0;Create;True;0;0;False;0;1,0,0,0;0.5808823,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;-304,128;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-336,-240;Float;False;Property;_NoiseAmount;Noise Amount;3;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;8.677002,-310.1946;Float;False;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-112,0;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;208,-16;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;416,-16;Float;False;True;2;Float;ASEMaterialInspector;0;1;MyShaders/Stat bar;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;5;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;10;29;12;0
WireConnection;10;17;13;0
WireConnection;10;16;14;0
WireConnection;10;20;15;0
WireConnection;10;18;16;0
WireConnection;10;19;17;0
WireConnection;10;26;18;0
WireConnection;5;1;10;22
WireConnection;19;0;1;1
WireConnection;19;1;1;2
WireConnection;19;2;23;0
WireConnection;7;1;5;0
WireConnection;7;2;8;0
WireConnection;3;0;4;0
WireConnection;3;1;19;0
WireConnection;6;0;7;0
WireConnection;6;1;3;0
WireConnection;0;0;6;0
ASEEND*/
//CHKSM=E14739336DC586808A31E67AD769A67C67AD2C16