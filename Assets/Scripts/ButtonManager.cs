﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonManager : MonoBehaviour
{
    public CamController cam;
    public GameObject pauseMenu;

    public void Awake()
    {
        cam = FindObjectOfType<CamController>();

        if (SceneManager.GetActiveScene().buildIndex == 0)
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }
        else
        {
            cam = FindObjectOfType<CamController>();
        }
    }

    public void LoadLevel1()
    {
        Time.timeScale = 1;
        LoadingScreen.instance.LoadLevel(1);
    }

    public void MainMenu()
    {
        Time.timeScale = 1;
        LoadingScreen.instance.LoadLevel(0);
    }

    public void Resume()
    {
        pauseMenu.SetActive(false);
        Time.timeScale = 1;
        cam.blockMouse = true;
    }

    public void Restart()
    {
        Time.timeScale = 1;
        LoadingScreen.instance.LoadLevel(SceneManager.GetActiveScene().buildIndex);
    }

    public void Quit()
    {
        Application.Quit();
    }

    public void ToggleWindow (GameObject window)
    {
        window.SetActive(!window.activeSelf);
    }
}
