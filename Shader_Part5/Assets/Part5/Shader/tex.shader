// 지식 : 
// @1 sampler2D :  텍스쳐는 UV와 만나기 전 까지는 그냥 메모리에 올라와있는 텍스쳐 일 뿐이고  UV와 만나야 제대로 자리를 잡아 비로소 float4로 표현할 수 있게 된다. 
// 그래서 UV가 없을때는 flaot4가 아니라 sampler 종류중 하나인 sampler2D로 선언하게 된다.

// @2 UV : UV는 Vertex가 가지고 있다. Vertex 는 우리가 만든 인터페이스가 아니다.  Vertex 내부에 있는 값에 접근을 하려면 Input 구조체 안에서
// 가지고 와야한다. UV는 U 와 V 2개의 숫자로 이루어지므로 float2 이다. 
// _MainTex 의  UV를 뜻 하기 위해 uv_MainTex라고 이름을 짓는것이다. 

// @3 Input 구조체 : @2  참고




Shader "Custom/tex"
{

	// 인스펙터에 노출되는 변수들
    Properties
    {
		// _MainTex는 텍스쳐를 입력받는 변수이다. 
		// Albedo(RGB) :  이 부분에는  Albedo 텍스쳐를 넣는 형식이고 알파를 사용하지 않는다면 RGB 채널만 사용.
		// 2D : 이 곳에서 2D 텍스쳐를 받는 부분.
		// white{} : 기본 값이다. 만약 블랙이면 기본값으로 블랙을 가지고 있을 것이다.
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
		
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
		// 입력받는 텍스쳐를 sampler2D로 받게 된다.
		//@1 : sampler2D
        sampler2D _MainTex;


        struct Input
        {
			//@2 UV
            float2 uv_MainTex;
        };
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
