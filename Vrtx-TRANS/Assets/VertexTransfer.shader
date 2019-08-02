Shader "Custom/VertexTransfer"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_TransferVector("Transfer Vector", Vector) = (0,0,0,0)
		_TransferThreshould("Transfer Threshould", float) = 1
		_Emission ("Emmisive Color", Color) = (0,0,0,0)
		_EmissionThreshould("Emission Threshould", float) = 1
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
			

			v2f vert(appdata v)
			{
				v2f o;
				//o.vertex *= (_TransferVector * _TransferThreshould);
				if (v.vertex.x > _TransferThreshould -1 || v.vertex.y > _TransferThreshould -1 || v.vertex.z > _TransferThreshould -1)
				{
					v.vertex.x +=  _TransferVector.x * 10;
					v.vertex.y +=  _TransferVector.y * 10;
					v.vertex.z +=  _TransferVector.z * 10;
				}

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
