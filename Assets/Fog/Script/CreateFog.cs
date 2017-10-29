using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateFog : MonoBehaviour {

    public int m_Size = 128;
    public float m_Gap = 1f;

    public Material m_HeightRecoverMaterial;
    public Material m_HeightHitMaterial;

    private Mesh m_Mesh;
    public RenderTexture m_Heightmap;
    public RenderTexture m_HeightmapTemp;

    // Use this for initialization
    void Start () {
        m_Mesh = GetComponent<MeshFilter>().sharedMesh;
        m_Mesh.Clear();

        CreateMesh();
        CreateRt();


        // set collider box size
        //GetComponent<BoxCollider>().size = new Vector3(m_Size - 1, 1, m_Size - 1);

        // set heightmap
        GetComponent<Renderer>().sharedMaterial.SetTexture("_MainTex", m_Heightmap);
    }

    // Update is called once per frame
    void Update()
    {
        Graphics.Blit(m_Heightmap, m_HeightmapTemp);
        Graphics.Blit(m_HeightmapTemp, m_Heightmap, m_HeightRecoverMaterial);

        if (Input.GetMouseButton(0))
        {
            RaycastHit hit;
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out hit))
            {
                m_HeightHitMaterial.SetVector("_HitPos", hit.textureCoord);

                Graphics.Blit(m_Heightmap, m_HeightmapTemp);
                Graphics.Blit(m_HeightmapTemp, m_Heightmap, m_HeightHitMaterial);
            }
        }
    }

    void CreateMesh()
    {
        int count = m_Size * m_Size;
        int blockSize = m_Size - 1;
        int trangleCount = blockSize * blockSize * 2;
        Vector3 centerPos = new Vector3(blockSize / 2, 0, blockSize / 2);

        Vector3[] verts = new Vector3[count];
        Vector3[] normals = new Vector3[count];
        Vector2[] uvs = new Vector2[count];
        for (int i = 0; i < m_Size; i++)
        {
            for (int j = 0; j < m_Size; j++)
            {
                verts[i * m_Size + j] = new Vector3(j * m_Gap, 0, i * m_Gap) - centerPos;
                normals[i * m_Size + j] = Vector3.up;
                uvs[i * m_Size + j] = new Vector2((float)j / (float)m_Size, (float)i / (float)m_Size);
            }
        }

        int[] triangles = new int[trangleCount * 3];
        int trangleIndex = 0;
        for (int i = 0; i < blockSize; i++)
        {
            for (int j = 0; j < blockSize; j++)
            {
                int curr = i * m_Size + j;
                int right = i * m_Size + j + 1;
                int up = (i + 1) * m_Size + j;
                int upRight = (i + 1) * m_Size + j + 1;

                triangles[trangleIndex++] = curr;
                triangles[trangleIndex++] = up;
                triangles[trangleIndex++] = right;

                triangles[trangleIndex++] = right;
                triangles[trangleIndex++] = up;
                triangles[trangleIndex++] = upRight;
            }
        }

        m_Mesh.vertices = verts;
        m_Mesh.normals = normals;
        m_Mesh.triangles = triangles;
        m_Mesh.uv = uvs;
    }

    void CreateRt()
    {
        m_Heightmap = RenderTexture.GetTemporary(m_Size, m_Size, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
        m_Heightmap.filterMode = FilterMode.Bilinear;
        m_HeightmapTemp = RenderTexture.GetTemporary(m_Size, m_Size, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
        m_HeightmapTemp.filterMode = FilterMode.Bilinear;
    }
}
