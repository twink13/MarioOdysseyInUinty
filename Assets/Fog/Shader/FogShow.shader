Shader "Unlit/FogShow"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_HeightScale("Height Scale", Range(0, 5)) = 1
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float3 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 heights : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			half _HeightScale;

			inline float VertCalcH(sampler2D samp, float2 uv)
			{

				float v1 = sin(uv.x * 10 + uv.y * 3 + _Time.x * 10) * 0.5 + 1;
				v1 = v1 * 1;
				float v2 = sin(uv.x * 30 + uv.y * 10 + _Time.x * -30) * 0.5 + 1;
				v2 = v2 * 0.3;
				float v3 = sin(uv.x * 16 + uv.y * 8 + _Time.x * 20) * 0.5 + 1;
				v3 = v3 * 0.2;
				float v4 = sin(uv.x * 10 + uv.y * 20 + _Time.x * -10) * 0.5 + 1;
				v4 = v4 * 1.2;

				float h = 0;
				h = h + v1;
				h = h + v2;
				h = h + v3;
				h = h + v4;
				h = h / 4;

				fixed height = tex2Dlod(samp, float4(uv, 0, 0)).r;

				return min(h, height);
			}
			
			v2f vert (appdata v)
			{
				v2f o;

				float center = VertCalcH(_MainTex, v.uv);

				float texDistance = 1;
				float left = VertCalcH(_MainTex, v.uv + float2(-_MainTex_TexelSize.x * texDistance, 0));
				float right = VertCalcH(_MainTex, v.uv + float2(_MainTex_TexelSize.x * texDistance, 0));
				float up = VertCalcH(_MainTex, v.uv + float2(0, _MainTex_TexelSize.y * texDistance));
				float down = VertCalcH(_MainTex, v.uv + float2(0, -_MainTex_TexelSize.y * texDistance));

				o.uv.z = center;
				o.heights.x = left;
				o.heights.y = right;
				o.heights.z = up;
				o.heights.w = down;

				v.vertex.xyz = v.vertex.xyz + v.normal * center * _HeightScale;

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float texDistance = 1;

				fixed center = tex2D(_MainTex, i.uv);
				fixed left = i.heights.x;
				fixed right = i.heights.y;
				fixed up = i.heights.z;
				fixed down = i.heights.w;

				float3 centerPos = float3(0, center, 0);
				float3 leftPos = float3(-1, left, 0);
				float3 rightPos = float3(1, right, 0);
				float3 upPos = float3(0, up, 1);
				float3 downPos = float3(0, down, 1);

				float3 cross1 = cross(upPos - centerPos, leftPos - centerPos);
				float3 cross2 = cross(rightPos - centerPos, downPos - centerPos);
				float3 normal = normalize(cross1 + cross2);

				float3 average;
				average.x = down - up;
				average.z = left - right;
				average.y = 0;
				//float3 normal = normalize(average);

				fixed diff = dot(normal, _WorldSpaceLightPos0.xyz) * 0.5 + 0.5;

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv.xy);
				return diff;
			}
			ENDCG
		}
	}
}
