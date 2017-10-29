Shader "Unlit/SimpleColor"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (0, 0, 0, 1)
		_CutScale ("CutScale", Range(1, 10)) = 1
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
				float4 scrrenPos : TEXCOORD1;
			};

			// 原本的颜色 此处为固定颜色红色
			fixed4 _Color;
			// 遮蔽等级 从1到10逐级减少显示比例
			half _CutScale;
			
			// 顶点着色器
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				// 计算顶点的屏幕uv
				o.scrrenPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			// 片元着色器
			fixed4 frag (v2f i) : SV_Target
			{
				// 获得像素的屏幕uv
				float2 screenUV = i.scrrenPos.xy / i.scrrenPos.w;
				// 计算屏幕坐标
				float2 screenXY = screenUV * _ScreenParams.xy;
				// 取整
				half2 floorXY = floor(screenXY);
				// 通过参数按比例取余
				half2 displayValue = floorXY % floor(_CutScale);
				// 如果余数足够大就舍弃像素
				if ((displayValue.x + displayValue.y) > 1)
				{
					discard;
				}
				// 否则正常显示
				return _Color;
			}
			ENDCG
		}
	}
}
