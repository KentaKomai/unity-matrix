Shader "Custom/Matrix"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_LineWidht ("Line Widht", float) = 1.0
		_LineColor ("Line Color", Color) = (1,1,1,1)
		_GridColor ("Grid Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags {
			"RenderType"="Transparent"
			"IgnoreProjector"="True"
			"Queue" = "Transparent"
		}
		//Blend SrcAlpha OneMinusSrcAlpha
		Blend SrcAlpha One
		//AlphaTest Greater 0.5
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _LineWidth;
			float4 _LineColor;
			float4 _GridColor;
			
			v2f vert (appdata v)
			{
				float4 vx = v.vertex;
				float angle = _Time.y % 360;
				float cosVal = cos(angle);
				float sinVal = sin(angle);
				/* 
				// Basic Matrix
				float4x4 m = {
					1.0, 0.0, 0.0, 0.0,
					0.0, 1.0, 0.0, 0.0,
					0.0, 0.0, 1.0, 0.0,
					0.0, 0.0, 0.0, 1.0
				};
				*/
				float4x4 xRotate = {
					1.0, 0.0    , 0.0   , 0.0,
					0.0, cosVal , sinVal, 0.0,
					0.0, -sinVal, cosVal, 0.0,
					0.0, 0.0    , 0.0   , 1.0
				};
				float4x4 yRotate = {
					cosVal, 0.0, -sinVal, 0.0,
					0.0   , 1.0, 0.0    , 0.0,
					sinVal, 0.0, cosVal , 0.0,
					0.0   , 0.0, 0.0    , 1.0
				};
				float4x4 zRotate = {
					cosVal , sinVal, 0.0, 0.0,
					-sinVal, cosVal, 0.0, 0.0,
					0.0    , 0.0   , 1.0, 0.0,
					0.0    , 0.0   , 0.0, 1.0
				};
				float4x4 parallelShift = {
					1.0, 0.0, 0.0, 1.0,
					0.0, 1.0, 0.0, 1.0,
					0.0, 0.0, 1.0, 1.0,
					0.0, 0.0, 0.0, 1.0
				};
				float scale = 2 + _Time.z % 5;
				float4x4 scaleMatrix = {
					scale, 0.0  , 0.0  , 0.0,
					0.0  , scale, 0.0  , 0.0,
					0.0  , 0.0  , scale, 0.0,
					0.0  , 0.0  , 0.0  , 1.0
				};
				
				// scale -> rotate -> parallelshift
				vx = mul(scaleMatrix, vx);
				vx = mul(xRotate, vx);
				vx = mul(yRotate, vx);
				vx = mul(zRotate, vx);
				//vx = mul(parallelShift, vx);

				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, vx);

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				/*
				fixed4 answer;
     
				float lx = step(_LineWidth, i.uv.x);
				float ly = step(_LineWidth, i.uv.y);
				float hx = step(i.uv.x, 1 - _LineWidth);
				float hy = step(i.uv.y, 1 - _LineWidth);
     
				answer = lerp(_LineColor, _GridColor, lx*ly*hx*hy);
     
				return answer;
				*/
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return _LineColor;
			}
			ENDCG
		}
	}
}
