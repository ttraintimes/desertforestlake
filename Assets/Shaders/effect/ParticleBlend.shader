﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

///////////////////////////////////////////
// author     : chen yong
// create time: 2015/11/05
// modify time: 
// description: 
///////////////////////////////////////////

// Simplified Blend Particle shader. Differences from regular Blend Particle one:
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "Kingsoft/Mobile/Particles/Alpha Blended" 
{
	Properties {
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0)
		_MainTex ("Particle Texture", 2D) = "white" {}
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off Lighting Off ZWrite Off
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_particles
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _TintColor;
			
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};
			
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o = (v2f)0;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}
			

			fixed4 frag (v2f i) : COLOR
			{				
				fixed4 col = 2.0f * _TintColor * i.color * tex2D(_MainTex, i.texcoord);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG 
		}
	}
}
