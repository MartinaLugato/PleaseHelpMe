using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlatformController : MonoBehaviour
{
    [Header("Mud Platform")]
    [SerializeField] MudEnigma mudEnigma;

    [Header("Time Settings")]
    [SerializeField] float timeBeforeDeactivated;

    [SerializeField] Material emissiveMaterial;
    Renderer renderers;

    private void Update()
    {
        renderers = GetComponent<Renderer>();
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Rover"))
        {
            mudEnigma.RemovePlatform(gameObject);
            emissiveMaterial.SetFloat("_Emissive", 1);
            StartCoroutine(Deactive());
        }
    }

    IEnumerator Deactive()
    {
        yield return new WaitForSeconds(timeBeforeDeactivated);
        emissiveMaterial.SetFloat("_Emissive", 0);
        mudEnigma.AddPlatform(gameObject);
    }
}

