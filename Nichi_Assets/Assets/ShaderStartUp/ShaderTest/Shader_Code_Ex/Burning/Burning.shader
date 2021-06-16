/*
1. 알파적용
2. 노이즈채널 R을 통해 알파값을 조절한다. 
3. 아웃라인 적용
4. 아웃라인에 색을 넣는다. 
*/

Shader "Custom/Burning"
{
    Properties
    {
        [HDR] _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex ("NormalMap", 2D) = "white" {}
        _Cut ("Cut", Range(0,0.7)) = 0
        _OutLineBold ("OutLineBold", Range(1,1.15)) = 0
  



    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"  }
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
    

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float _Cut;
        float _OutLineBold;
        float4 _Color; // 더 많은색을 담을 수 있게 되었기에 fixed4 말고 float4로 

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };
        

    

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 noise = tex2D (_NoiseTex, IN.uv_NoiseTex);
            o.Albedo = c.rgb;

            float alpha;
           
 
            // 즉 True false라는 것이다. 이렇게 값을 짤라서 표현 할 부분을 정해주는 것임
            // 노이즈의 값은 0~1까지 이다. 
            // 따라서 어두운부분 ( 0 ) 부터 천천히 짤라서
            // 보여주고 안보여주고 이 차이 
            if( _Cut <=noise.r)
            {
                alpha = 1; 
            }
            else
            {
                alpha = 0;
            }

            // 아웃라인도 마찬가지. 
            // 다만 이번엔 짤리는 값 보다 조금 더 큰 수 (1.2정도)를 짜른다. 그럼 그 1.2 만큼의 차이 만큼 아웃라인 생기는 것 
            // 그래서 그 짤리는 값보다 크면 검은색 ( 검게 칠한다. )
            // 그래서 그 짤리는 값보다 작으면 흰색 ( 하얗게 칠한다. )
            float outLine;
            if( _Cut * _OutLineBold <=noise.r ) // 곱하기를 하는 이유 0~1까지의 값인데 더해버리면 값이 적어도 +N이 되서 절대 ㄴ
            {
                outLine = 0;      
            }
            else
            {
                outLine = 1.0;
            }


            
            o.Emission = outLine * _Color.rgb;
            o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
