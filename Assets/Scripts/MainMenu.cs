using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenu : MonoBehaviour
{
    public float titleTime;
    public GameObject title;
    public GameObject buttons;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(TitleEffect());
        StartCoroutine(TitleFlame());
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
