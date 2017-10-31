using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Agent : MonoBehaviour {

	public GameObject m_SingleWavePrefab;
	public float m_MaxSpeed = 1;
	public int m_UpdateTick = 1;

	private Vector3 m_LastPosition;
	private int m_CurrentTick = 0;

	void Update ()
	{
		if (m_CurrentTick++ >= m_UpdateTick)
		{
			m_CurrentTick = 0;

			Vector3 currentPosition = transform.position;
			GameObject go = GameObject.Instantiate(m_SingleWavePrefab);
			go.transform.position = currentPosition;
			Material mat = go.GetComponent<Renderer>().material;

			float distance = Vector3.Distance(m_LastPosition, currentPosition);
			distance = distance > m_MaxSpeed ? m_MaxSpeed : distance;
			float lightScale = distance / m_MaxSpeed;

			Vector3 dir = Vector3.Normalize(currentPosition - m_LastPosition);

			mat.SetFloat("_LightScale", lightScale);
			mat.SetVector("_SpeedDir", dir);

			m_LastPosition = currentPosition;
		}
	}
}
