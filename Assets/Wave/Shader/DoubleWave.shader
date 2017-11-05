Shader "Unlit/DoubleWave"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color", Color) = (0, 0, 0, 1)
		_Radius("Radius", Range(0, 0.5)) = 0.4
		_RadiusMax("RadiusMax", Range(0, 0.5)) = 0.25
		_HalfWidth("HalfWidth", Range(0.05, 0.25)) = 0.1
		_TimeValue("TimeValue", Range(0, 1)) = 0
		_Scale("Scale", Range(0, 1)) = 1
			_SpeedScale("_SpeedScale", Float) = 1
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" }
		LOD 100

		Pass
		{
			Blend One One
			ZWrite Off
			ZTest Off
			
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
			fixed4 _Color;
			float _Radius;
			float _RadiusMax;
			float _Scale;
			float _HalfWidth;
			float _TimeValue;
			float _SpeedScale;
			float _OffsetH;
			float3 _SpeedDir;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				_Radius = min(_Radius, _RadiusMax);

				float2 center = float2(0.5, 0.5);
				float dist = distance(center, i.uv);
				float height =  1 - min(1, abs(dist - _Radius) / _HalfWidth);
				height = max(0, height - _TimeValue);

				float2 currentDir = i.uv - center;
				float dirScale = dot(currentDir, float2(0, 1)) / max(0.01, dist);
				dirScale = max(0, dirScale + 0);

				float finalScale = 1;
				finalScale *= height;
				//finalScale *= _SpeedScale;
				//finalScale *= dirScale;
				finalScale *= _Scale;

				return _Color * finalScale;
			}
			ENDCG
		}
	}
}
