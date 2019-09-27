Shader "Unlit/SellUpShader"
{
    Properties
    {

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float4 vertex : POSITION;
                float3 nomal : NORMAL;
            }
            struct ST_VertexOutput // 버텍스 쉐이더 OUTPUT ( 버텍스 좌표 )
            {
                float4 vertex : SV_POSITION;
            }
            ST_VertexOutput _VertexFuc(ST_VertexInput stInput)
            {
                ST_VertexOutput stOutput;
                // 로컬 노말 벡터를 정규화 시킨다. 
                float3 fNomalized_Normal = normalize(stInput.nomal); 
                // 버텍스 좌표에 노말 방향으로 더한다. 
                float3 fOutline_Position = stInput.vertex + fNormalized_Normal * (_Outline_Bold * 0.1f);

                stOutput.vertex = UnityObjectToClipPos(fOutline_Position);
                // 노말 방향으로 더해진 버텍스 좌표를 카메라 공간으로 변환한다.
                // ? 왜 카메라 공간으로 변환하는가? 

                return stOutput;


            }

			void _VertexFuc()
			{
				float2 test;
                
			}
			void _FragmentFuc()
			{
				
			}

            ENDCG
        }
    }
}
