Shader "Custom/UV_test"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

         // 일반적으로 쉐이더 언어로는 문자를 출력할 수 없다.
         // 그래서 일단 색을 가지고 값이 어떻게 변하는지 알아내는 방법으로 진행함.
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // [기본형] 
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            // [위치를 0.5 증가]
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex+0.5f) * _Color; // 0.5 이동 
            // [시간에 따라 이미지를 움직이게 함] 
            // fixed4 c = tex2D (_MainTex, float2(IN.uv_MainTex.x + _Time.y , IN.uv_MainTex.y )) * _Color;

            //o.Emission = IN.uv_MainTex.y; // Y축을 보여줌
            //o.Emission = IN.uv_MainTex.x; // X축을 보여줌 
            //o.Emission =  float3 (IN.uv_MainTex.x, IN.uv_MainTex.y , 0); // XY축을 RG 로 변환 
            // 
           
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
