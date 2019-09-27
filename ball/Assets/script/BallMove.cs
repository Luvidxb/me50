using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallMove : MonoBehaviour {
	public float speed;
	public float tspeed;
	
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		 Physics.gravity = new Vector3(0, -50.0F, 0);
		 float moveHorizontal = Input.GetAxis ("Horizontal");
        float moveVertical = Input.GetAxis ("Vertical");
	 
if (Input.GetKey(KeyCode.W)){
	 Vector3 movement = new Vector3 (-12, 0.0f, 0.0f);

         GetComponent<Rigidbody>().AddForce (movement * speed);
}
if (Input.GetKey(KeyCode.A)){
	 GetComponent<Rigidbody>().AddForce (-Vector3.forward * 120);
}
if (Input.GetKey(KeyCode.D)){
	 GetComponent<Rigidbody>().AddForce (Vector3.forward * 120);
}
if (Input.GetKey(KeyCode.S)){
	 Vector3 movement = new Vector3 (12, 0.0f, 0.0f);

         GetComponent<Rigidbody>().AddForce (movement * speed);
}

if (Input.GetKeyDown(KeyCode.Space)){
	if(transform.position.y>5){
		
	}
	else{
 	Physics.gravity = new Vector3(0, 1500.0F, 0);
	}
}
	}

	void OnCollisionEnter(Collision col){
			if (col.gameObject.name == "Cube")
		{
			Destroy(col.gameObject);
		}

	}
}
