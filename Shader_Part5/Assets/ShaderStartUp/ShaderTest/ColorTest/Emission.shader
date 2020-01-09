Shader "Nichi72/Emission"
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
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            float3 red = float3(1,0,0);
            float3 green = float3(0,1,0);
            float3 yellow = red + green;
            float3 multiply  = red * green;
            float3 gray = 
            o.Emission = multiply;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
