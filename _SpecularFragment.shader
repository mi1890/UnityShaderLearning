Shader "testShader/vol3- SpecularFragment "{
	Properties {
		_Color("MainColor",Color) = (1.0,1.0,1.0,1.0)
		_SpecColor("SpeColor",Color) = (1.0,1.0,1.0,1.0)
		_Shininess("Shiness",Float) = 10.0
		
	}
	SubShader{
		Tags{"LightMode" = "ForwardBase"}
			Pass{	
			CGPROGRAM	
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			//accept variable
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			
			//define variable
			uniform float4 _LightColor0;
			
			//struct
			
			struct vertexInput
			{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			
			struct vertexOutput
			{
				float4 pos:SV_POSITION;
				float4 posWorld:TEXCOORD0;
				float3 normalDir:TEXCOORD1;
			};
			
			
			vertexOutput vert (vertexInput i)
			{
				vertexOutput o;
				
				o.posWorld= mul(_Object2World,i.vertex);
				
				o.normalDir = normalize(mul(float4(i.normal,0.0),_World2Object).xyz);
				
				o.pos = mul(UNITY_MATRIX_MVP,i.vertex);
				
				return o;
			}
			
			float4 frag(vertexOutput o):COLOR{
				 
				
				float3 normalDirection  = o.normalDir;
				float3 LightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - o.posWorld).xyz;
				float atten = 1.0;
				
				
				float3 diffectRle = atten*_LightColor0.xyz*max(0.0,dot(normalDirection,LightDirection))*_Color;
				float3 specRle = atten*_SpecColor.xyz*pow((max(0.0,dot(reflect(-LightDirection,normalDirection),viewDirection))),_Shininess)*max(0.0,dot(normalDirection,LightDirection));
				float3 finalCol = specRle+diffectRle + UNITY_LIGHTMODEL_AMBIENT;
				
				
				return float4(finalCol*_Color.rgb,1.0);
			}
			
		
			ENDCG
		}
	}

}