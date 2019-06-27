using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

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
    public RawImage startFade;
    public GameObject diedMenu;

    List<EnemyEntity> enemies = new List<EnemyEntity>();

    public void Awake()
    {
        cam = FindObjectOfType<CamController>();

        enemies.AddRange(FindObjectsOfType<EnemyEntity>());

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
      /*  if (player.life <= 0 && !startRespawn) StartCoroutine(Respawn());
        if (startRespawn) RespawnScene();
        if (startFirstRespawn) RespawnFirstCheck();
        */
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
        Time.timeScale = 1;
        pause = false;
        pauseMenu.SetActive(false);
        player.transform.position = CheckTransform.position;
        player.life = player.maxLife;
        player.UpdateLife(0);
        player.stamina = player.maxStamina;
        player.UpdateStamina(0);
        player.mana = player.maxMana;       
        player.isIdle = true;
        player.isDead = false;
        player.view.anim.SetBool("IsDead", false);
        startRespawn = false;
        startFade.enabled = true;
        startFade.CrossFadeAlpha(0, 5, false);
        diedMenu.SetActive(false);
        cam.blockMouse = true;
        player.fadeTimer = 0;

        foreach (var item in enemies)
        {
            if (!item.cantRespawn)
            {
                if (item.isDead) item.gameObject.SetActive(true);
                item.Respawn();
            }
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
