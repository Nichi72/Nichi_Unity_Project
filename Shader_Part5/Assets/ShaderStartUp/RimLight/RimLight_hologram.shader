Shader "Custom/RimLight_hologram"
{
    Properties
    {
        _Rimcolor ("Color", Color) = (1,1,1,1)
        _RimPower("RimPower" , Range(1,10)) = 3 
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Tranparent" "Queue" = "Transparent" }
        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade
        #pragma target 3.0

        fixed4 _Rimcolor;
        sampler2D _MainTex;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            float rim = saturate( dot (o.Normal , IN.viewDir));
            rim = pow ( 1- rim , _RimPower);
            o. Emission =  _Rimcolor.rgb ;
            o.Alpha = rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
