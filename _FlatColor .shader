Shader "testShader/vol1-_FlatColor"{
	Properties{
		_Color("color",Color) = (1.0,1.0,1.0,1.0)
	
	}

	SubShader{
		Pass{
			CGPROGRAM
			//pragma
			#pragma vertex vert
			#pragma fragment frag
			
			//variable ,let the cg accept the var we declared from UP
			float4 _Color;
			
			
			//struct,input and output
			struct vertexInput
			{
				float4 vertex:POSITION;
			};
			
			struct vertexOutput
			{
				float4 pos:SV_POSITION;
			
			};
			
			
			//vertet function
			
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				return o;
			}
		
			//fragment function
			float4 frag(vertexOutput o):Color
			{
				return _Color;
			
			
			}
			
			
		
			ENDCG
		}
	}

}