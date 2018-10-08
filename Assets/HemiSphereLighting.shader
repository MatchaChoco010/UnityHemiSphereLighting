Shader "HemiSphereLighting"
{
    Properties
    {
        [Header(Light)]
        _LightColor ("Light Color", Color) = (1, 1, 1, 1)
        _LightDir ("Light Direction", Vector) = (1, 1, -1, 0)
        [Header(Hemi Sphere Lighting)]
        _SkyColor ("Sky Color", Color) = (0.5, 0.75, 1, 1)
        _GroundColor("Ground Color", Color) = (0.5, 0.25, 0, 1)
        _Intensity("Intensity", float) = 0.5
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            uniform float3 _LightColor;
            uniform float3 _LightDir;

            uniform float3 _SkyColor;
            uniform float3 _GroundColor;
            uniform float _Intensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float3 lightDir = normalize(_LightDir);

                float3 lambert = _LightColor * max(dot (normal,lightDir), 0);

                float t = dot (normal, float3 (0, 1, 0)) * 0.5 + 0.5;
                float3 hemisphere = lerp(_GroundColor, _SkyColor, t);

                return fixed4(lambert + _Intensity * hemisphere, 1);
            }
            ENDCG
        }
    }
}
