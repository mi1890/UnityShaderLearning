Shader "testShader/vol3- Specular "{
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
				float4 col:COLOR;
			};
			
			
			vertexOutput vert (vertexInput i)
			{
				vertexOutput o;
				float3 normalDirection  = normalize(mul(float4(i.normal,0.0),_World2Object).xyz);
				float3 LightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 viewDirection = normalize(float3((float4(_WorldSpaceCameraPos.xyz,1.0) - mul(_Object2World,i.vertex)).xyz));
				float atten = 1.0;
				
				
				float3 diffectRle = atten*_LightColor0.xyz*max(0.0,dot(normalDirection,LightDirection))*_Color;
				float3 specRle = atten*_LightColor0.xyz*_SpecColor.xyz*pow((max(0.0,dot(reflect(-LightDirection,normalDirection),viewDirection))),_Shininess)*max(0.0,dot(normalDirection,LightDirection));
				o.col = float4(specRle+diffectRle + UNITY_LIGHTMODEL_AMBIENT,1.0);
				o.pos = mul(UNITY_MATRIX_MVP,i.vertex);
				
				return o;
			}
			
			float4 frag(vertexOutput o):COLOR{
				
				
				return o.col;
			
			}
			
		
			ENDCG
		}
	}

}