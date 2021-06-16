Shader "Nichi72/NewSurfaceShader" // 쉐이더 검색 
{
    Properties // 우리가 흔히 쓰던 유니티 Public 과 똑같은 기능 , 단 아직 변수 선언은 안된 상태이다.  
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        // CGPROGRAM형식의 쉐이더를 시작 구문.
        CGPROGRAM

        // 제일 중요함!! 여기에서 surf가 우리 수정할 surf 함수 이다. 그리고 어떤식으로 렌더링 할건지 뒤에 서술하는것이다.
        #pragma surface surf Standard fullforwardshadows

        // 프로퍼티에서 도출된 값을 담을 변수 선언 . 
        sampler2D _MainTex;

        // 구조체!! "엔진으로 부터 받아와야 할 데이터" 를 담는다. 
        struct Input
        {
            float2 uv_MainTex;
        };

        // 프로퍼티에서 도출된 값을 담을 변수 선언 . 
        fixed4 _Color;


        // 엔진에서 받아올 데이터 Input 구조체로 만든 In 
        // SurfaceOutputStandard는 유니티가 제공하는 구조체 이다. 
        // 안의 내용은 https://docs.unity3d.com/kr/530/Manual/SL-SurfaceShaders.html 참고! 
        void surf (Input IN, inout SurfaceOutputStandard o) // 함수 
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            // 
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        // CGPROGRAM형식의 쉐이더를 마치는 구문.
        ENDCG
    }
    FallBack "Diffuse"
}
