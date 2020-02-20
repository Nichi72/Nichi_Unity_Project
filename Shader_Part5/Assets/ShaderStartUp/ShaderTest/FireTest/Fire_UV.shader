Shader "Custom/Fire_UV"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "Black" {} //new

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MainTex2;//new

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;//new
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 d = tex2D (_MainTex2, float2(IN.uv_MainTex2.x , IN.uv_MainTex2.y - _Time.y));//new
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex + d.r*3.0f);

            
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
