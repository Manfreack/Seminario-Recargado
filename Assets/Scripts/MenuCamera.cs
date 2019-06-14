using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MenuCamera : MonoBehaviour
{
    public float titleTime;
    GameObject title;
    public GameObject buttons;
    public Camera mainCamera;
    public List<Transform> positions;
    public List<Vector2> rotations;
    public RawImage startFade;
    public float timeToRotate;
    int cameraIndex;

    void Awake()
    {
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;

        title = transform.GetChild(0).gameObject;
        StartCoroutine(TitleEffect());
        StartCoroutine(TitleFlame());
        cameraIndex = 0;
        startFade.enabled = true;

        StartCoroutine(RotateCamera());
    }

    public IEnumerator StartGame()
    {
        buttons.SetActive(false);
        startFade.CrossFadeAlpha(1, 2, false);
        yield return new WaitForSeconds(3);
        startFade.CrossFadeAlpha(0, 2, false);
        gameObject.SetActive(false);
    }

    IEnumerator RotateCamera()
    {
        bool fading = false;
        float timer = 0;
        if (cameraIndex >= positions.Count) cameraIndex = 0;
        transform.position = positions[cameraIndex].position;
        transform.rotation = positions[cameraIndex].rotation;
        Vector3 initialRot = transform.rotation.eulerAngles;
        initialRot.y = rotations[cameraIndex].x;
        Vector3 targetRot = transform.rotation.eulerAngles;
        targetRot.y = rotations[cameraIndex].y;
        startFade.CrossFadeAlpha(0, 1, false);

        while (timer < timeToRotate)
        {
            timer += Time.deltaTime;
            transform.rotation = Quaternion.Euler(Vector3.Lerp(initialRot, targetRot, timer / timeToRotate));
            if (!fading && timer > timeToRotate - 1)
            {
                startFade.CrossFadeAlpha(1, 1, false);
                fading = true;
            }
            yield return new WaitForEndOfFrame();
        }

        cameraIndex++;
        StartCoroutine(RotateCamera());
    }

    IEnumerator TitleEffect()
    {
        Material titleMat = title.GetComponent<Renderer>().material;
        float timer = titleTime * 0.3f;
        while (timer < titleTime)
        {
            timer += Time.deltaTime;
            titleMat.SetFloat("_Life", timer / titleTime);
            yield return new WaitForEndOfFrame();
        }
    }

    IEnumerator TitleFlame()
    {
        GameObject flame = title.transform.GetChild(0).gameObject;
        yield return new WaitForSeconds(titleTime * 0.4f);
        flame.SetActive(true);
        buttons.SetActive(true);
    }
}
