#include "UnityCG.cginc"
sampler2D _MainTex;//自动获得前文定义的值
sampler2D _GrabTexture;//自动获得屏幕颜色。未渲染此物体之前
float4 _GrabTexture_TexelSize;//自动赋值。每个大约是1/1024，1024改为实际像素数
float4 _MainTex_ST;//自动获得
float2 Rect;//脚本设置
float4 BorderC;//脚本设置
float4 SelfColor;//脚本设置
float BorderW;//脚本设置
float Size;//脚本设置
int Mix;//脚本设置
struct In {
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float4 color : COLOR;
};
struct Out {
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float4 uvgrab : TEXCOORD1;
    float4 color : COLOR;
};
static float2 offsetsV[19] = {
    float2(0, -9), float2(0, -8), float2(0, -7), float2(0, -6), float2(0, -5), float2(0, -4), float2(0, -3), float2(0, -2), float2(0, -1),
    float2(0, 0),
    float2(0, +1), float2(0, +2), float2(0, +3), float2(0, +4), float2(0, +5), float2(0, +6), float2(0, +7), float2(0, +8), float2(0, +9)
};
static float2 offsetsH[19] = { //从Y轴上采样，点的颜色是Y轴平均色
    float2(-9, 0), float2(-8, 0), float2(-7, 0), float2(-6, 0), float2(-5, 0), float2(-4, 0), float2(-3, 0), float2(-2, 0), float2(-1, 0),
    float2(0, 0), 
    float2(1, 0), float2(2, 0), float2(3, 0), float2(4, 0), float2(5, 0), float2(6, 0), float2(7, 0), float2(8, 0), float2(9, 0)
};
static float kernel[19] = {
    0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 
    0.1,
    0.09, 0.08, 0.07, 0.06, 0.05, 0.04, 0.03, 0.02, 0.01
};
Out Transform(In v) {
    Out o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    #if UNITY_UV_STARTS_AT_TOP
        float scale = -1.0;
    #else
        float scale = 1.0;
    #endif
    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;//从-1到1 归入0到1
    o.uvgrab.zw = o.vertex.zw;
    o.color = v.color;
    return o;
}
float4 ClearAlpha(float4 X) {
    return float4(X.x, X.y, X.z, 1);
}
float4 HBlur(Out i) : SV_Target {
    float4 color = float4(0.0, 0.0, 0.0, 0.0);
    for (int j = 0; j < 19; j++) {
        float4 A = tex2D(_GrabTexture, i.uvgrab.xy + float2(offsetsV[j].x * _GrabTexture_TexelSize.x, offsetsV[j].y * _GrabTexture_TexelSize.y) * Size);
        if (Mix==1) {
            A = SelfColor.w * SelfColor + (1 - SelfColor.w) * A;
        }
        color += A * kernel[j];
    }
    return color;
}
float4 VBlurAndOutLine(Out i) : SV_Target {
    if (i.uv.x * Rect.x < BorderW || i.uv.y * Rect.y < BorderW || (1.0 - i.uv.x) * Rect.x < BorderW || (1.0 - i.uv.y) * Rect.y < BorderW){
        return BorderC;
    }
    float4 color = float4(0.0, 0.0, 0.0, 0.0);
    for (int j = 0; j < 19; j++) {
        float4 A = tex2D(_GrabTexture, i.uvgrab.xy + float2(offsetsH[j].x * _GrabTexture_TexelSize.x, offsetsH[j].y * _GrabTexture_TexelSize.y) * Size);
        if (Mix==1) {
            A = SelfColor.w * SelfColor + (1 - SelfColor.w) * A;
        }
        color += A * kernel[j];
    }
    return color;
}