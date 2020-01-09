Shader "Nichi72/Cel_Shader_OnlyVertex"
{
    Properties
    {
        _Outline_Bold("Outline Bold", Range(0,1)) = 0.1
        _MainTex ("Main Texture",2D ) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        cull front
        Pass
        {

           
            CGPROGRAM

            #include "UnityCG.cginc"
            #pragma vertex _VertexFuc
            #pragma fragment _FramentFuc

            /*
            [실험] 
                UnityObjectToClipPos로 왜 카메라 좌표로 옮기는지
                카메라 좌표로 옮기지 않으면 어떤 일이 일어나는지 알고 싶다! 


                그래서 

                stOutput.vertex = UnityObjectToClipPos(fOutline_Position);
                이게 어떤 영향을 주고 싶은지 알고 싶어서 빼봤더니

                cannot implicitly convert from 'const float3' to 'float4' at line 46 (on d3d11)
                46 행에서 'const float3'에서 'float4'로 암시 적으로 변환 할 수 없음 (d3d11)
                라고 뜸 보니까 

                stOutput.vertex 는 float4 이고
                
                fOutline_Position는 float3 이라서 자료형이 안맞았다.

            [솔루션1]

                그럼 암시적 캐스팅이 안된다면 강제 캐스팅은? 

            [결과1]
            
                캐스팅 그런거 없어~
                구글에 쳐봤는데 진짜 안나옴 그래서 그냥 (float4) 때려봤는데 응 안돼~~

            [솔루션2]

                float3 fOutline_Position 을 그냥 처음부터 flaot4로 받아버릴까?

            [결과2]

                fOutline_Position는 결국 노말값 float3 normal : NORMAL;을 받아와야 하기 때문에 
                float3 이어야 함 ! 

            [솔루션3]
           
                float3 normal : NORMAL; 
                =>
                float4 normal : NORMAL;

                받는 것을 3에서 4로 바꿨음.

            [결과3]

                그랬더니 그냥 엔진에서 못받아오는거 같음. 

            [실험 결론]
                flaot3과 flaot4의 차이는 행렬변환의 유무 라고 알고있다.
                행렬변환을 한다면 사원수가 더 빠르니까.

                즉 Vertex들은 행렬로 공간을 자주 변경하기 때문에 flaot4이다.
                Normal값은 공간을 변경하지 않으니 flaot3 이다.

                이는 즉
                "normal값은 로컬좌표에서만 존재 할 수 있다"라고 생각 할 수 있지 않을까? <= ( 오~ 굉장한 논리비약~~ )
                하지만 어쨌든 노말값도 같이 카메라 공간까지 끌고와야한다.
                그래서 그 노말값을 UnityObjectToClipPos를 통해 변환을 한것이고
                변환하는 과정에서 유니티가 아무튼 사원수로 바꿔주기 때문아닐까...? 

                보니까 float4 UnityObjectToClipPos(float3 pos) 이던데.. 


            [대마왕 교수님 답변]
                저거 클립스페이스란 개념을 알아야 하는데, 모델 -뷰 - 프로젝션이 기본이라 MVP잖아?
                거기에 프러스텀 영역을 자르면 다시 육면체가 되어서 그걸 0~1 크기의 육면체 영역으로 지정해 주는데 
                그게 클립 스페이스야. 그리고 그 모든 과정을 한번에 해주는게 저 함수일 뿐이야.

                즉 공간변환을 한큐에 해주는 함수일 뿐이야 별거아님

 
            */

        

           
            struct ST_VertexInput
            {
                float4 vertex :POSITION;
                float3 normal : NORMAL;
            };

            struct ST_VertexOutput
            {
                float4 vertex : SV_POSITION;

            };

            float _Outline_Bold;


            ST_VertexOutput _VertexFuc(ST_VertexInput stInput)
            {
                ST_VertexOutput stOutput;

                float3 fNormalized_Normal = normalize(stInput.normal);
                float3 fOutline_Position = stInput.vertex + fNormalized_Normal * (_Outline_Bold * 0.1f);
                
                //즉 최종 영역까지 한 번에 변환하는 함수입니다. 
                stOutput.vertex = UnityObjectToClipPos(fOutline_Position);

                return stOutput;

            }

             
            float4 _FramentFuc( ST_VertexOutput i) : SV_TARGET
            {
                return 0.0f;
            }

     

            

            ENDCG
        }

        cull back


        CGPROGRAM
        #pragma surface surf _BandedLighting

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;

        void surf(Input IN , inout SurfaceOutput o)
        {
            float4 fMainTex = tex2D(_MainTex , IN.uv_MainTex);
            o.Albedo = fMainTex.rgb;
            o.Alpha = 1.0f;

        }

        float4 Lighting_BandedLighting (SurfaceOutput s , float3 lightDir , float3 viewDir , float atten)
        {

            float3 fBandedDiffuse;
            float fNDotL = dot(s.Normal , lightDir) *0.5f + 0.5f;

            float fBandNum = 3.0f;
            fBandedDiffuse = ceil(fNDotL * fBandNum) / fBandNum;

            float4 fFinalColor;
            fFinalColor.rgb = (s.Albedo) * fBandedDiffuse * _LightColor0.rgb * atten;

            fFinalColor.a = s.Alpha;

            return fFinalColor;

        }

        ENDCG


    }
}
