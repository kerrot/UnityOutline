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

            float4 frag(v2f_img o) : COLOR
            {
				float2 uv = { o.uv.x, 1 - o.uv.y };
				float2 pixelStep = _ScreenParams.zw - float2(1, 1);

				for (int u = -_OutlineWidth; u <= _OutlineWidth; ++u)
				{
					for (int v = -_OutlineWidth; v <= _OutlineWidth; ++v)
					{
						float2 tmp = uv + float2(pixelStep.x * u, pixelStep.y * v);
					}
				}


            	if (tex2D(_CameraDepthTexture, uv).r > 0)
            	{
            		return half4(1, 1, 1, 1);
            	}
            	else
            	{
            		return half4(0, 0, 0, 0);
            	}
            }

            ENDCG
        }
    }
}