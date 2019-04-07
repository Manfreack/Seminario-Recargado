// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShader/WaterShader"
{
	Properties
	{
		_WaterNormal("WaterNormal", 2D) = "bump" {}
		_ColourDeep("Colour(Deep)", Color) = (0.1176513,0.0778302,0.3113208,0)
		[Header(Refraction)]
		_ColourShadow("Colour(Shadow)", Color) = (0.2874689,0.7103403,0.7169812,0)
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_Speed("Speed", Range( 0 , 0.1)) = 0
		_Scale("Scale", Range( 0 , 2)) = 0
		_Profundidad("Profundidad", Float) = 0
		_WaterFallof("WaterFallof", Float) = 0
		_Distorcion("Distorcion", Float) = 0.7
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
			INTERNAL_DATA
			float3 worldNormal;
		};

		uniform float _Speed;
		uniform float _Scale;
		uniform sampler2D _WaterNormal;
		uniform sampler2D _GrabTexture;
		uniform float _Distorcion;
		uniform float4 _ColourDeep;
		uniform float4 _ColourShadow;
		uniform float _Profundidad;
		uniform sampler2D _CameraDepthTexture;
		uniform float _WaterFallof;
		uniform float _ChromaticAberration;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( ( ( ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) ) * ( 1.0 / ( screenPos.z + 1.0 ) ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) ) );
			float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout fixed4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			color.rgb = color.rgb + Refraction( i, o, 1.0, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 temp_cast_0 = (_Speed).xx;
			float2 panner15 = ( 1.0 * _Time.y * temp_cast_0 + i.uv_texcoord);
			float2 panner16 = ( 1.0 * _Time.y * float2( 0,0 ) + i.uv_texcoord);
			float3 _NormalMap41 = BlendNormals( UnpackNormal( tex2D( _WaterNormal, panner15 ) ) , UnpackScaleNormal( tex2D( _WaterNormal, panner16 ) ,_Scale ) );
			o.Normal = _NormalMap41;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 appendResult30 = (float4(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g , 0.0 , 0.0));
			float4 screenColor29 = tex2D( _GrabTexture, ( ( appendResult30 / ase_grabScreenPosNorm.a ) + float4( ( _Distorcion * _NormalMap41 ) , 0.0 ) ).xy );
			float4 _GrabPos46 = screenColor29;
			float eyeDepth2 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float _ScreenPosition53 = saturate( pow( ( _Profundidad + abs( ( eyeDepth2 - ase_screenPos.w ) ) ) , _WaterFallof ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNDotV48 = dot( WorldNormalVector( i , _NormalMap41 ), ase_worldViewDir );
			float fresnelNode48 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNDotV48, 5.0 ) );
			float lerpResult54 = lerp( _ScreenPosition53 , 0.0 , fresnelNode48);
			float4 lerpResult12 = lerp( _ColourDeep , _ColourShadow , lerpResult54);
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth68 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float distanceDepth68 = abs( ( screenDepth68 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 0.0 ) );
			float4 lerpResult35 = lerp( _GrabPos46 , lerpResult12 , saturate( distanceDepth68 ));
			float4 _Colour43 = lerpResult35;
			o.Albedo = _Colour43.rgb;
			o.Occlusion = 0.5790219;
			o.Alpha = 0.6744302;
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
949;73;480;663;-232.1632;709.1519;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;56;-3933.427,358.6053;Float;False;2039.57;626.5852;Screen Position;8;1;2;3;5;24;23;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1;-3883.427,581.6193;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;22;-2666.279,-1681.533;Float;False;1649.039;939.2627;Normal;10;14;19;16;15;20;17;18;21;41;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenDepthNode;2;-3655.816,408.6053;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2567.177,-1631.533;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0;0.04183967;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2616.279,-1382.802;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-3360.38,600.3324;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;15;-2159.563,-1547.254;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;16;-2149.606,-1274.794;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2147.969,-1000.27;Float;False;Property;_Scale;Scale;5;0;Create;True;0;0;False;0;0;1.27;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;5;-3151.517,707.7979;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3211.261,536.2709;Float;False;Property;_Profundidad;Profundidad;6;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-1824.094,-1332.336;Float;True;Property;_WaterNormal;WaterNormal;0;0;Create;True;0;0;False;0;None;26aa78dc95728404a874f9caa6072117;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1827.717,-1571.715;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;None;26aa78dc95728404a874f9caa6072117;True;0;True;bump;Auto;True;Instance;17;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;21;-1311.24,-1466.211;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2967.693,613.2292;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2849.396,727.1907;Float;True;Property;_WaterFallof;WaterFallof;7;0;Create;True;0;0;False;0;0;1.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;25;-2648.922,615.9883;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;50;-1078.579,-1394.691;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;51;-2042.048,-603.454;Float;False;1281.203;893.5731;Colour;18;11;8;37;38;48;47;12;35;54;57;58;55;53;27;67;68;70;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GrabScreenPosition;28;-1097.435,-2107.347;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-1232.559,-1227.805;Float;False;_NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2239.836,21.82076;Float;True;41;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;27;-1994.497,118.6444;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-2034.205,247.726;Float;False;53;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1815.477,115.9486;Float;False;_ScreenPosition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;48;-1962.439,28.49087;Float;False;Tangent;4;0;FLOAT3;0,0,1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-839.5435,-1729.037;Float;False;Property;_Distorcion;Distorcion;8;0;Create;True;0;0;False;0;0.7;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-761.7166,-1997.902;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-840.2143,-1610.271;Float;False;41;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1596.93,65.87305;Float;False;Constant;_DepthDistance;Depth Distance ;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-1698.997,152.719;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-599.5732,-1707.737;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-562.1176,-1872.598;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;58;-1195.256,48.08604;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;68;-1343.89,-43.48373;Float;False;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-298.1473,-1659.049;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;8;-1941.584,-253.8359;Float;False;Property;_ColourShadow;Colour(Shadow);3;0;Create;True;0;0;False;0;0.2874689,0.7103403,0.7169812,0;0.042,0.03137255,0.846,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;11;-1944.982,-465.2488;Float;False;Property;_ColourDeep;Colour(Deep);1;0;Create;True;0;0;False;0;0.1176513,0.0778302,0.3113208,0;0.1824847,0.1638928,0.2735849,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;38;-1588.033,-135.4413;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;69;-1082.054,-111.3911;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;37;-1556.033,-371.4412;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;29;-140.2662,-1621.358;Float;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;57;-1517.83,-37.30119;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-1406.814,-553.4539;Float;False;46;0;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;12;-1448.133,-261.4749;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;70;-994.7823,-240.95;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;85.08905,-1530.643;Float;False;_GrabPos;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;35;-903.8412,-433.5152;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-608.0966,-401.1681;Float;False;_Colour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;187.1645,-417.3029;Float;False;Constant;_AmbientOcclusion;Ambient Occlusion;6;0;Create;True;0;0;False;0;0.5790219;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;245.9214,-214.9155;Float;False;Constant;_Transparency;Transparency;8;0;Create;True;0;0;False;0;0.6744302;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;303.5639,-481.0217;Float;False;41;0;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;316.4881,-565.5254;Float;False;43;0;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;244.1631,-326.1519;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;595.3766,-561.1597;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MyShader/WaterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;2;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;3;1;1;4
WireConnection;15;0;14;0
WireConnection;15;2;19;0
WireConnection;16;0;14;0
WireConnection;5;0;3;0
WireConnection;17;1;16;0
WireConnection;17;5;20;0
WireConnection;18;1;15;0
WireConnection;21;0;18;0
WireConnection;21;1;17;0
WireConnection;23;0;24;0
WireConnection;23;1;5;0
WireConnection;25;0;23;0
WireConnection;25;1;26;0
WireConnection;50;0;21;0
WireConnection;41;0;50;0
WireConnection;27;0;25;0
WireConnection;53;0;27;0
WireConnection;48;0;49;0
WireConnection;30;0;28;1
WireConnection;30;1;28;2
WireConnection;54;0;55;0
WireConnection;54;2;48;0
WireConnection;32;0;33;0
WireConnection;32;1;45;0
WireConnection;31;0;30;0
WireConnection;31;1;28;4
WireConnection;58;0;54;0
WireConnection;68;0;67;0
WireConnection;34;0;31;0
WireConnection;34;1;32;0
WireConnection;38;0;8;0
WireConnection;69;0;68;0
WireConnection;37;0;11;0
WireConnection;29;0;34;0
WireConnection;57;0;58;0
WireConnection;12;0;37;0
WireConnection;12;1;38;0
WireConnection;12;2;57;0
WireConnection;70;0;69;0
WireConnection;46;0;29;0
WireConnection;35;0;47;0
WireConnection;35;1;12;0
WireConnection;35;2;70;0
WireConnection;43;0;35;0
WireConnection;0;0;44;0
WireConnection;0;1;42;0
WireConnection;0;5;36;0
WireConnection;0;8;71;0
WireConnection;0;9;60;0
ASEEND*/
//CHKSM=BB69EEB226E008FF11BD1D1AF1D3F6781FBEF4D4