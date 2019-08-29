using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnemyScreenSpace : MonoBehaviour
{
    EnemyEntity enemy;

    public Canvas canvas;
    public HealthBar barPrefab;

    public LayerMask lm;

    HealthBar healthBar;
    Image tempHealthFill;
    Image healthFill;
    public Camera cam;
    DepthUI depthUI;

    public float timer;

    void Start()
    {
        enemy = GetComponent<EnemyEntity>();
        healthBar = Instantiate(barPrefab);
        healthBar.transform.SetParent(canvas.transform, false);
        tempHealthFill = healthBar.transform.GetChild(0).GetComponent<Image>();
        healthFill = healthBar.transform.GetChild(1).GetComponent<Image>();

        depthUI = healthBar.GetComponent<DepthUI>();
        canvas.GetComponent<ScreenSpaceCanvas>().AddToCanvas(healthBar.gameObject);
        healthBar.gameObject.SetActive(false);
        timer = 0;
        enemy.healthBar = healthBar.gameObject;

        healthBar.enemy = enemy;
    }

    void Update()
    {
        timer -= Time.deltaTime;

        Vector3 worldPos = transform.position + (Vector3.up * 1.75f);
        Vector3 screenPos = cam.WorldToScreenPoint(worldPos);
        healthBar.transform.position = screenPos;

        float distance = Vector3.Distance(worldPos, cam.transform.position);
        depthUI.depth = -distance;

        Vector3 vp = cam.WorldToViewportPoint(worldPos);

        if (timer > 0)
        {
            if (tempHealthFill.fillAmount > 0 && (vp.x >= 0 && vp.x <= 1 && vp.y >= 0 && vp.y <= 1 && vp.z > 0))
                healthBar.gameObject.SetActive(true);
            else
                healthBar.gameObject.SetActive(false);
        }
        else
            healthBar.gameObject.SetActive(false);
    }

    public IEnumerator UpdateLifeBar(float target)
    {
        bool timerRunning = true;
        float smoothTimer = 0;

        float current = tempHealthFill.fillAmount;
        healthFill.fillAmount = target;

        if (current - target <= 0.025f)
            tempHealthFill.fillAmount = target;

        while (timerRunning)
        {
            smoothTimer += Time.deltaTime;
            tempHealthFill.fillAmount = Mathf.Lerp(current, target, smoothTimer);
            if (smoothTimer > 1)
                timerRunning = false;
            yield return new WaitForEndOfFrame();
        }
    }

    void OnDestroy()
    {
        if (canvas)
            canvas.GetComponent<ScreenSpaceCanvas>().RemoveFromCanvas(healthBar.gameObject);
        Destroy(healthBar);
    }
}
