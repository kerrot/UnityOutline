Shader "Custom/Depth" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _CameraDepthTexture;
            sampler2D _MainTex;
            sampler2D _OutlineTexture;

            int _OutlineWidth;

            float4 frag(v2f_img input) : COLOR
            {
				float2 uv = { input.uv.x, 1 - input.uv.y };
				float2 pixelStep = _ScreenParams.zw - float2(1, 1);

				float maxDepth = 0;
				float2 maxIndex = float2(0, 0);

				//[unroll(400)]
				//for (int index = 0; index <= 4 * _OutlineWidth * _OutlineWidth; index++)
				//{
				//	int u = index;
				//	int v = index;
				//	float2 tmp = uv + float2(pixelStep.x * u, pixelStep.y * v);
				//	if (tmp.x < 0 || tmp.x > 1 || tmp.y < 0 || tmp.y > 1)
				//	{
				//		continue;
				//	}

				//	float tmpDepth = tex2D(_CameraDepthTexture, tmp).r;
				//	if (tmpDepth > maxDepth)
				//	{
				//		maxDepth = tmpDepth;
				//		maxIndex = tmp;
				//	}
				//}

				const int unit = _OutlineWidth + 1 + _OutlineWidth;
				const int maxLoop = unit * unit;
				[unroll(462)] for (int i = 0; i <= maxLoop; i++)
				{
				    int u = i / unit - _OutlineWidth;
				    int v = i % unit - _OutlineWidth;
				    float2 tmp = uv + float2(pixelStep.x * u, pixelStep.y * v);

				    float tmpDepth = tex2D(_CameraDepthTexture, tmp).r;
				}

				float selfDepth = tex2D(_CameraDepthTexture, uv).r;
				if (maxDepth == selfDepth)
				{
					return tex2D(_MainTex, input.uv);
				}
				else if (maxDepth > selfDepth)
				{
					float4 outlineColor = tex2D(_OutlineTexture, maxIndex);
					if (outlineColor.a > 0)
					{
						return outlineColor;
					}
					else
					{
						return tex2D(_MainTex, input.uv);
					}
				}

				return float4(0, 0, 0, 0);
            }

            ENDCG
        }
    }
}