Shader "Custom/Fire"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Color2 ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // 일반적인 상태에서는 알파채널이 있어도 알파가 먹히질 않는다. 따라서 바꿔줘야 함
        //Tags { "RenderType"="Opaque" } 에서 
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        CGPROGRAM
        //#pragma surface surf Standard fullforwardshadows 에서 
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MainTex2;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
        };
        fixed4 _Color;
        fixed4 _Color2;
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 d = tex2D (_MainTex2, float2 (IN.uv_MainTex.x , IN.uv_MainTex.y - _Time.y)) * _Color2; 
            o.Emission = c.rgb * d.rgb;
            o.Alpha =  c.a *d.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
