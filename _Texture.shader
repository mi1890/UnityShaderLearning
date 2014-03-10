Shader "testShader/vol6-Texture"{
	Properties{
		_Color ("MainColor",Color) = (1.0,1.0,1.0,1.0)
	 	_SpecColor("SpecColor",Color) = (1.0,1.0,1.0,1.0)
	 	_Shininess("Shininess",float) = 10.0
	 	_RimColor("RimColor",Color) = (1.0,1.0,1.0,1.0)
	 	_RimPower("RimPower",Range(0.1,10)) = 3
	 	_MainTex("MainTexture",2D) = "white"{}
	
	}
	SubShader{
		Pass{
			Tags {"LightMode" = "ForwardBase"}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			uniform float4 _RimColor;
			uniform float _RimPower;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			//accept unity variable
			uniform float4 _LightColor0;
			
			struct vertexInput
			{
				float4 texcoord:TEXCOORD0;
				float3 normal:NORMAL;
				float4 vertex:POSITION;
			
			};
			
			
			struct vertexOutput
			{
				float4 pos:SV_POSITION;
				float4 tex:TEXCOORD0;
				float4 posWorld:TEXCOORD1;
				float3 norDir:TEXCOORD2;
				
			};
			
			
			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				o.pos = mul(UNITY_MATRIX_MVP,i.vertex);
				o.posWorld = mul(_Object2World,i.vertex);
				o.norDir = normalize(float3(mul(float4(i.normal,0.0),_World2Object).xyz));
				o.tex = i.texcoord;
				return o;
			}
			
			
			float4 frag(vertexOutput o):COLOR
			{
				float3 normalDirection = o.norDir;
				float3 viewDirection = normalize(float3(_WorldSpaceCameraPos.xyz - o.posWorld .xyz));
				float3 lightDirection;
				float atten;
				
				
				

				if(_WorldSpaceLightPos0.w == 0)
				
				{
					atten = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				
				}else
				{
					float3 vertexToSource = float3( _WorldSpaceLightPos0.xyz - o.posWorld.xyz);
					float distance = length(vertexToSource);
					atten = 1/distance;
					lightDirection = normalize(vertexToSource);
				
				}
				
				float3 diffuceReflection  = atten*float3(_LightColor0.xyz)*saturate(dot(lightDirection,normalDirection));
				float3 specReflection = atten*float3(_SpecColor.xyz)*diffuceReflection*pow(saturate(dot((reflect(-lightDirection,normalDirection)),viewDirection)),_Shininess);
				
				//float3 specularReflection = diffuseReflection * _SpecColor.xyz * pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)) , _Shininess);
				
			
				
				
				float rim = 1 - saturate(dot(normalize(viewDirection),normalDirection));
				float3 rimLight = saturate(dot(lightDirection,normalDirection))*_RimColor.xyz*pow(rim,_RimPower);
				
				float3 finalColor =  diffuceReflection + specReflection + rimLight+ UNITY_LIGHTMODEL_AMBIENT.xyz ;
				
				float4 tex = tex2D(_MainTex,_MainTex_ST.xy*o.tex.xy  + _MainTex_ST.zw*0.2);
				
				return float4(finalColor*tex.xyz*_Color,1.0)  ;
			}
			
			ENDCG
		
		
		}
	
	
	}



}