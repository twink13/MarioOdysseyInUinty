using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Agent : MonoBehaviour {

	public GameObject m_SingleWavePrefab;
	public float m_MaxSpeed = 1;
	public int m_UpdateTick = 1;
    public float m_Offset = 2f;

	private Vector3 m_LastPosition;
	private int m_CurrentTick = 0;

	void Update ()
	{
		if (m_CurrentTick++ >= m_UpdateTick)
		{
			m_CurrentTick = 0;
            
            AddWave(-m_Offset);
            AddWave(m_Offset);

            m_LastPosition = transform.position;
        }
	}

    void AddWave(float offsetH)
    {
        Vector3 currentPosition = transform.position;
        float distance = Vector3.Distance(m_LastPosition, currentPosition);
        Vector3 dir = Vector3.Normalize(currentPosition - m_LastPosition);

        GameObject go = GameObject.Instantiate(m_SingleWavePrefab);
        go.name = offsetH < 0 ? "Left" : "Right";
        go.transform.position = currentPosition;
        go.transform.LookAt(currentPosition + dir);
        go.transform.eulerAngles += Vector3.right * 90;
        Material mat = go.GetComponent<Renderer>().material;

        distance = distance > m_MaxSpeed ? m_MaxSpeed : distance;
        float lightScale = distance / m_MaxSpeed;


        mat.SetFloat("_LightScale", lightScale);
        mat.SetVector("_SpeedDir", dir);
        mat.SetFloat("_OffsetH", offsetH);
    }
}
