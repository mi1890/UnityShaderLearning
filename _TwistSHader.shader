Shader "CG/Twist"
{
	Properties
	{
		_Color("color" , Color) = (1.0,1.0,1.0,1.0)
		_Texture("texture",2D) =  "white"{}
		_TwistPower("TwistPower",Range(-5,8)) = 0
	
	}
	
	SubShader{
		Pass{
			Tags{"LightMode" = "ForwardBase"}
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				
				uniform fixed _Color;
				uniform sampler2D _Texture;
				uniform float4 _Texture_ST;
				uniform fixed _TwistPower;
				
				struct vertexOutput
				{
					float4 position:SV_POSITION;
					float2 uv:TEXCOORD0;
					float3 normalDir:TEXCOORD1;
				
				};
				
				vertexOutput vert(appdata_base v)
				{
					vertexOutput o;
					float angle = _TwistPower*length(v.vertex);
					float cosLength,sinLength;
					sincos(angle,sinLength,cosLength);
					o.position = mul(UNITY_MATRIX_MVP,v.vertex);
					
					o.position.x = cosLength*o.position.x - sinLength*o.position.y;
					o.position.y = cosLength*o.position.y + sinLength*o.position.x;
					o.position.z = cosLength*o.position.z - sinLength*o.position.y;
					//o.position.w = (mul(UNITY_MATRIX_MVP,v.vertex)).w;
					o.normalDir =normalize(float3(mul(float4(v.normal,0.0),_World2Object).xyz));
					o.uv = (v.texcoord).xy;
					
					
					return o;
				
				}
				

				
				float4 frag(vertexOutput o):COLOR
				{	
				
					//float4 texColor = tex2D(_Texture,_Texture_ST.xy*o.uv.xy  + _Texture_ST.zw);
					float4 texColor = tex2D(_Texture,o.uv*_Texture_ST.xy + _Texture_ST.zw);
					return texColor;
		
				}
		
			ENDCG
		
		}
	
	
	
	
	}


}