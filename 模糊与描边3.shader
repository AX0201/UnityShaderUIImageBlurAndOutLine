Shader "Custom/模糊与描边3" {
    Properties {
        _MainTex ("Sprite Texture", 2D) = "white" {} //消除警告
        _Stencil ("Stencil Ref", Int) = 0 //消除警告
        _StencilComp ("Stencil Comp", Int) = 8 //消除警告
        _StencilOp ("Stencil Op", Int) = 1 //消除警告
        _StencilReadMask ("Stencil Read Mask", Int) = 255 //消除警告
        _StencilWriteMask ("Stencil Write Mask", Int) = 255 //消除警告
    }
    SubShader {
        Tags {
            "Queue" = "Transparent" //消除警告
            "IgnoreProjector" = "True" //消除警告
            "RenderType" = "Transparent" //消除警告
            "PreviewType" = "Plane" //消除警告
            "CanUseSpriteAtlas" = "True" //消除警告
        }
        Stencil {
            Ref [_Stencil] //消除警告
            Comp [_StencilComp] //消除警告
            Pass [_StencilOp] //消除警告
            ReadMask [_StencilReadMask] //消除警告
            WriteMask [_StencilWriteMask] //消除警告
        }
        GrabPass { }//用于后续自动分配：_GrabTexture
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha //让透明度有效
            CGPROGRAM
            #pragma vertex Transform
            #pragma fragment HBlur //水平模糊
            #include "CMKZ.cginc"
            ENDCG
        }
        GrabPass { }//用于后续自动分配：_GrabTexture
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha //让透明度有效
            CGPROGRAM
            #pragma vertex Transform
            #pragma fragment VBlurAndOutLine //垂直模糊与边框
            #include "CMKZ.cginc"
            ENDCG
        }
    }
}