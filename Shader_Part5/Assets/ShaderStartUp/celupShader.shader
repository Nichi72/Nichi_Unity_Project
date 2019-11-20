Shader "Unlit/celupShader"
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
