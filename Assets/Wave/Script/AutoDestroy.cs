using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoDestroy : MonoBehaviour {

	public float m_LifeTime = 1f;

	private float m_StartTime;

	// Use this for initialization
	void Start () {
		m_StartTime = Time.time;
	}
	
	// Update is called once per frame
	void Update () {
		if (Time.time >= m_StartTime + m_LifeTime)
		{
			GameObject.Destroy(this.gameObject);
		}
	}
}
