Shader "Custom/albedo"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }


        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float3 r = (1,0,0);
            float3 y = (0,1,0);

            o.Albedo = c.rgb * float3(1,0.2,0);

            // 큰 수를 곱하면 곱할 수록 서브픽셀 값에 가까워짐
            // 작은 수를 곱하면 곱할 수록 원색에 가까워짐 

            // 
            //o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
