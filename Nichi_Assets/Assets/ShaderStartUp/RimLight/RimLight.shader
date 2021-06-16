Shader "Custom/RimLight"
{
    Properties
    {
        _Rimcolor ("Color", Color) = (1,1,1,1)
        _BumpMap ("NormalMap" , 2D ) = "bump" {}
        _RimPower("RimPower" , Range(1,10)) = 3 
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert noambient 
        #pragma target 3.0

        fixed4 _Rimcolor;
        sampler2D _BumpMap;
        sampler2D _MainTex;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D (_BumpMap , IN.uv_BumpMap));
            float rim = saturate( dot (o.Normal , IN.viewDir));
            o. Emission = pow ( 1- rim , _RimPower) * _Rimcolor.rgb ;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
