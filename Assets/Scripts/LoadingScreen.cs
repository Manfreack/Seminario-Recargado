using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LoadingScreen : MonoBehaviour
{
    public static LoadingScreen instance;
    public GameObject loadingScreen;
    Image loadingBar;

    void Awake()
    {
        MakeSingleton();
    }

    void MakeSingleton()
    {
        if (instance != null)
            Destroy(gameObject);
        else
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
    }

    public void LoadLevel(int level)
    {
        StartCoroutine(LoadLevelAsync(level));
    }

    IEnumerator LoadLevelAsync(int level)
    {
        AsyncOperation operation = SceneManager.LoadSceneAsync(level);
        loadingScreen.SetActive(true);
        loadingBar = loadingScreen.transform.GetChild(0).GetComponent<Image>();

        while (!operation.isDone)
        {
            float progress = operation.progress;
            loadingBar.fillAmount = progress;
            if (progress >= 1)
                loadingScreen.SetActive(false);
            yield return null;
        }
    }
}
