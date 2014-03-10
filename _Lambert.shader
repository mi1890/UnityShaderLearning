Shader "testShader/vol2-Lambert"{
	Properties{
		_Color("MainColor",Color)  = (1.0,1.0,1.0,1.0)
		
	
	}
	
	
	SubShader{
		Pass{
			tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			//pragma
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			//varieble
			
			
			//unity defined variables,has exist
			float4 _Color;
			float4 _LightColor0;
			//float4x4 _Object2World;
			//float4x4 _World2Object;
			//float4 _WorldSpaceLightPos0;
			
			
			//struct
			
			struct vertexInput{
				float4	 vertex :POSITION;
				float3 normal:NORMAL;
			
			
			};
			
			struct vertexOutput{
				float4 pos:SV_POSITION;
				float4 col:COLOR;
			};
			
			
			
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				
				float3 normalDirection  = normalize  (mul(float4(v.normal,0.0),_World2Object).xyz);
				
				float3 lightDirection = normalize(_WorldSpaceLightPos0).xyz;
				
				float atten = 1.0;
				
				float3 diffuceReflection = _LightColor0.xyz*_Color.rgb*atten*max(0.0,atten*dot(lightDirection,normalDirection));
				
				o.col = float4(diffuceReflection,1.0);
				
				return o;
			}
			
			float4 frag(vertexOutput o):Color
			{
				 
			
				return o.col;
			}
			
			//
		
		
			ENDCG
			}
		
	
	
	}



}