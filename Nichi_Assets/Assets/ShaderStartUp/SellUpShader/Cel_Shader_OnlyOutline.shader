Shader "Nichi72/Cel_Shader_OnlyOutline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Outline_Bold ("Outline_Bold" , Range (0,1)) = -0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex _VertexFuc
            #pragma fragment _FragmentFuc
            #include "UnityCG.cginc"

            struct ST_VertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct ST_VertexOutput
            {
                float4 vertex : SV_POSITION;
            };

            float _Outline_Bold;

            ST_VertexOutput _VertexFuc( ST_VertexInput stInput )
            {
                ST_VertexOutput stOutput;

                float3 fNormalized_Normal = normalize(stInput.normal); // 노말 벡터를 정규화!
                float3 fOutline_Posiotion = stInput.vertex + fNormalized_Normal * (_Outline_Bold * 0.1f );

                stOutput.vertex = UnityObjectToClipPos(fOutline_Posiotion);
                return stOutput;
            }

            float4 _FragmentFuc (ST_VertexOutput i ) : SV_TARGET
            {
                return 0.0f;
            }


            ENDCG
        }
    }
}
