// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Kingsoft/Scene/InterlacePatternAdditive" {
	Properties {
        _MainTex ("Base", 2D) = "white" {}
        _TintColor ("TintColor", Color) = (1,1,1,1) // needed simply for shader replacement   
        _InterlacePattern ("InterlacePattern", 2D) = "white" {}
        _Illum ("_Illum", 2D) = "white" {}
		_EmissionLM ("Emission (Lightmapper)", Float) = 1.0	
	}
	
	CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		sampler2D _InterlacePattern;
						
		half4 _InterlacePattern_ST;
		fixed4 _TintColor;				
						
		struct v2f {
			half4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			half2 uv2 : TEXCOORD1;
			UNITY_FOG_COORDS(2)
		};

		v2f vert(appdata_full v)
		{
			v2f o;
			
			o.pos = UnityObjectToClipPos (v.vertex);	
			o.uv.xy = v.texcoord.xy;
			o.uv2.xy = TRANSFORM_TEX(v.texcoord.xy, _InterlacePattern) + _Time.xx * _InterlacePattern_ST.zw;
			UNITY_TRANSFER_FOG(o, o.pos);
			return o; 
		}
		
		fixed4 frag( v2f i ) : COLOR
		{	
			fixed4 colorTex = tex2D (_MainTex, i.uv);
			fixed4 interlace = tex2D (_InterlacePattern, i.uv2);
			colorTex *= interlace;

			UNITY_APPLY_FOG_COLOR(i.fogCoord, colorTex, fixed4(0, 0, 0, 0)); // fog towards black due to our blend mode
			return colorTex;
		}
	
	ENDCG
	
	SubShader {
    	Tags {"RenderType" = "Transparent" "Queue" = "Transparent" "Reflection" = "RenderReflectionTransparentAdd" }
		Cull Off
		ZWrite Off
       	Blend One One
		
	Pass {
	
		CGPROGRAM
		
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest 
		#pragma multi_compile_fog
		ENDCG
		 
		}
				
	} 
	FallBack Off
}
