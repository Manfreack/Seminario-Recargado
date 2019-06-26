using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonManager : MonoBehaviour, ICheckObserver
{
    public Transform CheckTransform;
    public Transform firstCheck;
    public Model player;
    public CamController cam;
    public GameObject pauseMenu;
    public GameObject buttonRespawn;
    bool _GameOver;
    public bool Starting;
    public bool startRespawn;
    public bool pause;
    public bool startFirstRespawn;

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
    public void Update()
    {
        if (player.life <= 0 && !startRespawn) StartCoroutine(Respawn());
        if (startRespawn) RespawnScene();
        if (startFirstRespawn) RespawnFirstCheck();
    }
    public void OnNotify(Transform check)
    {
        CheckTransform = check;
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
        pause = false;
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

 

    public IEnumerator Respawn()
    {
        yield return new WaitForSeconds(1.5f);
        if (!_GameOver)
        {
            _GameOver = true;
        }
        buttonRespawn.SetActive(true);

    }

    public void RespawnFirstCheck()
    {
        buttonRespawn.SetActive(false);
        pauseMenu.SetActive(false);

        Starting = true;    

        if (Starting)
        {
            player.transform.position = firstCheck.transform.position;
            player.isIdle = true;
            player.life = 100;
            player.mana = 100;
            player.stamina = 100;
            player.maxLife = 100;
            player.maxMana = 100;
            player.maxStamina = 100;
            player.isDead = false;
        }
    }

    public void RespawnScene()
    {
       // buttonRespawn.SetActive(false);
        pauseMenu.SetActive(false);

        if (Starting)
        {            
            player.transform.position = CheckTransform.transform.position;
            player.life = player.maxLife;
            player.life = player.maxStamina;
            player.mana = player.maxMana;
            player.isIdle = true;
            player.isDead = false;

            startRespawn = false;
        }
    }

    public void StartRespawn()
    {
        Time.timeScale = 1;
        pause = false;
        startRespawn = true;
    }

    public void StartFirstRespawn()
    {
        Time.timeScale = 1;
        pause = false;
        startFirstRespawn = true;
    }
 
}
