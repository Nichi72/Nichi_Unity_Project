Shader "Unlit/SellUpShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
         _Color("Main Tex Color", Color) = (1,1,1,1)
        // _BumpMap("NormalMap", 2D) = "bump" {}
 
        _Outline_Bold("Outline Bold", Range(0, 1)) = 0.1
 
        // _Band_Tex("Band LUT", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
       
        cull front
        Pass
        {
            
            CGPROGRAM
// 프레그마 지시자를 통해서 사용할 버텍스 쉐이더 함수, 프레그마 쉐이더 함수를 를 정해주고 구현을 하자.

            
			#pragma vertex _VertexFuc
			#pragma fragment _FragmentFuc
            // 유니티에서 지원해주는 렌더링에 필요한 기능들을 제공한다.
			#include "unityCG.cginc" 

            struct ST_VertexInput // 버텍스 쉐이더 Input ( 버텍스 좌표, 노말 벡터)
            {
                float4 vertex : POSITION; // 이 문법은 도대체 뭐지?? : 라니? 
                float3 normal : NORMAL;
            };
// 버텍스 쉐이더 OUTPUT ( 버텍스 좌표 )
            struct ST_VertexOutput 
            {
                float4 vertex : SV_POSITION;
            };
            // 여기서 선언 하자 

             float _Outline_Bold;

            ST_VertexOutput _VertexFuc(ST_VertexInput stInput)
            {
                ST_VertexOutput stOutput;
                // 로컬 노말 벡터를 정규화 시킨다. 
                float3 fNormalized_Normal = normalize(stInput.normal); 
                // 버텍스 좌표에 노말 방향으로 더한다. 

                float3 fOutline_Position = stInput.vertex + fNormalized_Normal * (_Outline_Bold * 0.1f); //! 버텍스 좌표에 노말 방향으로 더한다.


                stOutput.vertex = UnityObjectToClipPos(fOutline_Position);
                // 노말 방향으로 더해진 버텍스 좌표를 카메라 공간으로 변환한다.
                // ? 왜 카메라 공간으로 변환하는가? 

                return stOutput;


            }

            float4 _FragmentFuc(ST_VertexOutput i) : SV_Target
            {
                return 0.0f;
            }
            ENDCG

        }
        cull back
        CGPROGRAM
 
        #pragma surface surf _BandedLighting    //! 커스텀 라이트 사용
 
        struct Input
        {
            float2 uv_MainTex;
        };
 
        sampler2D _MainTex;
 
 
        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 fMainTex = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = fMainTex.rgb;
            o.Alpha = 1.0f;
        }
         
        //! 커스텀 라이트 함수
        float4 Lighting_BandedLighting(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            //! BandedDiffuse 조명 처리 연산
            float3 fBandedDiffuse;
            float fNDotL = dot(s.Normal, lightDir) * 0.5f + 0.5f;    //! Half Lambert 공식
 
            //! 0~1로 이루어진 fNDotL값을 3개의 값으로 고정함 <- Banded Lighting 작업
            float fBandNum = 3.0f;
            fBandedDiffuse = ceil(fNDotL * fBandNum) / fBandNum; 
            
 
            //! 최종 컬러 출력
            float4 fFinalColor;
            fFinalColor.rgb = (s.Albedo) *
                                 fBandedDiffuse * _LightColor0.rgb * atten;
            fFinalColor.a = s.Alpha;
 
            return fFinalColor;
        }
 
        ENDCG
    }
}
