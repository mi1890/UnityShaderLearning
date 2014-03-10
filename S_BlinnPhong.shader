Shader "testShader/Special_BlinnPhong" {
	Properties {
		_Color("MainColor",Color) = (1.0,1.0,1.0,1.0)
		_SpecularColor("SpecColor",Color) = (1.0,1.0,1.0,1.0)
		_Shininess("Shininess",float) = 2.0
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		
	}
	SubShader {
		Pass{
			Tags{"LightMode" = "ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include"UnityCG.cginc"
		//#include "UNITY.cgnic"
		
		uniform fixed4 _Color;
		uniform fixed4 _SpecularColor;
		uniform half _Shininess;
		uniform sampler2D _MainTex;
		
		
		//unity defined variables
		uniform float4 _LightColor0;
		
		struct VertexInput
		{
			float4 vertex:POSITION;
			float3 normal:NORMAL;
			float4 texcoord:TEXCOORD0;
			
		};
		
		struct VertexOutput
		{
			float4 pos:SV_POSITION;
			float4 tex:TEXCOORD0;
			float3 normalWorld:TEXCOORD1;
			float4 posWorld:TEXCOORD2;
			
		};
		
		VertexOutput vert(VertexInput i)
		{
			VertexOutput o;
			o.pos = mul(UNITY_MATRIX_MVP,i.vertex);
			o.posWorld = mul(_Object2World,i.vertex);
			o.normalWorld = normalize(mul( float4(i.normal,1.0),_World2Object).xyz);
			return o;
		}
		
		
		float4 frag(VertexOutput o):COLOR
		{	
			float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
			float3 viewDir =  normalize( _WorldSpaceCameraPos.xyz - o.posWorld.xyz );
			float3 halfView = normalize(lightDir + viewDir);
			
			float3 lambertColor = saturate(dot(o.normalWorld,lightDir))*_LightColor0.xyz;
			float3 specColor =pow(saturate( dot(halfView,o.normalWorld)),_Shininess)*_SpecularColor;
			
			
			float3 finalColor =lambertColor + specColor +UNITY_LIGHTMODEL_AMBIENT;
			return float4(finalColor,1.0);
		}
		
		
		ENDCG
		}
	} 
	//FallBack "Diffuse"
}
