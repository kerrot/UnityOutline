Shader "Custom/Outline_AvgNormal" {
	Properties{
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
		_Outline("Outline width", Float) = .005
	}
	
	SubShader
	{
		Cull Front

		Pass{
			CGPROGRAM
			#include "UnityCG.cginc"			
			#pragma vertex vert
			#pragma fragment frag

			float4 _OutlineColor;
			float _Outline;

			struct Input
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct Output
			{
				float4 pos : SV_POSITION;
				fixed4 color : TEXCOORD0;
			};

			Output vert(Input i)
			{
				Output o;

				i.vertex.xyz += normalize(i.normal) * _Outline;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.color = _OutlineColor;
				return o;
			}

			fixed4 frag(Output o) : SV_Target
			{
				return o.color;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
