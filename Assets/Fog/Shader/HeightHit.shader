Shader "Unlit/HeightHit"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Speed("Speed", Range(-1, 5)) = 1
		_Size("Size", Range(0, 1)) = 0.1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half _Speed;
			half _Size;
			float2 _HitPos;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float dist = distance(i.uv, _HitPos) / _Size;
				dist = saturate(1 - dist * dist);
				return col - dist * _Speed * 0.1;
			}
			ENDCG
		}
	}
}
