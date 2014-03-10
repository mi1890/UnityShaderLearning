Shader "Alpha/alphaTextureRim"{
	Properties{
		_Color ("MainColor",Color) = (1.0,1.0,1.0,1.0)
	 	_RimColor("RimColor",Color) = (1.0,1.0,1.0,1.0)
	 	_RimPower("RimPower",Range(-0.5,0.5)) = 0 
	 	_TextureBlend("textureBlebd",Range(0,1))  =0.2
	 	_MainTex("MainTexture",2D) = "white"{}
	
	}
	SubShader{
		Pass{
			Tags {"Queue" = "Transparent" } 
			Blend SrcAlpha OneMinusSrcAlpha
			zWrite off
			//Cull Off
			//zWrite On
			//ZTest LEqual
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			uniform float4 _Color;
			uniform float4 _RimColor;
			uniform float _RimPower; 
			uniform float _TextureBlend;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			//accept unity variable
			//uniform float4 _LightColor0;
			
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
				
				float rim = 1- saturate(dot(viewDirection,normalDirection) + _RimPower);
				  
				float3 mianColor =    lerp(_Color,_RimColor,rim) ;
				  
				float4 tex = tex2D(_MainTex,_MainTex_ST.xy*o.tex.xy  + _MainTex_ST.zw*0.2); 
				 
				float3 finalColor = UNITY_LIGHTMODEL_AMBIENT.xyz  + tex + mianColor*_TextureBlend;
				
				
				
				return float4(finalColor,rim)  ;
			}
			
			ENDCG
		
		
		}
	
	
	}



}