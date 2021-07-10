// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/camshader"
{
    Properties
    {
         _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Albedo Texture", 2D) = "white" {}
        _Transparency("Transparency", Range(0.0,0.5)) = 0.25
     
    }
        SubShader
    {
       Tags {"Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        Zwrite On
        Blend SrcAlpha OneMinusSrcAlpha
        Lighting Off

        Pass
        {
            
            CGPROGRAM
            #pragma vertex vert
        
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            float4 _Color;
            float4 _Transparency;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                half4 color : COLOR;
            
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
              

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                //col.rgb *= col.a;
                if ((i.col.r == 1) && (i.col.g == 1) && (i.col.b == 1)) {

                    i.col.a = _Transparency;

                }
                return col * i.color;
            }
            ENDCG
        }
    }
}
