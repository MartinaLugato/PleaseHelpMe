#ifndef PYRAMIDFACES_INCLUDED
#define PYRAMIDFACES_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "NMGGeometryHelpers.hlsl"

// Structure generated by the renderer and passed as input to the Vertex Shader
// The words in caps are called "semantic" and are used by the GPU to match the data with the shader input
struct Attributes
{
    float3 positionOS : POSITION;
    float3 normalOS : NORMAL;
    float4 tangentOS : TANGENT;
    float2 uv : TEXCOORD0;
};

// Structure generated by the Vertex Shader and passed as input to the Geometry Shader
struct VertexOutput
{
    float3 positionWS : TEXCOORD0;
    float2 uv: TEXCOORD1;
};

// Structure generated by the Geometry Shader and passed as input to the Fragment Shader
struct GeometryOutput
{
    float3 positionWS : TEXCOORD0;
    float2 uv: TEXCOORD1;
    float3 normalWS : TEXCOORD2;
    float4 positionCS : SV_POSITION;
};

// The _MainTex is a texture property that will be set in the material inspector
TEXTURE2D(_MainTex); 
SAMPLER(sampler_MainTex);
float4 _MainTex_ST; //scale and offset of the texture

//The pyramid height property
float _PyramidHeight;

// Vertex Function
VertexOutput Vertex(Attributes input)
{
    VertexOutput output = (VertexOutput)0;

    // First, we transform the vertex position from object space to world space
    // This function GetVertexPositionInputs is defined in ShaderVariablesFuntions.hlsl, is a wrapper that abstracts the use 
    // of TransformObjectToWorld function and so on... 
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
    output.positionWS = vertexInput.positionWS;
    // output.positionCS = vertexInput.positionCS;

    // Convert normal from object space to world space
    // VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS.xyz);
    // output.normalWS = normalInput.normalWS;

    // use macro TRANSFORM_TEX defined in UnityCG.inc to scale and offset the uv according to the _MainTex_ST property
    output.uv = TRANSFORM_TEX(input.uv, _MainTex);
    return output;
}

// Define Geometry Function here
[maxvertexcount(9)]
void Geometry(triangle VertexOutput input[3], inout TriangleStream<VertexOutput> outputStream)
{
    ///TODO: Implement Geometry Shader
}

// Fragment Function
// The SV_Target semantic is used to specify that the output of this function is the final color of the pixel
float4 Fragment(GeometryOutput input) : SV_Target
{
    InputData lightingInput = (InputData)0;
    lightingInput.positionWS = input.positionWS;
    lightingInput.positionCS = input.positionCS;
    lightingInput.normalWS = input.normalWS;

    float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);

    SurfaceData surfaceData = (SurfaceData)0;
    surfaceData.albedo = color.rgb;
    surfaceData.specular=0.0f;
    surfaceData.smoothness=0.0f;
    surfaceData.metallic = 0.0f;


    return UniversalFragmentBlinnPhong(lightingInput, surfaceData);
}

#endif