Shader "testShader/ShaderLearning - NormalMap"{
	Properties {
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)
		_MainTex ("Diffuse Texture", 2D) = "white" {}
		_NormalMap("NormalMap",2D) = "bump"{}
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10
		_RimColor ("Rim Color", Color) = (1.0,1.0,1.0,1.0)
		_RimPower ("Rim Power", Range(0.1,10.0)) = 3.0
		_Depth("Depth",Range(0,2.0))= 0.4
	}
	SubShader {
		Pass {
			//Tags {"LightMode" = "ForwardBase"}
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash
			
			//user defined variables
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _Shininess;
			uniform float _RimPower;
			uniform fixed _Depth;
			
			//unity defined variables
			uniform float4 _LightColor0;
			
			//base input structs
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent:TANGENT;
				float4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;
				float4 posWorld : TEXCOORD1;
				float3 normalDir : TEXCOORD2;
				float3 tangentWorld:TEXCOORD4;
				float3 binormal:TEXCOORD3;
			};
			
			//vertex Function
			
			vertexOutput vert(vertexInput v){
				vertexOutput o;
				
				o.posWorld = mul(_Object2World, v.vertex);
				//o.normalDir = normalize( mul( float4( v.normal, 0.0 ), _World2Object ).xyz );
				o.normalDir = normalize( mul(float4( v.normal, 0.0 ),_World2Object ).xyz );
				o.tangentWorld = normalize(mul( _Object2World,v.tangent).xyz);
				o.binormal = normalize(cross(o.normalDir,o.tangentWorld) * v.tangent.w);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.tex = v.texcoord;
				
				return o;
			}
			
			//fragment function
			
			float4 frag(vertexOutput i) : COLOR
			{
			
//				float3x3 newMartrix = float3x3
//				(
//				
//				i.tangentWorld,
//				i.binormal,
//				i.normalDir
//				
//				);
				//float4 texN = tex2D(_BumpMap, i.tex.xy * _BumpMap_ST.xy + _BumpMap_ST.zw);
				float4 texN = tex2D(_NormalMap,i.tex.xy*_NormalMap_ST.xy + _NormalMap_ST.zw);
				float3x3 local2WorldTranspose = float3x3(
					i.tangentWorld,
					i.binormal,
					i.normalDir
				);
				float3 localCoords = float3(2.0 * texN.ag - float2(1.0, 1.0), 0.0);
				localCoords.z = _Depth;
				
				
				
				float3 normalDirection = normalize(mul(localCoords,local2WorldTranspose));
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz );
				float3 lightDirection;
				float atten;
				
				if(_WorldSpaceLightPos0.w == 0.0){ //directional light
					atten = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else{
					float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float distance = length(fragmentToLightSource);
					atten = 1.0/distance;
					lightDirection = normalize(fragmentToLightSource);
				}
				
				//Lighting
				float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
				float3 specularReflection = diffuseReflection * _SpecColor.xyz * pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)) , _Shininess);
				
				//Rim Lighting
				float rim = 1 - saturate(dot(viewDirection, normalDirection));
				float3 rimLighting = saturate( dot( normalDirection, lightDirection ) * _RimColor.xyz * _LightColor0.xyz * pow( rim, _RimPower ) );
				
				float3 lightFinal = UNITY_LIGHTMODEL_AMBIENT.xyz + diffuseReflection + specularReflection + rimLighting;
				
				//Texture Maps
				float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				
				return float4(tex.xyz * lightFinal * _Color.xyz, 1.0);
			}
			

		
			
			ENDCG
			
		}
	}
	//Fallback "Specular"
}