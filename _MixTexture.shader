Shader "CG/MixTexture"
{
	Properties
	{
		_Color("color" , Color) = (1.0,1.0,1.0,1.0)
		_Texture("texture",2D) =  "white"{}
		_Texture2("texture",2D) = "white"{}
		_Lerp("Lerp",Range(0,1)) = 0
	
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
				uniform sampler2D _Texture2;
				uniform float4 _Texture2_ST;
				uniform fixed _TwistPower;
				uniform fixed _Lerp;
				
				struct vertexOutput
				{
					float4 position:SV_POSITION;
					float2 uv:TEXCOORD0;
					float3 normalDir:TEXCOORD1;
				
				};
				
				vertexOutput vert(appdata_base v)
				{
					vertexOutput o;
					o.position = mul(UNITY_MATRIX_MVP,v.vertex);
					o.normalDir =normalize(float3(mul(float4(v.normal,0.0),_World2Object).xyz));
					o.uv = (v.texcoord).xy;
					
					
					return o;
				
				}
				

				
				float4 frag(vertexOutput o):COLOR
				{	
				
					//float4 texColor = tex2D(_Texture,_Texture_ST.xy*o.uv.xy  + _Texture_ST.zw);
					float4 texColor = tex2D(_Texture,o.uv*_Texture_ST.xy + _Texture_ST.zw);
					float4 tex2Color = tex2D(_Texture2,o.uv*_Texture_ST.xy + _Texture_ST.zw);
					return lerp(texColor,tex2Color,_Lerp);
		
				}
		
			ENDCG
		
		}
	
	
	
	
	}


}