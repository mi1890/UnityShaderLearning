Shader "testShader/vol4 - RimLight" {
	Properties {
		_Color("Color",Color) = (1.0,1.0,1.0,1.0)
		_SpecColor("SpecColor",Color) = (1.0,1.0,1.0,1.0)
		_Shininess("Shininess",float) = 10.0
		_RimColor("RimColor",Color) = (1.0,1.0,1.0,1.0)
		_RimPower("RimPower",Range(0.1,10.0)) = 5.0
	}
	SubShader {
		Pass{
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include"UnityCG.cginc"
			
			
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _Shininess;
			uniform float _RimPower;
			
			
			//translate the variable from unity to our CGRPOGRAM
			uniform float4 _LightColor0;
			
			
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
			
			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				o.normalDir = normalize(mul( float4(i.normal,0.0),_Object2World).xyz);
				o.posWorld = mul(_Object2World,i.vertex);
				o.pos = mul(UNITY_MATRIX_MVP,i.vertex);
				return o;
				
			
			}
			
			float4 frag(vertexOutput o):COLOR   
			{
				float3 normalDirection = o.normalDir;
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - o.posWorld.xyz);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float atten = 1.0;
				
				float3 diffuceReflection = atten*_LightColor0.xyz*saturate(dot(normalize(normalDirection),lightDirection));
				float3 specReflection = atten*_LightColor0.xyz*pow(saturate(dot(reflect(-lightDirection,normalDirection),viewDirection)),_Shininess)*saturate(dot(normalize(normalDirection),lightDirection));
			
				//float rim = dot(viewDirection,normalDirection);
				float rim = 1-saturate(dot(normalize(viewDirection),normalDirection));
				float3 rimLight = atten*_LightColor0.xyz*_RimColor*saturate(dot(normalDirection,lightDirection))*pow(rim,_RimPower);
				
				float3 finalColor = rimLight + diffuceReflection +  specReflection + UNITY_LIGHTMODEL_AMBIENT;
				
				return float4(finalColor  *_Color.xyz,1.0);
			
			}
			
			
			
			ENDCG
		
		}
	} 
	
}
