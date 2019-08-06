Shader "Custom/NoisyVertexTransfer"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_TransferVector("Transfer Vector", Vector) = (0,0,0,0)
		_TransferThreshould("Transfer Threshould", float) = 1
		_Emission("Emmisive Color", Color) = (0,0,0,0)
		_EmissionThreshould("Emission Threshould", float) = 1
		_Seed("Seed", Int) = 0
		_Size("Size", Int) = 1
		
	}

		SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TransferVector;
			float _TransferThreshould;
			fixed4 _Emission;
			float _EmissionThreshould;

			int _Seed;
			int _Size;
			
			float rand(float2 st, int seed)
			{
				return frac(sin(dot(st.xy, float2(12.9898, 78.233)) + seed) * 43758.5453123);
			}
 
			float noise(float2 st, int seed)
			{
				float2 ip = floor(st);
				float2 f = frac(st);
 
				float a = rand(ip, seed);
				float b = rand(ip + float2(1, 0), seed);
				float c = rand(ip + float2(0, 1), seed);
				float d = rand(ip + float2(1, 1), seed);
 
				float2 t = f * f * (3 - 2 * f);
 
				return lerp(a, b, t.x) + (c - a) * t.y * (1 - t.x) + (d - b) * t.x * t.y;
				//return lerp(lerp(a, b, t.x), lerp(c, d, t.x), t.y);
			}
			

			v2f vert(appdata v)
			{
				v2f o;
				//o.vertex *= (_TransferVector * _TransferThreshould);
				// if (v.vertex.x > _TransferThreshould || v.vertex.y > _TransferThreshould || v.vertex.z > _TransferThreshould)
				// {
				// 	v.vertex.x +=  _TransferVector.x * noise(v.uv * _Size * _SinTime.x, _Seed);
				// 	v.vertex.y +=  _TransferVector.y * noise(v.uv * _Size * _SinTime.x, _Seed);
				// 	v.vertex.z +=  _TransferVector.z * noise(v.uv * _Size * _SinTime.x, _Seed);
				// }
				v.vertex.x +=  _TransferVector.x * noise(v.uv * _Size * _SinTime.x, _Seed);
				v.vertex.y +=  _TransferVector.y * noise(v.uv * _Size * _SinTime.x, _Seed);
				v.vertex.z +=  _TransferVector.z * noise(v.uv * _Size * _SinTime.x, _Seed);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// fixed4 color = fixed4(i.uv.y, 0, i.uv.x, 1);
				fixed4 color = tex2D(_MainTex, i.uv);
				return color * _Emission * _EmissionThreshould;
			}

			ENDCG
		}
	}
	
}
