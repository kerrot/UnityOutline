Shader "Custom/Depth" {
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D _CameraDepthTexture;

            half4 frag(v2f_img o) : COLOR
            {
            	half2 uv = { o.uv.x, 1 - o.uv.y};

            	if (tex2D(_CameraDepthTexture, uv).r > 0)
            	{
            		return (1, 1, 1, 1);
            	}
            	else
            	{
            		return (0, 0, 0, 0);
            	}
            }

            ENDCG
        }
    }
}