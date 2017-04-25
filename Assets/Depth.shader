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

            half4 _OutlineWidth;

            half4 frag(v2f_img o) : COLOR
            {
            	half2 uv = { o.uv.x, 1 - o.uv.y};

            	if (tex2D(_CameraDepthTexture, uv).r > 0)
            	{
            		return half4(1, 1, 1, 1);
            	}
            	else
            	{
            		return half4(0, 0, 0, 0);
            	}

            	return tex2D(_OutlineTexture, uv);
            }

            ENDCG
        }
    }
}